classdef MPMOP17< PROBLEM
% <problem> <MPMOP>
% Three-party, 2 objectives each (M=6). Each party has a distinct g-minimum
% at different constants in x2..D (0.0 vs 0.5 vs 1.0), so the PS sets do not intersect.
    methods
        %% Initialization
        function obj = MPMOP17()
            obj.Global.M = 6;           % 2 objectives per party, 3 parties
            if isempty(obj.Global.D)
                obj.Global.D = 10;
            end
            obj.Global.lower    = zeros(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.DM=3;
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values for each party
        function PopObj = CalObj(obj,PopDec)
            M=obj.Global.M;
            PopObj(:,1:M/3)           = MPMOP_Value('MPMOP17', PopDec(), 0.0);  % Party 1: c=0.0
            PopObj(:,M/3+1:2*M/3)     = MPMOP_Value('MPMOP17', PopDec(), 0.5);  % Party 2: c=0.5
            PopObj(:,2*M/3+1:M)       = MPMOP_Value('MPMOP17', PopDec(), 1.0);  % Party 3: c=1.0
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t = [0.0, 0.5, 1.0];
            num_points = 200;
            x1 = linspace(0,1,num_points)';
            D = obj.Global.D;
            % Party 1: c = 0.0
            X1 = zeros(num_points, D);
            X1(:,1) = x1;
            X1(:,2:end) = 0.0;
            Y1 = MPMOP_Value('MPMOP17', X1, t(1));
            % Party 2: c = 0.5
            X2 = zeros(num_points, D);
            X2(:,1) = x1;
            X2(:,2:end) = 0.5;
            Y2 = MPMOP_Value('MPMOP17', X2, t(2));
            % Party 3: c = 1.0
            X3 = zeros(num_points, D);
            X3(:,1) = x1;
            X3(:,2:end) = 1.0;
            Y3 = MPMOP_Value('MPMOP17', X3, t(3));
            P = [Y1, Y2, Y3];
        end
        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            % Return the union of each party's PS; they are disjoint by design
            P = [];
        end
    end
end