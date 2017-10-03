function [opErosao] = erosao (x,a)
    opErosao = min(adicaoDualMinMax (x,a));
end

