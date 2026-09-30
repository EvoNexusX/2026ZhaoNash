classdef ThreeDiagonals
    % Three triangular regions with no common intersection
    % DM1's PS: Triangle with 3 vertices (3 objectives)
    % DM2's PS: Triangle with 3 vertices (3 objectives)
    % DM3's PS: Triangle with 3 vertices (3 objectives)
    
    properties
        % Triangle 1 for DM1 (3 vertices) - left area
        Tri1_P1 = [25, 45];
        Tri1_P2 = [35, 35];
        Tri1_P3 = [35, 55];
        % Triangle 2 for DM2 (3 vertices) - bottom area
        Tri2_P1 = [45, 25];
        Tri2_P2 = [55, 25];
        Tri2_P3 = [50, 40];
        % Triangle 3 for DM3 (3 vertices) - right area
        Tri3_P1 = [65, 45];
        Tri3_P2 = [75, 35];
        Tri3_P3 = [75, 55];
    end
    
    methods
        function obj = ThreeDiagonals()
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
            
            % DM3: 到Triangle3三个顶点的欧氏距离 (3个目标)
            dist3_1 = sqrt(sum((point - obj.Tri3_P1).^2, 2));
            dist3_2 = sqrt(sum((point - obj.Tri3_P2).^2, 2));
            dist3_3 = sqrt(sum((point - obj.Tri3_P3).^2, 2));
            
            % 9目标：每个DM有3个目标
            distance = [dist1_1, dist1_2, dist1_3, ...
                        dist2_1, dist2_2, dist2_3, ...
                        dist3_1, dist3_2, dist3_3];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 9目标PF：3个DM，每个3个目标
            n = 100;
            center1 = (obj.Tri1_P1 + obj.Tri1_P2 + obj.Tri1_P3) / 3;
            center2 = (obj.Tri2_P1 + obj.Tri2_P2 + obj.Tri2_P3) / 3;
            center3 = (obj.Tri3_P1 + obj.Tri3_P2 + obj.Tri3_P3) / 3;
            
            pf_points = [];
            % 三条路径
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center1 + t * center2;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Tri1_P1).^2)), sqrt(sum((pt - obj.Tri1_P2).^2)), sqrt(sum((pt - obj.Tri1_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri2_P1).^2)), sqrt(sum((pt - obj.Tri2_P2).^2)), sqrt(sum((pt - obj.Tri2_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri3_P1).^2)), sqrt(sum((pt - obj.Tri3_P2).^2)), sqrt(sum((pt - obj.Tri3_P3).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center2 + t * center3;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Tri1_P1).^2)), sqrt(sum((pt - obj.Tri1_P2).^2)), sqrt(sum((pt - obj.Tri1_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri2_P1).^2)), sqrt(sum((pt - obj.Tri2_P2).^2)), sqrt(sum((pt - obj.Tri2_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri3_P1).^2)), sqrt(sum((pt - obj.Tri3_P2).^2)), sqrt(sum((pt - obj.Tri3_P3).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center3 + t * center1;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Tri1_P1).^2)), sqrt(sum((pt - obj.Tri1_P2).^2)), sqrt(sum((pt - obj.Tri1_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri2_P1).^2)), sqrt(sum((pt - obj.Tri2_P2).^2)), sqrt(sum((pt - obj.Tri2_P3).^2)), ...
                    sqrt(sum((pt - obj.Tri3_P1).^2)), sqrt(sum((pt - obj.Tri3_P2).^2)), sqrt(sum((pt - obj.Tri3_P3).^2))];
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
            % Draw Triangle 3
            plot([obj.Tri3_P1(1), obj.Tri3_P2(1), obj.Tri3_P3(1), obj.Tri3_P1(1)], ...
                 [obj.Tri3_P1(2), obj.Tri3_P2(2), obj.Tri3_P3(2), obj.Tri3_P1(2)], 'g-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS', 'DM3 PS');
            hold off;
        end
    end
end

