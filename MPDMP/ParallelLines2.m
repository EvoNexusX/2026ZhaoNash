classdef ParallelLines2
    % Two triangular regions with no intersection
    % DM1's PS: Triangle with 3 vertices (3 objectives)
    % DM2's PS: Triangle with 3 vertices (3 objectives)
    
    properties
        % Triangle 1 for DM1 (3 vertices)
        Tri1_P1 = [30, 35];
        Tri1_P2 = [50, 35];
        Tri1_P3 = [40, 50];
        % Triangle 2 for DM2 (3 vertices)
        Tri2_P1 = [50, 50];
        Tri2_P2 = [70, 50];
        Tri2_P3 = [60, 65];
    end
    
    methods
        function obj = ParallelLines2()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Triangle1三个顶点的欧氏距离 (3个目标)
            dist1_1 = sqrt(sum((point - obj.Tri1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Tri1_P2).^2, 2));
            dist1_3 = sqrt(sum((point - obj.Tri1_P3).^2, 2));
            
            % DM2: 到Triangle2三个顶点的欧氏距离 (3个目标)
            dist2_1 = sqrt(sum((point - obj.Tri2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Tri2_P2).^2, 2));
            dist2_3 = sqrt(sum((point - obj.Tri2_P3).^2, 2));
            
            % 6目标：每个DM有3个目标
            distance = [dist1_1, dist1_2, dist1_3, dist2_1, dist2_2, dist2_3];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 6目标PF
            n = 100;
            % 在Triangle1内部的点（重心附近）
            center1 = (obj.Tri1_P1 + obj.Tri1_P2 + obj.Tri1_P3) / 3;
            center2 = (obj.Tri2_P1 + obj.Tri2_P2 + obj.Tri2_P3) / 3;
            
            t = linspace(0, 1, n)';
            pf_points = zeros(n, 6);
            for i = 1:n
                pt = (1-t(i)) * center1 + t(i) * center2;
                pf_points(i, :) = [sqrt(sum((pt - obj.Tri1_P1).^2)), ...
                                   sqrt(sum((pt - obj.Tri1_P2).^2)), ...
                                   sqrt(sum((pt - obj.Tri1_P3).^2)), ...
                                   sqrt(sum((pt - obj.Tri2_P1).^2)), ...
                                   sqrt(sum((pt - obj.Tri2_P2).^2)), ...
                                   sqrt(sum((pt - obj.Tri2_P3).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            % Draw Triangle 1
            plot([obj.Tri1_P1(1), obj.Tri1_P2(1), obj.Tri1_P3(1), obj.Tri1_P1(1)], ...
                 [obj.Tri1_P1(2), obj.Tri1_P2(2), obj.Tri1_P3(2), obj.Tri1_P1(2)], 'r-', 'LineWidth', 2);
            % Draw Triangle 2
            plot([obj.Tri2_P1(1), obj.Tri2_P2(1), obj.Tri2_P3(1), obj.Tri2_P1(1)], ...
                 [obj.Tri2_P1(2), obj.Tri2_P2(2), obj.Tri2_P3(2), obj.Tri2_P1(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

