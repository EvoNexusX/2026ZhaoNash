classdef MPDMP17 < MPDMP
% Three corner regions with no common solution
% 3 decision makers, each DM has 2 objectives
    methods
        function obj = MPDMP17()
            obj.Map = ThreeCorners();
            obj.Metric = {@IGD};
            obj.M = 6;
            obj.DM = {1:2, 3:4, 5:6};  % 3个DM，每个2个目标
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

