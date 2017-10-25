function [ saidaLinear ] = neuronioMLP(vetorEntrada, vetorPeso, bias)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
saidaLinear = sum(vetorEntrada.' + vetorPeso) + bias;

end

