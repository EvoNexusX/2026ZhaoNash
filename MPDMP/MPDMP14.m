classdef MPDMP14 < MPDMP
% Two parallel vertical lines with no common solution
% Each DM has 3 objectives
    methods
        function obj = MPDMP14()
            obj.Map = ParallelLines2();
            obj.Metric = {@IGD};
            obj.M = 6;
            obj.DM = {1:3, 4:6};  % 每个DM 3个目标
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

