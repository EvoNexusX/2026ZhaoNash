classdef MPDMP18 < MPDMP
% Three parallel diagonal lines with no common solution
% 3 decision makers, each DM has 3 objectives
    methods
        function obj = MPDMP18()
            obj.Map = ThreeDiagonals();
            obj.Metric = {@IGD};
            obj.M = 9;
            obj.DM = {1:3, 4:6, 7:9};  % 3个DM，每个3个目标
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

