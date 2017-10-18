function [ saidaAjustada ] = ajustePesoATotal(lambda, theta, erroCalculado, minU, vetorU, vetorEntrada, vetorA, tamanhoEntrada )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%criando um vetor para receber o peso ajustado de A 
vetorPesoAjustadoA = zeros(1,tamanhoEntrada);

%%For que fara a atualizacao dos pesos de A de um por um
for i = 1:tamanhoEntrada
    vetorPesoAAjustado(i) = ajustePesoA(lambda, theta, erroCalculado, vetorU(i), minU, vetorU, vetorEntrada, vetorA(i), tamanhoEntrada);
end    
    
   saidaAjustada = vetorPesoAAjustado;
end

