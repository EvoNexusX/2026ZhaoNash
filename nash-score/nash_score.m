function [score, details] = nash_score(PopObj, PF, dm_num, epsilon_values, lambda, varargin)
%NASH_SCORE Compute the Nash Score for a multi-party multi-objective solution set.
%
%   SCORE = NASH_SCORE(PopObj, PF, DM_NUM, EPSILON, LAMBDA) evaluates a
%   candidate population PopObj against the union Pareto front PF for a
%   problem with DM_NUM decision makers. EPSILON is a 1-by-DM_NUM vector of
%   concession thresholds. LAMBDA is a user-defined penalty weight (scalar
%   applied to all decision makers, or a 1-by-DM_NUM vector).
%
%   [SCORE, DETAILS] = NASH_SCORE(...) also returns per-decision-maker
%   diagnostics (convergence, penalty, loss, utility, etc.).
%
%   Name-value pairs (optional):
%       'Metric'         - 'IGD' (default) or 'GD'
%       'ObjPerDM'       - objectives per decision maker; inferred from
%                          size(PF,2)/dm_num when omitted
%       'PFSampleSize'   - max PF points used for sampling (default: 2000)
%       'OffsetPFSample' - max PF points for offset computation (default: 5000)
%
%   Nash Score definition (higher is better, no post-hoc normalization):
%     1. Offset from point x to PF point y:
%            max_i |f_i(x) - f_i(y)| / f_i_max
%     2. Offset from x to PF: min over all y on PF
%     3. max_offset_m: max offset from other DMs' PFs to DM m's PF
%     4. Concession epsilon_m(v) = offset(v, PF_m) / max_offset_m
%     5. Penalty phi(epsilon) = max(0, epsilon - epsilon_threshold)
%     6. mu_ref_m: max distance from any point on other DMs' PFs to PF_m
%        (defaults to 1 in normalized space when zero)
%     7. Point penalty: ell_m^pen(v) = mu_ref_m * phi(epsilon_m(v))
%     8. Population penalty: L_m^pen = mean(ell_m^pen)
%     9. Total loss: L_m = mu_m + lambda_m * L_m^pen
%    10. Utility: utility_m = exp(-L_m)
%    11. Nash Score = prod(utility_m)
%
%   Inputs:
%       PopObj         - [n_pop x M] objective matrix of the candidate set
%       PF             - [n_pf  x M] union Pareto front (all objectives)
%       dm_num         - number of decision makers
%       epsilon_values - [1 x dm_num] concession thresholds
%       lambda         - penalty weight(s); scalar or [1 x dm_num] vector
%
%   Outputs:
%       score   - scalar Nash Score (product of decision-maker utilities)
%       details - struct with fields per decision maker and aggregates

    p = inputParser;
    addRequired(p, 'PopObj', @(x) isnumeric(x) && ismatrix(x));
    addRequired(p, 'PF', @(x) isnumeric(x) && ismatrix(x));
    addRequired(p, 'dm_num', @(x) isnumeric(x) && isscalar(x) && x >= 1);
    addRequired(p, 'epsilon_values', @(x) isnumeric(x) && isvector(x));
    addRequired(p, 'lambda', @(x) isnumeric(x) && isvector(x));
    addParameter(p, 'Metric', 'IGD', @(x) any(strcmpi(x, {'IGD', 'GD'})));
    addParameter(p, 'ObjPerDM', [], @(x) isempty(x) || (isnumeric(x) && isscalar(x) && x >= 1));
    addParameter(p, 'PFSampleSize', 2000, @(x) isnumeric(x) && isscalar(x) && x >= 1);
    addParameter(p, 'OffsetPFSample', 5000, @(x) isnumeric(x) && isscalar(x) && x >= 1);
    parse(p, PopObj, PF, dm_num, epsilon_values, lambda, varargin{:});

    metric = p.Results.Metric;
    lambda_penalty = p.Results.lambda(:)';
    pf_sample_size = round(p.Results.PFSampleSize);
    offset_pf_sample = round(p.Results.OffsetPFSample);
    dm_num = round(dm_num);

    PopObj = sanitize_objectives(PopObj);
    PF = sanitize_objectives(PF);

    if isempty(PopObj) || isempty(PF)
        score = 0;
        details = empty_details(dm_num);
        return;
    end

    M = size(PF, 2);
    if size(PopObj, 2) ~= M
        error('nash_score:DimMismatch', ...
            'PopObj has %d objectives but PF has %d.', size(PopObj, 2), M);
    end

    if mod(M, dm_num) ~= 0
        error('nash_score:InvalidLayout', ...
            'Total objective count (%d) must be divisible by dm_num (%d).', M, dm_num);
    end

    if isempty(p.Results.ObjPerDM)
        obj_per_dm = M / dm_num;
    else
        obj_per_dm = p.Results.ObjPerDM;
        if obj_per_dm * dm_num ~= M
            error('nash_score:InvalidObjPerDM', ...
                'ObjPerDM (%d) * dm_num (%d) must equal M (%d).', obj_per_dm, dm_num, M);
        end
    end

    epsilon_values = epsilon_values(:)';
    if numel(epsilon_values) ~= dm_num
        error('nash_score:InvalidEpsilon', ...
            'epsilon_values length (%d) must equal dm_num (%d).', numel(epsilon_values), dm_num);
    end

    if isscalar(lambda_penalty)
        lambda_penalty = repmat(lambda_penalty, 1, dm_num);
    elseif numel(lambda_penalty) ~= dm_num
        error('nash_score:InvalidLambda', ...
            'lambda must be a scalar or a vector of length dm_num (%d).', dm_num);
    end

    if any(lambda_penalty < 0)
        error('nash_score:InvalidLambda', 'lambda values must be non-negative.');
    end

    [score, details] = compute_nash_score(PopObj, PF, dm_num, obj_per_dm, ...
        metric, epsilon_values, lambda_penalty, pf_sample_size, offset_pf_sample);
