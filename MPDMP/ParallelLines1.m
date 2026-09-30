classdef ParallelLines1
    % Two parallel horizontal lines with no intersection
    % DM1's PS: Line segment with 2 endpoints (2 objectives)
    % DM2's PS: Line segment with 2 endpoints (2 objectives)
    
    properties
        % Line 1 for DM1 (2 endpoints)
        Line1_P1 = [30, 40];
        Line1_P2 = [70, 40];
        % Line 2 for DM2 (2 endpoints)
        Line2_P1 = [30, 60];
        Line2_P2 = [70, 60];
    end
    
    methods
        function obj = ParallelLines1()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Line1两个端点的欧氏距离 (2个目标)
            dist1_1 = sqrt(sum((point - obj.Line1_P1).^2, 2));  % 到端点1
            dist1_2 = sqrt(sum((point - obj.Line1_P2).^2, 2));  % 到端点2
            
            % DM2: 到Line2两个端点的欧氏距离 (2个目标)
            dist2_1 = sqrt(sum((point - obj.Line2_P1).^2, 2));  % 到端点1
            dist2_2 = sqrt(sum((point - obj.Line2_P2).^2, 2));  % 到端点2
            
            % 4目标：每个DM有2个目标
            distance = [dist1_1, dist1_2, dist2_1, dist2_2];
        end
        
        function p = PS(obj)
            % No common PS - return empty
            p = [];
        end
        
        function p = PF(obj)
            % 4目标PF
            n = 100;
            t = linspace(0, 1, n)';
            
            % Line1上的点到Line1端点距离：在端点之间变化
            % Line2上的点到Line2端点距离：在端点之间变化
            line_len = norm(obj.Line1_P2 - obj.Line1_P1);  % 40
            gap = norm(obj.Line2_P1 - obj.Line1_P1);  % 20 (两线间距)
            
            % DM1最优时在Line1上，DM2最优时在Line2上
            dist1_1 = t * line_len;
            dist1_2 = (1-t) * line_len;
            dist2_1 = sqrt(gap^2 + (t * line_len).^2);
            dist2_2 = sqrt(gap^2 + ((1-t) * line_len).^2);
            
            p = [dist1_1, dist1_2, dist2_1, dist2_2];
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            plot([obj.Line1_P1(1), obj.Line1_P2(1)], ...
                 [obj.Line1_P1(2), obj.Line1_P2(2)], 'r-', 'LineWidth', 2);
            plot([obj.Line2_P1(1), obj.Line2_P2(1)], ...
                 [obj.Line2_P1(2), obj.Line2_P2(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

