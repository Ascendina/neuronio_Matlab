function [ saidaNormalizada] = normalizacao(vetor, valorInicial, valorFinal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
resultado = ones(length(vetor),1);
minimo = min(vetor);
maximo = max(vetor);

for i= 1:length(vetor)
    resultado(i) = valorInicial + (((vetor(i)- minimo) * (valorFinal - valorInicial)) / (maximo - minimo)); 
end

saidaNormalizada = resultado;
end

