function offsets = compute_offset_to_pf(points,pf,objective_scale)
%COMPUTE_OFFSET_TO_PF Minimum normalized Chebyshev distance to sampled PF.
% D(x,PF) = min_y max_k abs(x_k-y_k)/objective_scale_k.
% Scale must be fixed, positive and shared by all compared candidate sets.
% No random PF subsampling or candidate-dependent scaling is performed.
    validateattributes(points,{'numeric'},{'real','finite','2d'});
    validateattributes(pf,{'numeric'},{'real','finite','2d','nonempty','ncols',size(points,2)});
    validateattributes(objective_scale,{'numeric'}, ...
        {'real','finite','vector','positive','numel',size(points,2)});
    points = double(points);
    pf = double(pf);
    objective_scale = double(objective_scale(:)');
    offsets = zeros(size(points,1),1);
    for i = 1:size(points,1)
        diff = abs(bsxfun(@minus,pf,points(i,:)));
        offsets(i) = min(max(bsxfun(@rdivide,diff,objective_scale),[],2));
    end
end
