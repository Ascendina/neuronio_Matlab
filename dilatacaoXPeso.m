function [ dilatacaoEntradaPeso ] = dilatacaoXPeso(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

vUnitario = ones(1, tamanhoVetorEntrada);
saidaCalculo = zeros(1,tamanhoVetorEntrada);

    for i = 1:tamanhoVetorEntrada
          %%encontrando o vetor de peso extendido
          vetorPesoExtend = vUnitario * vetorPeso(i);
          
          %%realizado o calculo da entrada com o peso
          saidaCalculo(i) = dilatacao (vetorEntrada, vetorPesoExtend);  
    end
    
    %%encontrando o infimo do vetor 
    dilatacaoEntradaPeso = min(saidaCalculo); 
    
end

