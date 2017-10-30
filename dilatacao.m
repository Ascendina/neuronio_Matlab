function [opDilatacao] = dilatacao (x, a)
%dilatacao (x, a)
%   Funcao responsavel por realizar o calculo da dilatacao V(x + a)
%   que corresponde ao max da adicao da algebra minMax
    opDilatacao = max(adicaoMinMax (x,a));
end


