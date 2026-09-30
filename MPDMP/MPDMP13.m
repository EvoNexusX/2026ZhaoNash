classdef MPDMP13 < MPDMP
% Two parallel horizontal lines with no common solution
    methods
        function obj = MPDMP13()
            obj.Map = ParallelLines1();
            obj.Metric = {@IGD};
            % 2个决策者，每个DM有2个目标（x和y分量）
            obj.M = 4;
            obj.DM = {1:2, 3:4};  % DM1看obj1-2, DM2看obj3-4
            obj.initialize();
        end

        %% PF
        function P = PF(obj)
            P = obj.Map.PF();
        end

        %% draw the point
        function Draw(obj, PopDec, FrontNo, caption)
            fig = figure();
            clf;
            obj.Map.Draw();
            hold on;
            gscatter(PopDec(:, 1), PopDec(:, end), FrontNo');
            xlabel('x_1');
            ylabel('x_2');
            axis([20 80 20 80]);
            title(caption);
            hold off;
        end
    end
end

