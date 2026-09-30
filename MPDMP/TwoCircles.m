classdef TwoCircles
    % Two separate circular regions with no intersection
    % DM1's PS: circle centered at [40, 50]
    % DM2's PS: circle centered at [60, 50]
    
    properties
        Circle1_Center = [40, 50];  % DM1
        Circle1_Radius = 8;
        Circle2_Center = [60, 50];  % DM2
        Circle2_Radius = 8;
    end
    
    methods
        function obj = TwoCircles()
        end
        
        function distance = EuclideanDistance(obj, point)
            % Distance to Circle1 boundary (for DM1)
            dist_to_center1 = pdist2(point, obj.Circle1_Center);
            dist1 = abs(dist_to_center1 - obj.Circle1_Radius);
            
            % Distance to Circle2 boundary (for DM2)
            dist_to_center2 = pdist2(point, obj.Circle2_Center);
            dist2 = abs(dist_to_center2 - obj.Circle2_Radius);
            
            distance = [dist1, dist2];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 计算两圆之间的最小距离
            center_dist = norm(obj.Circle2_Center - obj.Circle1_Center);
            % 两圆边界之间的距离
            circle_gap = center_dist - obj.Circle1_Radius - obj.Circle2_Radius;
            
            % 2目标PF：从(0,d)到(d,0)的线，d是两圆边界间距
            n = 100;
            t = linspace(0, 1, n)';
            dist1_pf = t * circle_gap;
            dist2_pf = (1-t) * circle_gap;
            p = [dist1_pf, dist2_pf];
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            % Draw Circle1
            theta = linspace(0, 2*pi, 100);
            x1 = obj.Circle1_Center(1) + obj.Circle1_Radius * cos(theta);
            y1 = obj.Circle1_Center(2) + obj.Circle1_Radius * sin(theta);
            plot(x1, y1, 'r-', 'LineWidth', 2);
            % Draw Circle2
            x2 = obj.Circle2_Center(1) + obj.Circle2_Radius * cos(theta);
            y2 = obj.Circle2_Center(2) + obj.Circle2_Radius * sin(theta);
            plot(x2, y2, 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            axis equal;
            hold off;
        end
    end
end

