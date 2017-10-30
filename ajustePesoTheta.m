function [ saidaAjustada ] = ajustePesoTheta(lambda, mi, nu, erroCalculado)
%ajustePesoTheta(lambda, mi, nu, erroCalculado)
% Funcao responsavel por realizar o ajuste do peso Theta. Isto e possivel,
%   pq se calcula a derivada da saida y pelo peso theta.   

    saidaAjustada = -2 * (erroCalculado) * (lambda * (mi - nu));

end

