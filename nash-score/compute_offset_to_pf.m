function offsets = compute_offset_to_pf(points, pf, f_max, max_pf_size)
%COMPUTE_OFFSET_TO_PF Normalized Chebyshev offset from points to a PF.
%
%   OFFSETS = COMPUTE_OFFSET_TO_PF(POINTS, PF, F_MAX) returns, for each row
%   in POINTS, the minimum offset to any point on PF:
%
%       offset(x, y) = max_i |f_i(x) - f_i(y)| / f_i_max
%       offset(x, PF) = min_{y in PF} offset(x, y)
%
%   F_MAX is a 1-by-n_obj vector of per-objective normalization factors
%   (typically the maximum objective value in the feasible range).
%
%   OFFSETS = COMPUTE_OFFSET_TO_PF(..., MAX_PF_SIZE) optionally subsamples PF
%   to at most MAX_PF_SIZE points for faster computation (default: 5000).

    if nargin < 4
        max_pf_size = 5000;
    end

    n_points = size(points, 1);
    n_pf = size(pf, 1);
    n_obj = size(points, 2);

    if n_points == 0
        offsets = zeros(0, 1);
        return;
    end

    if n_pf == 0
        offsets = inf(n_points, 1);
        return;
    end

    if numel(f_max) ~= n_obj
        error('compute_offset_to_pf:InvalidFMax', ...
            'f_max length (%d) must match objective count (%d).', numel(f_max), n_obj);
    end

    if n_pf > max_pf_size
        sample_idx = randperm(n_pf, max_pf_size);
        pf = pf(sample_idx, :);
        n_pf = max_pf_size;
    end

    points_3d = reshape(points, [n_points, 1, n_obj]);
    pf_3d = reshape(pf, [1, n_pf, n_obj]);
    f_max_3d = reshape(f_max, [1, 1, n_obj]);

    norm_diff = abs(points_3d - pf_3d) ./ f_max_3d;
    offset_matrix = max(norm_diff, [], 3);
    offsets = min(offset_matrix, [], 2);
end