end

function [score, details] = compute_nash_score(PopObj, PF, dm_num, obj_per_dm, ...
        metric, epsilon_values, lambda_penalty, pf_sample_size, offset_pf_sample)

    pf_per_dm = cell(1, dm_num);
    pop_per_dm = cell(1, dm_num);
    for dm = 1:dm_num
        cols = (dm - 1) * obj_per_dm + 1 : dm * obj_per_dm;
        pf_per_dm{dm} = PF(:, cols);
        pop_per_dm{dm} = PopObj(:, cols);
    end

    fi_max = cell(1, dm_num);
    for dm = 1:dm_num
        combined = [pf_per_dm{dm}; pop_per_dm{dm}];
        fi_max{dm} = max(combined, [], 1);
        fi_max{dm}(fi_max{dm} == 0) = eps;
    end

    max_offset = zeros(1, dm_num);
    mu_ref = zeros(1, dm_num);

    for dm = 1:dm_num
        pf_dm_sampled = sample_rows(pf_per_dm{dm}, pf_sample_size);
        fm_max = fi_max{dm};

        other_offsets = [];
        other_point_distances = [];

        for other_dm = 1:dm_num
            if other_dm == dm
                continue;
            end

            other_pf_sampled = sample_rows(pf_per_dm{other_dm}, pf_sample_size);

            offsets_other_to_dm = compute_offset_to_pf( ...
                other_pf_sampled, pf_dm_sampled, fm_max, offset_pf_sample);
            other_offsets = [other_offsets; offsets_other_to_dm]; %#ok<AGROW>

            dmat = pdist2(other_pf_sampled, pf_dm_sampled);
            min_dist_per_point = min(dmat, [], 2);
            other_point_distances = [other_point_distances; min_dist_per_point]; %#ok<AGROW>
        end

        if ~isempty(other_offsets)
            max_offset(dm) = max(other_offsets);
        else
            max_offset(dm) = eps;
        end
        if max_offset(dm) == 0
            max_offset(dm) = eps;
        end

        if ~isempty(other_point_distances)
            mu_ref(dm) = max(other_point_distances);
        else
            mu_ref(dm) = 0;
        end

        if mu_ref(dm) < 1e-10
            mu_ref(dm) = 1.0;
        end
    end

    dm_utilities = zeros(1, dm_num);
    mu_m_vals = zeros(1, dm_num);
    L_pen_vals = zeros(1, dm_num);
    L_m_vals = zeros(1, dm_num);

    for dm = 1:dm_num
        pf_dm_sampled = sample_rows(pf_per_dm{dm}, pf_sample_size);
        pop_dm = pop_per_dm{dm};
        fm_max = fi_max{dm};

        switch upper(metric)
            case 'IGD'
                dmat = pdist2(pf_dm_sampled, pop_dm);
                mu_m = mean(min(dmat, [], 2));
            case 'GD'
                dmat = pdist2(pop_dm, pf_dm_sampled);
                mu_m = mean(min(dmat, [], 2));
        end

        pop_offsets = compute_offset_to_pf(pop_dm, pf_dm_sampled, fm_max, offset_pf_sample);
        concessions = pop_offsets / max_offset(dm);
        phi_values = max(0, concessions - epsilon_values(dm));
        point_penalties = mu_ref(dm) * phi_values;
        L_pen = mean(point_penalties);
        L_m = mu_m + lambda_penalty(dm) * L_pen;
        dm_utilities(dm) = exp(-L_m);

        mu_m_vals(dm) = mu_m;
        L_pen_vals(dm) = L_pen;
        L_m_vals(dm) = L_m;
    end

    score = prod(dm_utilities);

    if nargout >= 2
        details = struct();
        details.metric = upper(metric);
        details.lambda = lambda_penalty;  % [1 x dm_num]
        details.epsilon_threshold = epsilon_values;
        details.max_offset = max_offset;
        details.mu_ref = mu_ref;
        details.mu_m = mu_m_vals;
        details.L_pen = L_pen_vals;
        details.L_m = L_m_vals;
        details.utility = dm_utilities;
        details.dm_num = dm_num;
        details.obj_per_dm = obj_per_dm;
    end
end

function X = sanitize_objectives(X)
    X = X(~any(isnan(X) | isinf(X), 2), :);
end

function sampled = sample_rows(X, max_rows)
    if size(X, 1) > max_rows
        sample_idx = randperm(size(X, 1), max_rows);
        sampled = X(sample_idx, :);
    else
        sampled = X;
    end
end

function details = empty_details(dm_num)
    details = struct();
    details.metric = '';
    details.lambda = NaN;
    details.epsilon_threshold = nan(1, dm_num);
    details.max_offset = nan(1, dm_num);
    details.mu_ref = nan(1, dm_num);
    details.mu_m = nan(1, dm_num);
    details.L_pen = nan(1, dm_num);
    details.L_m = nan(1, dm_num);
    details.utility = nan(1, dm_num);
    details.dm_num = dm_num;
    details.obj_per_dm = NaN;
end
