function [ saidaAjustada ] = ajustePesoLambdaCE(alfa, beta, saidaDesejada, saidaObtida)
%ajustePesoLambda(alfa, beta, erroCalculado)
%   Funcao responsavel por realizar o ajuste do peso Lambda. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso Lambda.   

derivada = (alfa - beta);
saidaAjustada = (saidaDesejada/saidaObtida) * derivada - ((1-saidaDesejada)/(1-saidaObtida))* derivada;

end


