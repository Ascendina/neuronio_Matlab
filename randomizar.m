function [ vetorRandomizado ] = randomizar(valorMinimo, valorMaximo, tamanhoVetor)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vetorRandomizado = valorMinimo + rand(1,tamanhoVetor)*(valorMaximo - valorMinimo);

end

