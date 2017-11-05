function [ saidaAjustada ] = ajustePesoThetaCE(lambda, mi, nu, saidaDesejada, saidaObtida)
%ajustePesoTheta(lambda, mi, nu, erroCalculado)
% Funcao responsavel por realizar o ajuste do peso Theta. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso theta.   

    derivada = (lambda * (mi - nu));
    saidaAjustada = (saidaDesejada/saidaObtida) * derivada - ((1-saidaDesejada)/(1-saidaObtida))* derivada;

end


