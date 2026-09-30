classdef MPDMP16 < MPDMP
% Two diagonal points with no common solution
% Each DM has 5 objectives
    methods
        function obj = MPDMP16()
            obj.Map = DiagonalPoints();
            obj.Metric = {@IGD};
            obj.M = 10;
            obj.DM = {1:5, 6:10};  % 每个DM 5个目标
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

