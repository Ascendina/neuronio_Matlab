function [ saidaAjustada ] = ajustePesoB(lambda, theta, erroCalculado, vetorEntrada, saidaVi, maxV, vetorV, valorB, tamanhoEntrada)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vetorUnitario = ones(1,tamanhoEntrada);

vetorB = valorB * vetorUnitario;

%%calculando primeiro a funcao rank de B
numerador = (sech( (saidaVi * vetorUnitario) - adicaoDualMinMax(vetorEntrada, vetorB) )).^2;

denominador = numerador * (vetorUnitario.');

saidaB = numerador / denominador;

%%calculando a funcao rank max(v)

numerador = (sech( (maxV * vetorUnitario) - vetorV )).^2;

denominador = numerador * (vetorUnitario.');

saidaV = numerador/denominador;

%%realizando a multiplicacao para gerar a saida 
saidaAjustada = -2 * lambda * (1 - theta) * saidaV * (saidaB.');
end

