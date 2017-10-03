function adicaoDualAlgMinMax = adicaoDualMinMax (x,a)
    if (isfinite(x) == 1) &(isfinite(a) == 1)
        adicaoDualAlgMinMax = x + a;
    else 
        adicaoDualAlgMinMax = -Inf;
    end 
end

