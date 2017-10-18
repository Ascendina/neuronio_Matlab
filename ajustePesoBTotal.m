function [ saidaAjustada ] = ajustePesoBTotal( lambda, theta, erroCalculado, vetorEntrada, maxV, vetorV, vetorB, tamanhoEntrada)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%%criando um vetor para receber o peso ajustado de B
vetorPesoBAjustado = zeros(1,tamanhoEntrada);

%%For que fara a atualizacao dos pesos de A de um por um
for i = 1:tamanhoEntrada
    vetorPesoBAjustado(i) = ajustePesoB(lambda, theta, erroCalculado, vetorEntrada, vetorV(i), maxV, vetorV, vetorB(i), tamanhoEntrada);
    
end    
    
   saidaAjustada = vetorPesoBAjustado;

end

