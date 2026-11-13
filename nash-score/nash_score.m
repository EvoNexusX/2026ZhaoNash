function [score, details] = nash_score(PopObj, PF, dm_num, gamma_threshold, lambda, varargin)
%NASH_SCORE Compute a fairness-aware Nash product for multiple decision makers.
% POPOBJ: contiguous objective blocks for each DM. PF: cell of individual
% fronts, or matrix of contiguous individual-front blocks (not a joint PF).
% Required name-value pairs: 'C' (fixed common utility constant),
% 'ObjectiveScale' (fixed positive scales for all objective columns), and
% either 'ReferenceSets' (cell {j}=F(PS_j), evaluated for ALL DMs) or 'Delta'
% (precomputed reference deviations). Never compare different DMs' PFs directly.
% Optional: 'Metric' ('IGD' default or 'GD'); 'ObjPerDM' (scalar or vector).
% Concessions use normalized Chebyshev distance. IGD/GD use Euclidean
% distances in supplied objective units. No random sampling is performed.
% lambda and Delta must be strictly positive; C must exceed total losses.
% Each candidate row contributes to the accumulated penalty.
    p = inputParser;
    addParameter(p,'C',[]);
    addParameter(p,'ObjectiveScale',[]);
    addParameter(p,'ReferenceSets',{});
    addParameter(p,'Delta',[]);
    addParameter(p,'Metric','IGD');
    addParameter(p,'ObjPerDM',[]);
    parse(p,varargin{:});
    validateattributes(PopObj,{'numeric'},{'real','finite','2d','nonempty'});
    validateattributes(dm_num,{'numeric'},{'real','finite','scalar','integer','>=',2});
    PopObj = double(PopObj);
    K = size(PopObj,2);
    counts = p.Results.ObjPerDM;
    if isempty(counts)
        if iscell(PF)
            counts = cellfun(@(x) size(x,2),PF);
        else
            if mod(K,dm_num) ~= 0
                error('nash_score:MissingObjPerDM', ...
                    'For unequal objective counts, supply ObjPerDM (e.g. [2 3]) or a cell PF with one front per DM.');
            end
            counts = repmat(K/dm_num,1,dm_num);
        end
    elseif isscalar(counts)
        counts = repmat(counts,1,dm_num);
    end
    validateattributes(counts,{'numeric'},{'real','finite','vector','integer','positive','numel',dm_num});
    counts = double(counts(:)');
    if sum(counts) ~= K
        error('nash_score:InvalidLayout','ObjPerDM must sum to the objective count.');
    end
    edges = [0 cumsum(counts)];
    if ~iscell(PF)
        validateattributes(PF,{'numeric'},{'real','finite','2d','nonempty','ncols',K});
        PF = arrayfun(@(m) PF(:,edges(m)+1:edges(m+1)),1:dm_num,'UniformOutput',false);
    end
    if numel(PF) ~= dm_num
        error('nash_score:InvalidPF','PF must contain one individual front per DM.');
    end
    for m = 1:dm_num
        validateattributes(PF{m},{'numeric'},{'real','finite','2d','nonempty','ncols',counts(m)});
        PF{m} = double(PF{m});
    end
    validateattributes(gamma_threshold,{'numeric'},{'real','finite','vector','numel',dm_num,'>=',0,'<=',1});
    validateattributes(lambda,{'numeric'},{'real','finite','vector','positive','nonempty'});
    if isscalar(lambda), lambda = repmat(lambda,1,dm_num); end
    if numel(lambda) ~= dm_num
        error('nash_score:InvalidLambda','lambda must be scalar or have one entry per DM.');
    end
    lambda = double(lambda(:)');
    gamma_threshold = double(gamma_threshold(:)');
    C = p.Results.C;
    if isempty(C)
        error('nash_score:MissingC','Supply a fixed common C greater than all compared total losses.');
    end
    validateattributes(C,{'numeric'},{'real','finite','scalar','positive'});
    scale = p.Results.ObjectiveScale;
    if isempty(scale)
        error('nash_score:MissingScale','Supply fixed positive ObjectiveScale for all objective columns.');
    end
    validateattributes(scale,{'numeric'},{'real','finite','vector','numel',K,'positive'});
    scale = double(scale(:)');
    metric = validatestring(p.Results.Metric,{'IGD','GD'});
    delta = p.Results.Delta;
    refs = p.Results.ReferenceSets;
    if ~isempty(delta) && ~isempty(refs)
        error('nash_score:AmbiguousReference','Supply either ReferenceSets or Delta, not both.');
    end
    if isempty(delta)
        if ~iscell(refs) || numel(refs) ~= dm_num
            error('nash_score:MissingReference','Supply ReferenceSets{j}=F(PS_j), or precomputed Delta.');
        end
        for j = 1:dm_num
            validateattributes(refs{j},{'numeric'},{'real','finite','2d','nonempty','ncols',K});
        end
        delta = zeros(1,dm_num);
        for m = 1:dm_num
            cols = edges(m)+1:edges(m+1);
            for j = 1:dm_num
                if j ~= m
                    % PS_j must be evaluated through F_m, in DM m's space.
                    offsets = compute_offset_to_pf(double(refs{j}(:,cols)),PF{m},scale(cols));
                    delta(m) = max(delta(m),max(offsets));
                end
            end
        end
    end
    validateattributes(delta,{'numeric'},{'real','finite','vector','numel',dm_num,'nonnegative'});
    delta = double(delta(:)');
    if any(delta == 0)
        error('nash_score:DegenerateDelta', ...
            'Delta must be positive to compute concessions. Check the cross-evaluated reference sets.');
    end
    gamma = zeros(size(PopObj,1),dm_num);
    loss = zeros(1,dm_num);
    for m = 1:dm_num
        cols = edges(m)+1:edges(m+1);
        points = PopObj(:,cols);
        if strcmp(metric,'IGD')
            loss(m) = mean(nearest_euclidean(PF{m},points));
        else
            loss(m) = mean(nearest_euclidean(points,PF{m}));
        end
        offsets = compute_offset_to_pf(points,PF{m},scale(cols));
        gamma(:,m) = offsets/delta(m);
    end
    violation = max(0,bsxfun(@minus,gamma,gamma_threshold));
    penalty = sum(violation,1);
    total_loss = loss + lambda.*penalty;
    utility = C-total_loss;
    if any(~isfinite(total_loss)) || any(utility <= 0)
        error('nash_score:NonpositiveUtility', ...
            'C must exceed every total loss (largest: %.17g). Use the SAME C for every compared set.',max(total_loss));
    end
    score = prod(utility);
    details = struct('metric',metric,'C',C,'lambda',lambda, ...
        'gamma_threshold',gamma_threshold,'objective_scale',scale,'delta',delta, ...
        'concession',gamma,'violation',violation,'L_base',loss, ...
        'L_pen',penalty,'L_total',total_loss,'utility',utility, ...
        'log_score',sum(log(utility)),'meanIGD',NaN, ...
        'dm_num',dm_num,'obj_per_dm',counts);
    if strcmp(metric,'IGD'), details.meanIGD = mean(loss); end
end

function distances = nearest_euclidean(points,reference)
% Bounded working memory, without Statistics and Machine Learning Toolbox.
    distances = zeros(size(points,1),1);
    for i = 1:size(points,1)
        diff = bsxfun(@minus,reference,points(i,:));
        distances(i) = min(sqrt(sum(diff.^2,2)));
    end
end
