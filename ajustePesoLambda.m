function [ saidaAjustada ] = ajustePesoLambda(alfa, beta, erroCalculado)
%ajustePesoLambda(alfa, beta, erroCalculado)
%   Funcao responsavel por realizar o ajuste do peso Lambda. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso Lambda.   

saidaAjustada = -2 * (erroCalculado)* (alfa - beta);

end

