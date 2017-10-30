function [ saidaU ] = vetorU(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%vetorU(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%   Funcao responsavel por realizar o calculo do vetor U do modelo do
%   neuronio, ou seja, o vetor que contem todas as dilatacoes da entrada na
%   posicao i com o peso na posicao i. 

vUnitario = ones(1, tamanhoVetorEntrada);
saidaCalculo = zeros(1,tamanhoVetorEntrada);

    for i = 1:tamanhoVetorEntrada
          %%encontrando o vetor de peso extendido
          vetorPesoExtend = vUnitario * vetorPeso(i);
          
          %%realizado o calculo da entrada com o peso
          saidaCalculo(i) = dilatacao (vetorEntrada.', vetorPesoExtend);  
    end
    
    saidaU = saidaCalculo;
 end

