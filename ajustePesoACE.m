function [ saidaAjustada ] = ajustePesoACE(lambda, theta, saidaDesejada, saidaObtida, saidaUi, minU, vetorU, vetorEntrada, valorA, tamanhoEntrada)
%ajustePesoA(lambda, theta, erroCalculado, saidaUi, minU, vetorU, vetorEntrada, valorA, tamanhoEntrada)
% Funcao responsavel por realizar o calculo da derivada da saida y pelo vetor de peso A. 
%   minU - menor valor da dilatacao da entrada pelo vetor peso;
%   vetorU - todos os valores da dilatacao da entrada pelo vetor peso;
%   saidaUi - resultado da dilatacao do vetor de entrada na posicao i com o
%   vetor peso A na posicao i.

vetorUnitario = ones(1,tamanhoEntrada);

vetorA = valorA * vetorUnitario;
%%calculando primeiro o valor da funcao de rank para ai [q (min)]
numerador = (sech((saidaUi * vetorUnitario) - adicaoMinMax (vetorEntrada.', vetorA))).^2;

denominador = numerador * (vetorUnitario.');

saidaA = numerador/denominador;

%%calculando o valor da funcao de rank para min(u) [q (x+a)]
numerador = (sech((minU * vetorUnitario) - vetorU)).^2;

denominador = numerador * (vetorUnitario.');

saidaU = numerador/denominador;

%realizando a multiplicacao para gerar a saida
derivada =  lambda * theta * saidaU * (saidaA.');
saidaAjustada = (saidaDesejada/saidaObtida) * derivada - ((1-saidaDesejada)/(1-saidaObtida))* derivada; 
end



