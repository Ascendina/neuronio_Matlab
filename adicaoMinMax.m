function adicaoAlgMinMax = adicaoMinMax (x, a)
%adicaoMinMax (x, a)
%   Funcao responsavel por realizar a adicao da algebra minMax

    %%Caso x seja finito ou a seja finito, a adicao minMax corresponde a
    %%uma adicao da algebra convencional
    if (isfinite(x) == 1) & (isfinite(a) == 1)
        adicaoAlgMinMax = x + a;
        
    %%Caso x ou a seja INfinito, entao a adicao minMax sera sempre infinito positivo    
    else
        
        adicaoAlgMinMax = Inf;
    end 
end
 

