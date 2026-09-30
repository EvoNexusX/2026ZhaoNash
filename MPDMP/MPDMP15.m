classdef MPDMP15 < MPDMP
% Two non-overlapping square regions with no common solution
% Each DM has 4 objectives
    methods
        function obj = MPDMP15()
            obj.Map = TwoSquares();
            obj.Metric = {@IGD};
            obj.M = 8;
            obj.DM = {1:4, 5:8};  % 每个DM 4个目标
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

