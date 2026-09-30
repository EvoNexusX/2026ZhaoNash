classdef ParallelDiagonals
    % Two parallel diagonal lines with no intersection
    % DM1's PS: diagonal line from [30, 45] to [55, 70]
    % DM2's PS: diagonal line from [45, 30] to [70, 55]
    
    properties
        % Line 1 for DM1
        Line1_Start = [30, 45];
        Line1_End = [55, 70];
        % Line 2 for DM2
        Line2_Start = [45, 30];
        Line2_End = [70, 55];
    end
    
    methods
        function obj = ParallelDiagonals()
        end
        
        function distance = EuclideanDistance(obj, point)
            % Distance to Line1 (for DM1)
            n_points = size(point, 1);
            dist1 = zeros(n_points, 1);
            v1 = obj.Line1_End - obj.Line1_Start;
            for i = 1:n_points
                w = point(i,:) - obj.Line1_Start;
                t = max(0, min(1, dot(w, v1) / dot(v1, v1)));
                projection = obj.Line1_Start + t * v1;
                dist1(i) = norm(point(i,:) - projection);
            end
            
            % Distance to Line2 (for DM2)
            dist2 = zeros(n_points, 1);
            v2 = obj.Line2_End - obj.Line2_Start;
            for i = 1:n_points
                w = point(i,:) - obj.Line2_Start;
                t = max(0, min(1, dot(w, v2) / dot(v2, v2)));
                projection = obj.Line2_Start + t * v2;
                dist2(i) = norm(point(i,:) - projection);
            end
            
            distance = [dist1, dist2];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 计算两条平行对角线之间的距离
            % 两条线的中点
            mid1 = (obj.Line1_Start + obj.Line1_End) / 2;
            mid2 = (obj.Line2_Start + obj.Line2_End) / 2;
            line_dist = norm(mid2 - mid1);
            
            % 2目标PF：从(0,d)到(d,0)的线
            n = 100;
            t = linspace(0, 1, n)';
            dist1_pf = t * line_dist;
            dist2_pf = (1-t) * line_dist;
            p = [dist1_pf, dist2_pf];
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            plot([obj.Line1_Start(1), obj.Line1_End(1)], ...
                 [obj.Line1_Start(2), obj.Line1_End(2)], 'r-', 'LineWidth', 2);
            plot([obj.Line2_Start(1), obj.Line2_End(1)], ...
                 [obj.Line2_Start(2), obj.Line2_End(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

