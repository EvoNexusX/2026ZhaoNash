classdef DiagonalPoints
    % Two pentagonal regions with no intersection
    % DM1's PS: Pentagon with 5 vertices (5 objectives)
    % DM2's PS: Pentagon with 5 vertices (5 objectives)
    
    properties
        % Pentagon 1 for DM1 (5 vertices)
        Pent1_P1 = [30, 40];
        Pent1_P2 = [40, 30];
        Pent1_P3 = [50, 35];
        Pent1_P4 = [50, 45];
        Pent1_P5 = [35, 50];
        % Pentagon 2 for DM2 (5 vertices)
        Pent2_P1 = [50, 55];
        Pent2_P2 = [65, 50];
        Pent2_P3 = [70, 60];
        Pent2_P4 = [60, 70];
        Pent2_P5 = [50, 65];
    end
    
    methods
        function obj = DiagonalPoints()
        end
        
        function distance = EuclideanDistance(obj, point)
            % DM1: 到Pentagon1五个顶点的欧氏距离 (5个目标)
            dist1_1 = sqrt(sum((point - obj.Pent1_P1).^2, 2));
            dist1_2 = sqrt(sum((point - obj.Pent1_P2).^2, 2));
            dist1_3 = sqrt(sum((point - obj.Pent1_P3).^2, 2));
            dist1_4 = sqrt(sum((point - obj.Pent1_P4).^2, 2));
            dist1_5 = sqrt(sum((point - obj.Pent1_P5).^2, 2));
            
            % DM2: 到Pentagon2五个顶点的欧氏距离 (5个目标)
            dist2_1 = sqrt(sum((point - obj.Pent2_P1).^2, 2));
            dist2_2 = sqrt(sum((point - obj.Pent2_P2).^2, 2));
            dist2_3 = sqrt(sum((point - obj.Pent2_P3).^2, 2));
            dist2_4 = sqrt(sum((point - obj.Pent2_P4).^2, 2));
            dist2_5 = sqrt(sum((point - obj.Pent2_P5).^2, 2));
            
            % 10目标：每个DM有5个目标
            distance = [dist1_1, dist1_2, dist1_3, dist1_4, dist1_5, ...
                        dist2_1, dist2_2, dist2_3, dist2_4, dist2_5];
        end
        
        function p = PS(obj)
            p = [];
        end
        
        function p = PF(obj)
            % 10目标PF
            n = 100;
            center1 = (obj.Pent1_P1 + obj.Pent1_P2 + obj.Pent1_P3 + obj.Pent1_P4 + obj.Pent1_P5) / 5;
            center2 = (obj.Pent2_P1 + obj.Pent2_P2 + obj.Pent2_P3 + obj.Pent2_P4 + obj.Pent2_P5) / 5;
            
            t = linspace(0, 1, n)';
            pf_points = zeros(n, 10);
            for i = 1:n
                pt = (1-t(i)) * center1 + t(i) * center2;
                pf_points(i, :) = [sqrt(sum((pt - obj.Pent1_P1).^2)), ...
                                   sqrt(sum((pt - obj.Pent1_P2).^2)), ...
                                   sqrt(sum((pt - obj.Pent1_P3).^2)), ...
                                   sqrt(sum((pt - obj.Pent1_P4).^2)), ...
                                   sqrt(sum((pt - obj.Pent1_P5).^2)), ...
                                   sqrt(sum((pt - obj.Pent2_P1).^2)), ...
                                   sqrt(sum((pt - obj.Pent2_P2).^2)), ...
                                   sqrt(sum((pt - obj.Pent2_P3).^2)), ...
                                   sqrt(sum((pt - obj.Pent2_P4).^2)), ...
                                   sqrt(sum((pt - obj.Pent2_P5).^2))];
            end
            p = pf_points;
        end
        
        function f = Draw(obj)
            f = figure();
            hold on;
            % Draw Pentagon 1
            plot([obj.Pent1_P1(1), obj.Pent1_P2(1), obj.Pent1_P3(1), obj.Pent1_P4(1), obj.Pent1_P5(1), obj.Pent1_P1(1)], ...
                 [obj.Pent1_P1(2), obj.Pent1_P2(2), obj.Pent1_P3(2), obj.Pent1_P4(2), obj.Pent1_P5(2), obj.Pent1_P1(2)], 'r-', 'LineWidth', 2);
            % Draw Pentagon 2
            plot([obj.Pent2_P1(1), obj.Pent2_P2(1), obj.Pent2_P3(1), obj.Pent2_P4(1), obj.Pent2_P5(1), obj.Pent2_P1(1)], ...
                 [obj.Pent2_P1(2), obj.Pent2_P2(2), obj.Pent2_P3(2), obj.Pent2_P4(2), obj.Pent2_P5(2), obj.Pent2_P1(2)], 'b-', 'LineWidth', 2);
            legend('DM1 PS', 'DM2 PS');
            hold off;
        end
    end
end

