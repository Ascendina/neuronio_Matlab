function adicaoAlgMinMax = adicaoMinMax (x, a)
    if (isfinite(x) == 1) && (isfinite(a) == 1)
        adicaoAlgMinMax = x + a;
    else 
    adicaoAlgMinMax = Inf;
    end 
end
 
function adicaoDualAlgMinMax = adicaoDualMinMax (x,a)
    if (isfinite(x) == 1) && (isfinite(a) == 1)
        adicaoAlgMinMax = x + a;
    else 
        adicaoAlgMinMax = -Inf;
    end 
end

function [opDilatacao] = dilatacao (x, a)
    dilatacao = adicaoMinMax (x,a);
end

function [opErosao] = erosao (x,a)
    erosao = adicaoDualMinMax (x,a);
end