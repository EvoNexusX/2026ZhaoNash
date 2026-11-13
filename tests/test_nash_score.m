function test_nash_score
% Analytical regression checks for the paper equations and reference mapping.
    root = fileparts(fileparts(mfilename('fullpath')));
    addpath(fullfile(root,'nash-score'));
    PF = {[0 0],[0 0]};
    refs = {[0 0 1 1],[1 1 0 0]};
    args = {'C',10,'ObjectiveScale',ones(1,4),'ReferenceSets',refs};
    P = [0.5 0.5 0.5 0.5];
    [s,d] = nash_score(P,PF,2,[0.25 0.25],2,args{:});
    close_to(d.delta,[1 1]); % own fronts coincide, but PSs are different!
    close_to(d.concession,[0.5 0.5]);
    close_to(d.L_pen,[0.25 0.25]);
    close_to(d.L_base,sqrt(0.5)*[1 1]);
    close_to(s,(10-sqrt(0.5)-0.5)^2);
    close_to(d.log_score,log(s));
    [~,twice] = nash_score([P;P],PF,2,[0.25 0.25],2,args{:});
    close_to(twice.L_pen,2*d.L_pen); % SUM penalty, not mean
    [~,relaxed] = nash_score(P,PF,2,[0.5 0.5],2,args{:});
    close_to(relaxed.L_pen,[0 0]);
    [explicit,~] = nash_score(P,PF,2,[0.25 0.25],2, ...
        'C',10,'ObjectiveScale',ones(1,4),'Delta',[1 1]);
    close_to(explicit,s);
    % DM permutation must carry fronts, scales, references and parameters.
    Q = [0.2 0.2 0.8 0.8];
    [a,~] = nash_score(Q,PF,2,[0.1 0.3],[2 3],args{:});
    perm = [3 4 1 2];
    refperm = {refs{2}(:,perm),refs{1}(:,perm)};
    b = nash_score(Q(:,perm),PF([2 1]),2,[0.3 0.1],[3 2], ...
        'C',10,'ObjectiveScale',ones(1,4),'ReferenceSets',refperm);
    close_to(a,b);
    % Same summed base loss, balanced linear utilities yield larger product.
    balanced = nash_score(P,PF,2,[1 1],1,args{:});
    biased = nash_score([0 0 1 1],PF,2,[1 1],1,args{:});
    assert(balanced > biased);
    % IGD and GD directions, matrix PF and unequal per-DM dimensions.
    [~,igd] = nash_score([0 0],{[0;2],0},2,[1 1],1, ...
        'C',10,'ObjectiveScale',[1 1],'Delta',[2 2]);
    [~,gd] = nash_score([0 0],{[0;2],0},2,[1 1],1, ...
        'C',10,'ObjectiveScale',[1 1],'Delta',[2 2],'Metric','GD');
    close_to(igd.L_base,[1 0]); close_to(gd.L_base,[0 0]);
    close_to(nash_score(P,[0 0 0 0],2,[0.25 0.25],2,args{:}),s);
    [~,het] = nash_score(0.5*ones(1,6),{0,[0 0],[0 0 0]},3,[1 1 1],1, ...
        'C',10,'ObjectiveScale',ones(1,6),'Delta',[1 1 1]);
    close_to(het.obj_per_dm,[1 2 3]);
    close_to(het.L_base,0.5*sqrt([1 2 3]));
    % MPDMP3 objective layout: DM1 has 2 objectives; DM2 has 3.
    [~,mpdmp3] = nash_score(0.5*ones(1,5),{[0 0],[0 0 0]},2,[1 1],1, ...
        'C',10,'ObjectiveScale',ones(1,5),'Delta',[1 1]);
    close_to(mpdmp3.obj_per_dm,[2 3]);
    close_to(mpdmp3.L_base,0.5*sqrt([2 3]));
    close_to(compute_offset_to_pf([1 4;0 0],[0 0],[2 4]),[1;0]);
    rng(27); state = rng;
    nash_score(P,PF,2,[0.25 0.25],2,args{:});
    assert(isequal(state,rng)); % exact evaluation leaves RNG unchanged
    must_fail(@() nash_score(P,PF,2,[0 0],2,'C',0.1, ...
        'ObjectiveScale',ones(1,4),'Delta',[1 1]),'nash_score:NonpositiveUtility');
    must_fail(@() nash_score(P,PF,2,[0 0],2,'C',10, ...
        'ObjectiveScale',ones(1,4),'Delta',[0 0]),'nash_score:DegenerateDelta');
    must_fail(@() nash_score(P,PF,2,[0 0],2,'C',10, ...
        'ObjectiveScale',ones(1,4)),'nash_score:MissingReference');
    must_fail(@() nash_score(zeros(1,4),PF,2,[0 0],2,'C',10, ...
        'ObjectiveScale',ones(1,4),'Delta',[0 0]),'nash_score:DegenerateDelta');
    must_fail(@() nash_score(P,PF,2,[0 0],0,args{:}),'');
    must_fail(@() nash_score([NaN 0 0 0],PF,2,[0 0],2,args{:}),'');
    must_fail(@() nash_score(P,PF,2,[1.1 0],2,args{:}),'');
    fprintf('All Nash-score regression checks passed.\n');
end
function close_to(actual,expected)
    assert(isequal(size(actual),size(expected)) && ...
        all(abs(actual(:)-expected(:)) < 1e-10),'Analytical result mismatch.');
end
function must_fail(f,id)
    try
        f();
    catch e
        assert(isempty(id) || strcmp(e.identifier,id),'Unexpected error: %s',e.identifier);
        return;
    end
    error('test_nash_score:ExpectedError','Expected validation failure.');
end
