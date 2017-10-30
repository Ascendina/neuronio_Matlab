function [ saidaAjustada ] = ajustePesoC(entrada, lambda, erroCalculado)
%ajustePesoC(entrada, lambda, erroCalculado)
%   Funcao responsavel por realizar o ajuste do peso C. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso C.   


saidaAjustada = -2 * erroCalculado * (entrada * (1-lambda));

end

