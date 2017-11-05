function [ saidaAjustada ] = ajustePesoCCE(entrada, lambda, saidaDesejada, saidaObtida)
%ajustePesoC(entrada, lambda, erroCalculado)
%   Funcao responsavel por realizar o ajuste do peso C. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso C.   

derivada = (entrada * (1-lambda));
saidaAjustada = (saidaDesejada/saidaObtida) * derivada - ((1-saidaDesejada)/(1-saidaObtida))* derivada;

end

