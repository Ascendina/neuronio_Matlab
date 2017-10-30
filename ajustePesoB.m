function [ saidaAjustada ] = ajustePesoB(lambda, theta, erroCalculado, vetorEntrada, saidaVi, maxV, vetorV, valorB, tamanhoEntrada)
%ajustePesoB(lambda, theta, erroCalculado, vetorEntrada, saidaVi, maxV, vetorV, valorB, tamanhoEntrada)
% Funcao responsavel por realizar o calculo da derivada da saida y pelo vetor de peso B. 
%   maxV - maior valor da erosao da entrada pelo vetor peso;
%   vetorV - todos os valores da erosao da entrada pelo vetor peso;
%   saidaVi - resultado da erosao do vetor de entrada na posicao i com o
%   vetor peso B na posicao i.


vetorUnitario = ones(1,tamanhoEntrada);

vetorB = valorB * vetorUnitario;

%%calculando primeiro a funcao rank de B
numerador = (sech( (saidaVi * vetorUnitario) - adicaoDualMinMax(vetorEntrada.', vetorB) )).^2;

denominador = numerador * (vetorUnitario.');

saidaB = numerador / denominador;

%%calculando a funcao rank max(v)

numerador = (sech( (maxV * vetorUnitario) - vetorV )).^2;

denominador = numerador * (vetorUnitario.');

saidaV = numerador/denominador;

%%realizando a multiplicacao para gerar a saida 
saidaAjustada = -2 * erroCalculado * lambda * (1 - theta) * saidaV * (saidaB.');
end

