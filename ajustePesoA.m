function [ saidaAjustada ] = ajustePesoA(lambda, theta, erroCalculado, saidaUi, minU, vetorU, vetorEntrada, valorA, tamanhoEntrada)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vetorUnitario = ones(1,tamanhoEntrada);

vetorA = valorA * vetorUnitario;
%%calculando primeiro o valor da funcao de rank para ai
numerador = (sech((saidaUi * vetorUnitario) - (vetorEntrada + vetorA))).^2;

denominador = numerador * (vetorUnitario.');

saidaA = numerador/denominador;

%%calculando o valor da funcao de rank para min(u)
numerador = (sech((minU * vetorUnitario) - vetorU)).^2;

denominador = numerador * (vetorUnitario.');

saidaU = numerador/denominador;

%realizando a multiplicacao para gerar a saida 
saidaAjustada = -2 * erroCalculado * lambda * theta * saidaU * (saidaA.'); 
end

