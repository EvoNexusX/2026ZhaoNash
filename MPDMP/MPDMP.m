classdef MPDMP < PROBLEM

    properties
        Map;
        D = 2;
        DM = {1:2, 3:4};
        M = 4;
        encoding = 'real';
        Metric = {@IGD, @HV};
    end

    methods

        function obj = MPDMP()
            
        end

        function initialize(obj)
            %initialize - set the parameters needed for run.
            %
            % Syntax: initialize(obj)
            %
            % set the boundary, dimension, decision makers,
            % objective numbers and encoding
            if isprop(obj.Global, 'specifiedD') && obj.Global.specifiedD
                obj.D = obj.Global.D;
            end
            obj.Global.lower = zeros(1, obj.D);
            obj.Global.upper = 100 * ones(1, obj.D);
            obj.Global.D = obj.D;

            obj.Global.DM = obj.DM;
            obj.Global.M = obj.M;
            obj.Global.encoding = obj.encoding;
        end

        %% Calculate objective values
        function PopObj = CalObj(obj, PopDec)
            if size(PopDec, 2) > 2
                PopDec = PopDec(:, [1, end]);
            end
            PopObj = obj.Map.EuclideanDistance(PopDec);
        end

        function p = PF(obj)
            p = obj.Map.PF();
        end

        function p = PS(obj)
            p = obj.Map.PS();
        end

        %% get reference point
        function Opt = GetOptimum(obj)
            Opt = 200 * ones(1, obj.M);
        end

        function fig = Draw(obj, PopDec, FrontNo, caption)
            % 调用Map.Draw()，不接收返回值（因为某些Map类的Draw方法不返回值）
            obj.Map.Draw();
            gscatter(PopDec(:, 1), PopDec(:, end), FrontNo');
            xlabel('x_1');
            ylabel('x_2');
            axis([30 70 30 70]);
            title(caption);
            % 获取当前图形句柄
            fig = gcf();
        end

        %% Get concession rate for each DM based on case setting
        function concession = GetConcession(obj)
            dm_num = length(obj.DM);
            probName = class(obj);
            if any(strcmp(probName, {'MPDMP1','MPDMP2','MPDMP3','MPDMP4','MPDMP5','MPDMP6', ...
                                     'MPDMP7','MPDMP8','MPDMP9','MPDMP10','MPDMP11','MPDMP12'}))
                concession = zeros(1, dm_num);
                return;
            end
            if any(strcmp(probName, {'MPDMP13','MPDMP14','MPDMP15','MPDMP16','MPDMP17','MPDMP18'}))
                case_id = obj.ResolveConcessionCase(obj.Global.rate);
                concession = obj.ConcessionCaseTable(dm_num, case_id);
                return;
            end
            concession = zeros(1, dm_num);
        end

    end

    methods (Access = private)
        function case_id = ResolveConcessionCase(obj, rate)
            case_id = 1;
            if isempty(rate) || ~isnumeric(rate) || ~isscalar(rate)
                return;
            end
            if rate == 0
                case_id = 1;
                return;
            end
            if rate > 0 && rate < 1
                case_id = round(rate * 10);
            else
                case_id = round(rate);
            end
            case_id = max(1, min(7, case_id));
        end

        function concession = ConcessionCaseTable(obj, dm_num, case_id)
            if dm_num == 2
                cases = [
                    0.0, 0.0;   % case 1: 无退让
                    0.3, 0.0;   % case 2: 单方部分退让
                    0.3, 0.3;   % case 3: 等量小退让
                    0.3, 0.7;   % case 4: 非对称退让
                    0.5, 0.5;   % case 5: 等量中等退让
                    0.7, 0.7;   % case 6: 等量高退让
                    1.0, 1.0    % case 7: 完全退让（退化为MOABC）
                ];
            else
                cases = [
                    0.0, 0.0, 0.0;   % case 1
                    0.3, 0.0, 0.0;   % case 2
                    0.3, 0.3, 0.3;   % case 3
                    0.3, 0.1, 0.6;   % case 4
                    0.5, 0.5, 0.5;   % case 5
                    0.7, 0.7, 0.7;   % case 6
                    1.0, 1.0, 1.0    % case 7: 完全退让
                ];
            end
            case_id = max(1, min(size(cases, 1), case_id));
            concession = cases(case_id, 1:dm_num);
        end
    end

end
