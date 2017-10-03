function adicaoAlgMinMax = adicaoMinMax (x, a)
    if (isfinite(x) == 1) && (isfinite(a) == 1)
        adicaoAlgMinMax = x + a;
    else 
    adicaoAlgMinMax = Inf;
    end 
end
 
