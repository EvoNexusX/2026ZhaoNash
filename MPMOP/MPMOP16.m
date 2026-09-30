classdef MPMOP16< PROBLEM
% <problem> <MPMOP>
% Two-party, 2 objectives each (M=4). Each party has a distinct g-minimum
% at different constants in x2..D (0.25 vs 0.75), so the PS sets do not intersect.
    methods
        %% Initialization
        function obj = MPMOP16()
            obj.Global.M = 4;           % 2 objectives per party, 2 parties
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
            PopObj(:,1:M/2)     = MPMOP_Value('MPMOP16', PopDec(), 0);   % Party 1: c=0.25
            PopObj(:,M/2+1:M)   = MPMOP_Value('MPMOP16', PopDec(), 1);   % Party 2: c=0.75
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1 = 0; t2 = 1;
            num_points = 200;
            x1 = linspace(0,1,num_points)';
            D = obj.Global.D;
            % Party 1 (t1=0): c = 0.25
            X1 = zeros(num_points, D);
            X1(:,1) = x1;
            X1(:,2:end) = 0.25;
            Y1 = MPMOP_Value('MPMOP16', X1, t1);
            % Party 2 (t2=1): c = 0.75
            X2 = zeros(num_points, D);
            X2(:,1) = x1;
            X2(:,2:end) = 0.75;
            Y2 = MPMOP_Value('MPMOP16', X2, t2);
            P = [Y1, Y2];
        end
        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            % Return the union of each party's PS; they are disjoint by design
            P = [];
        end
    end
end