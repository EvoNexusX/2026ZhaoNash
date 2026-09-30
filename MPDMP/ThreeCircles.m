classdef ThreeCircles
    % Three quadrilateral regions with no common intersection
    % DM1's PS: Quadrilateral with 4 vertices (4 objectives)
    % DM2's PS: Quadrilateral with 4 vertices (4 objectives)
    % DM3's PS: Quadrilateral with 4 vertices (4 objectives)
    
    properties
        % Quadrilateral 1 for DM1 (4 vertices) - left area
        Quad1_P1 = [25, 40];
        Quad1_P2 = [35, 35];
        Quad1_P3 = [40, 45];
        Quad1_P4 = [30, 55];
        % Quadrilateral 2 for DM2 (4 vertices) - bottom area
        Quad2_P1 = [45, 25];
        Quad2_P2 = [55, 25];
        Quad2_P3 = [60, 35];
        Quad2_P4 = [40, 35];
        % Quadrilateral 3 for DM3 (4 vertices) - right area
        Quad3_P1 = [60, 45];
        Quad3_P2 = [75, 40];
        Quad3_P3 = [75, 55];
        Quad3_P4 = [65, 60];
    end
    
    methods
        function obj = ThreeCircles()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Quadrilateral1四个顶点的欧氏距离 (4个目标)
            dist1_1 = sqrt(sum((point - obj.Quad1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Quad1_P2).^2, 2));
            dist1_3 = sqrt(sum((point - obj.Quad1_P3).^2, 2));
            dist1_4 = sqrt(sum((point - obj.Quad1_P4).^2, 2));
            
            % DM2: 到Quadrilateral2四个顶点的欧氏距离 (4个目标)
            dist2_1 = sqrt(sum((point - obj.Quad2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Quad2_P2).^2, 2));
            dist2_3 = sqrt(sum((point - obj.Quad2_P3).^2, 2));
            dist2_4 = sqrt(sum((point - obj.Quad2_P4).^2, 2));
            
            % DM3: 到Quadrilateral3四个顶点的欧氏距离 (4个目标)
            dist3_1 = sqrt(sum((point - obj.Quad3_P1).^2, 2));
            dist3_2 = sqrt(sum((point - obj.Quad3_P2).^2, 2));
            dist3_3 = sqrt(sum((point - obj.Quad3_P3).^2, 2));
            dist3_4 = sqrt(sum((point - obj.Quad3_P4).^2, 2));
            
            % 12目标：每个DM有4个目标
            distance = [dist1_1, dist1_2, dist1_3, dist1_4, ...
                        dist2_1, dist2_2, dist2_3, dist2_4, ...
                        dist3_1, dist3_2, dist3_3, dist3_4];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 12目标PF：3个DM，每个4个目标
            n = 100;
            center1 = (obj.Quad1_P1 + obj.Quad1_P2 + obj.Quad1_P3 + obj.Quad1_P4) / 4;
            center2 = (obj.Quad2_P1 + obj.Quad2_P2 + obj.Quad2_P3 + obj.Quad2_P4) / 4;
            center3 = (obj.Quad3_P1 + obj.Quad3_P2 + obj.Quad3_P3 + obj.Quad3_P4) / 4;
            
            pf_points = [];
            % 三条路径
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center1 + t * center2;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Quad1_P1).^2)), sqrt(sum((pt - obj.Quad1_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad1_P3).^2)), sqrt(sum((pt - obj.Quad1_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P1).^2)), sqrt(sum((pt - obj.Quad2_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P3).^2)), sqrt(sum((pt - obj.Quad2_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P1).^2)), sqrt(sum((pt - obj.Quad3_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P3).^2)), sqrt(sum((pt - obj.Quad3_P4).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center2 + t * center3;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Quad1_P1).^2)), sqrt(sum((pt - obj.Quad1_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad1_P3).^2)), sqrt(sum((pt - obj.Quad1_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P1).^2)), sqrt(sum((pt - obj.Quad2_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P3).^2)), sqrt(sum((pt - obj.Quad2_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P1).^2)), sqrt(sum((pt - obj.Quad3_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P3).^2)), sqrt(sum((pt - obj.Quad3_P4).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center3 + t * center1;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Quad1_P1).^2)), sqrt(sum((pt - obj.Quad1_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad1_P3).^2)), sqrt(sum((pt - obj.Quad1_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P1).^2)), sqrt(sum((pt - obj.Quad2_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad2_P3).^2)), sqrt(sum((pt - obj.Quad2_P4).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P1).^2)), sqrt(sum((pt - obj.Quad3_P2).^2)), ...
                    sqrt(sum((pt - obj.Quad3_P3).^2)), sqrt(sum((pt - obj.Quad3_P4).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            % Draw Quadrilateral 1
            plot([obj.Quad1_P1(1), obj.Quad1_P2(1), obj.Quad1_P3(1), obj.Quad1_P4(1), obj.Quad1_P1(1)], ...
                 [obj.Quad1_P1(2), obj.Quad1_P2(2), obj.Quad1_P3(2), obj.Quad1_P4(2), obj.Quad1_P1(2)], 'r-', 'LineWidth', 2);
            % Draw Quadrilateral 2
            plot([obj.Quad2_P1(1), obj.Quad2_P2(1), obj.Quad2_P3(1), obj.Quad2_P4(1), obj.Quad2_P1(1)], ...
                 [obj.Quad2_P1(2), obj.Quad2_P2(2), obj.Quad2_P3(2), obj.Quad2_P4(2), obj.Quad2_P1(2)], 'b-', 'LineWidth', 2);
            % Draw Quadrilateral 3
            plot([obj.Quad3_P1(1), obj.Quad3_P2(1), obj.Quad3_P3(1), obj.Quad3_P4(1), obj.Quad3_P1(1)], ...
                 [obj.Quad3_P1(2), obj.Quad3_P2(2), obj.Quad3_P3(2), obj.Quad3_P4(2), obj.Quad3_P1(2)], 'g-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS', 'DM3 PS');
            hold off;
        end
    end
end

