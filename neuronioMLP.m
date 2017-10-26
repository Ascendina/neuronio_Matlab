function [ saidaLinear ] = neuronioMLP(vetorEntrada, vetorPeso, bias)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
resultado = zeros(1,length(vetorEntrada));

for i = 1:length(vetorEntrada)
   resultado(i) = vetorEntrada(i) * vetorPeso(i); 
end
%%resultado = vetorPeso * vetorEntrada;
saidaLinear = sum(resultado);
saidaLinear = saidaLinear + bias;
end

