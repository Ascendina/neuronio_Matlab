function [ erosaoEntradaPeso ] = erosaoXPeso(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vUnitario = ones(1, tamanhoVetorEntrada);
saidaCalculo = zeros(1,tamanhoVetorEntrada);

    for i = 1:tamanhoVetorEntrada
          %%encontrando o vetor de peso extendido
          vetorPesoExtend = vUnitario * vetorPeso(i);
          
          %%realizado o calculo da entrada com o peso
          saidaCalculo(i) = erosao (vetorEntrada.', vetorPesoExtend);  
    end
    
    %%encontrando o supremo do vetor 
    erosaoEntradaPeso = max(saidaCalculo); 
end

