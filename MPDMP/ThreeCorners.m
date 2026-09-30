classdef ThreeCorners
    % Three line segment regions with no common intersection
    % DM1's PS: Line segment with 2 endpoints (2 objectives)
    % DM2's PS: Line segment with 2 endpoints (2 objectives)
    % DM3's PS: Line segment with 2 endpoints (2 objectives)
    
    properties
        % Line 1 for DM1 (2 endpoints) - top-left area
        Line1_P1 = [25, 60];
        Line1_P2 = [40, 70];
        % Line 2 for DM2 (2 endpoints) - top-right area
        Line2_P1 = [60, 70];
        Line2_P2 = [75, 60];
        % Line 3 for DM3 (2 endpoints) - bottom area
        Line3_P1 = [40, 30];
        Line3_P2 = [60, 30];
    end
    
    methods
        function obj = ThreeCorners()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Line1两个端点的欧氏距离 (2个目标)
            dist1_1 = sqrt(sum((point - obj.Line1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Line1_P2).^2, 2));
            
            % DM2: 到Line2两个端点的欧氏距离 (2个目标)
            dist2_1 = sqrt(sum((point - obj.Line2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Line2_P2).^2, 2));
            
            % DM3: 到Line3两个端点的欧氏距离 (2个目标)
            dist3_1 = sqrt(sum((point - obj.Line3_P1).^2, 2));
            dist3_2 = sqrt(sum((point - obj.Line3_P2).^2, 2));
            
            % 6目标：每个DM有2个目标
            distance = [dist1_1, dist1_2, dist2_1, dist2_2, dist3_1, dist3_2];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 6目标PF：3个DM，每个2个目标
            n = 100;
            center1 = (obj.Line1_P1 + obj.Line1_P2) / 2;
            center2 = (obj.Line2_P1 + obj.Line2_P2) / 2;
            center3 = (obj.Line3_P1 + obj.Line3_P2) / 2;
            
            pf_points = [];
            % 三条路径
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center1 + t * center2;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Line1_P1).^2)), sqrt(sum((pt - obj.Line1_P2).^2)), ...
                    sqrt(sum((pt - obj.Line2_P1).^2)), sqrt(sum((pt - obj.Line2_P2).^2)), ...
                    sqrt(sum((pt - obj.Line3_P1).^2)), sqrt(sum((pt - obj.Line3_P2).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center2 + t * center3;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Line1_P1).^2)), sqrt(sum((pt - obj.Line1_P2).^2)), ...
                    sqrt(sum((pt - obj.Line2_P1).^2)), sqrt(sum((pt - obj.Line2_P2).^2)), ...
                    sqrt(sum((pt - obj.Line3_P1).^2)), sqrt(sum((pt - obj.Line3_P2).^2))];
            end
            for i = 1:n
                t = (i-1)/(n-1);
                pt = (1-t) * center3 + t * center1;
                pf_points = [pf_points; ...
                    sqrt(sum((pt - obj.Line1_P1).^2)), sqrt(sum((pt - obj.Line1_P2).^2)), ...
                    sqrt(sum((pt - obj.Line2_P1).^2)), sqrt(sum((pt - obj.Line2_P2).^2)), ...
                    sqrt(sum((pt - obj.Line3_P1).^2)), sqrt(sum((pt - obj.Line3_P2).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            plot([obj.Line1_P1(1), obj.Line1_P2(1)], [obj.Line1_P1(2), obj.Line1_P2(2)], 'r-', 'LineWidth', 2);
            plot([obj.Line2_P1(1), obj.Line2_P2(1)], [obj.Line2_P1(2), obj.Line2_P2(2)], 'b-', 'LineWidth', 2);
            plot([obj.Line3_P1(1), obj.Line3_P2(1)], [obj.Line3_P1(2), obj.Line3_P2(2)], 'g-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS', 'DM3 PS');
            hold off;
        end
    end
end

