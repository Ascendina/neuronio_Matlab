function adicaoDualAlgMinMax = adicaoDualMinMax (x,a)
%adicaoDualMinMax (x,a)
%   Funcao responsavel por realizar a adicao dual da algebra minMax

    %%Caso x seja finito ou a seja finito, a adicao dual minMax corresponde a
    %%uma adicao da algebra convencional
    if (isfinite(x) == 1) &(isfinite(a) == 1)
        adicaoDualAlgMinMax = x + a;
        
    %%Caso x ou a seja INfinito, entao a adicao dual minMax sera sempre
    %%infinito negativo
    else 
        adicaoDualAlgMinMax = -Inf;
    end 
end

