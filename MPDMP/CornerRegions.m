classdef CornerRegions
    % Two line segment regions with no intersection
    % DM1's PS: Line segment with 2 endpoints (2 objectives)
    % DM2's PS: Line segment with 2 endpoints (2 objectives)
    
    properties
        % Line 1 for DM1 (2 endpoints) - top-left area
        Line1_P1 = [30, 60];
        Line1_P2 = [40, 70];
        % Line 2 for DM2 (2 endpoints) - bottom-right area
        Line2_P1 = [60, 30];
        Line2_P2 = [70, 40];
    end
    
    methods
        function obj = CornerRegions()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Line1两个端点的欧氏距离 (2个目标)
            dist1_1 = sqrt(sum((point - obj.Line1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Line1_P2).^2, 2));
            
            % DM2: 到Line2两个端点的欧氏距离 (2个目标)
            dist2_1 = sqrt(sum((point - obj.Line2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Line2_P2).^2, 2));
            
            % 4目标：每个DM有2个目标
            distance = [dist1_1, dist1_2, dist2_1, dist2_2];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 4目标PF
            n = 100;
            center1 = (obj.Line1_P1 + obj.Line1_P2) / 2;
            center2 = (obj.Line2_P1 + obj.Line2_P2) / 2;
            
            t = linspace(0, 1, n)';
            pf_points = zeros(n, 4);
            for i = 1:n
                pt = (1-t(i)) * center1 + t(i) * center2;
                pf_points(i, :) = [sqrt(sum((pt - obj.Line1_P1).^2)), ...
                                   sqrt(sum((pt - obj.Line1_P2).^2)), ...
                                   sqrt(sum((pt - obj.Line2_P1).^2)), ...
                                   sqrt(sum((pt - obj.Line2_P2).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            plot([obj.Line1_P1(1), obj.Line1_P2(1)], [obj.Line1_P1(2), obj.Line1_P2(2)], 'r-', 'LineWidth', 2);
            plot([obj.Line2_P1(1), obj.Line2_P2(1)], [obj.Line2_P1(2), obj.Line2_P2(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

