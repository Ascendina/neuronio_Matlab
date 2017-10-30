function [opErosao] = erosao (x,a)
%erosao (x,a)
%   Funcao responsavel por realizar o calculo da erosao ¬(x + a)
%   que corresponde ao min da adicao dual da algebra minMax
    opErosao = min(adicaoDualMinMax (x,a));
end

