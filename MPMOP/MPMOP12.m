classdef MPMOP12< PROBLEM
% <problem> <MPMOP>
    methods
        %% Initialization
        function obj = MPMOP12()
            obj.Global.M = 4;
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
            PopObj(:,[1:M/2])=MPMOP_Value('MPMOP12', PopDec(), 0);
            PopObj(:,[M/2+1:M])=MPMOP_Value('MPMOP12', PopDec(), 1);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj)
            t1 = 0; t2 = 1;
            num_points = 200;
            x1 = linspace(0,1,num_points)';
            D = obj.Global.D;
            % Party 1 (t1=0): c = (t<0.5) -> 1, set x2..D = 1
            X1 = zeros(num_points, D);
            X1(:,1) = x1;
            X1(:,2:end) = 1;
            Y1 = MPMOP_Value('MPMOP12', X1, t1);
            % Party 2 (t2=1): c = 0, set x2..D = 0
            X2 = zeros(num_points, D);
            X2(:,1) = x1;
            X2(:,2:end) = 0;
            Y2 = MPMOP_Value('MPMOP12', X2, t2);
            P = [Y1, Y2];
        end
        %% Sample reference points on Pareto optimal set
        function P = PS(obj)
            t1=0; t2=1;
            P = true_PS(obj.Global.D,'MPMOP12',t1,t2);
        end
    end
end


