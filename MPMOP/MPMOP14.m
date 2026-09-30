classdef MPMOP14< PROBLEM
% <problem> <MPMOP>
    methods
        %% Initialization
        function obj = MPMOP14()
            obj.Global.M = 6;
            if isempty(obj.Global.D)
                obj.Global.D = 10;
            end
            obj.Global.lower    = zeros(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.DM=2;
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)
            M=obj.Global.M;
            PopObj(:,[1:M/2])=MPMOP_Value('MPMOP14', PopDec(), 0);
            PopObj(:,[M/2+1:M])=MPMOP_Value('MPMOP14', PopDec(), 1);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1 = 0; t2 = 1;
            n = 40;
            u = linspace(0,1,n);
            [U1,U2] = meshgrid(u,u);
            D = obj.Global.D;
            N = numel(U1);
            % Party 1 (t1=0): c = 1 -> set x3..D = 1
            X1 = zeros(N, D);
            X1(:,1) = U1(:);
            X1(:,2) = U2(:);
            X1(:,3:end) = 1;
            Y1 = MPMOP_Value('MPMOP14', X1, t1);
            % Party 2 (t2=1): c = 0 -> set x3..D = 0
            X2 = zeros(N, D);
            X2(:,1) = U1(:);
            X2(:,2) = U2(:);
            X2(:,3:end) = 0;
            Y2 = MPMOP_Value('MPMOP14', X2, t2);
            P = [Y1, Y2];
        end
        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            t1=0; t2=1;
            P=true_PS(obj.Global.D,'MPMOP14',t1,t2);
        end
    end
end


