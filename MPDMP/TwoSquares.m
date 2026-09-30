classdef TwoSquares
    % Two quadrilateral regions with no intersection
    % DM1's PS: Square with 4 vertices (4 objectives)
    % DM2's PS: Square with 4 vertices (4 objectives)
    
    properties
        % Square 1 for DM1 (4 vertices)
        Sq1_P1 = [30, 35];
        Sq1_P2 = [45, 35];
        Sq1_P3 = [45, 50];
        Sq1_P4 = [30, 50];
        % Square 2 for DM2 (4 vertices)
        Sq2_P1 = [55, 50];
        Sq2_P2 = [70, 50];
        Sq2_P3 = [70, 65];
        Sq2_P4 = [55, 65];
    end
    
    methods
        function obj = TwoSquares()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Square1四个顶点的欧氏距离 (4个目标)
            dist1_1 = sqrt(sum((point - obj.Sq1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Sq1_P2).^2, 2));
            dist1_3 = sqrt(sum((point - obj.Sq1_P3).^2, 2));
            dist1_4 = sqrt(sum((point - obj.Sq1_P4).^2, 2));
            
            % DM2: 到Square2四个顶点的欧氏距离 (4个目标)
            dist2_1 = sqrt(sum((point - obj.Sq2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Sq2_P2).^2, 2));
            dist2_3 = sqrt(sum((point - obj.Sq2_P3).^2, 2));
            dist2_4 = sqrt(sum((point - obj.Sq2_P4).^2, 2));
            
            % 8目标：每个DM有4个目标
            distance = [dist1_1, dist1_2, dist1_3, dist1_4, ...
                        dist2_1, dist2_2, dist2_3, dist2_4];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 8目标PF
            n = 100;
            center1 = (obj.Sq1_P1 + obj.Sq1_P2 + obj.Sq1_P3 + obj.Sq1_P4) / 4;
            center2 = (obj.Sq2_P1 + obj.Sq2_P2 + obj.Sq2_P3 + obj.Sq2_P4) / 4;
            
            t = linspace(0, 1, n)';
            pf_points = zeros(n, 8);
            for i = 1:n
                pt = (1-t(i)) * center1 + t(i) * center2;
                pf_points(i, :) = [sqrt(sum((pt - obj.Sq1_P1).^2)), ...
                                   sqrt(sum((pt - obj.Sq1_P2).^2)), ...
                                   sqrt(sum((pt - obj.Sq1_P3).^2)), ...
                                   sqrt(sum((pt - obj.Sq1_P4).^2)), ...
                                   sqrt(sum((pt - obj.Sq2_P1).^2)), ...
                                   sqrt(sum((pt - obj.Sq2_P2).^2)), ...
                                   sqrt(sum((pt - obj.Sq2_P3).^2)), ...
                                   sqrt(sum((pt - obj.Sq2_P4).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            % Draw Quadrilateral 1
            plot([obj.Sq1_P1(1), obj.Sq1_P2(1), obj.Sq1_P3(1), obj.Sq1_P4(1), obj.Sq1_P1(1)], ...
                 [obj.Sq1_P1(2), obj.Sq1_P2(2), obj.Sq1_P3(2), obj.Sq1_P4(2), obj.Sq1_P1(2)], 'r-', 'LineWidth', 2);
            % Draw Quadrilateral 2
            plot([obj.Sq2_P1(1), obj.Sq2_P2(1), obj.Sq2_P3(1), obj.Sq2_P4(1), obj.Sq2_P1(1)], ...
                 [obj.Sq2_P1(2), obj.Sq2_P2(2), obj.Sq2_P3(2), obj.Sq2_P4(2), obj.Sq2_P1(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

