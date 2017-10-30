function [ saidaNu ] = vetorV(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%vetorV(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%   Funcao responsavel por realizar o calculo do vetor V do modelo do
%   neuronio, ou seja, o vetor que contem todas as erosoes da entrada na
%   posicao i com o peso na posicao i. 

vUnitario = ones(1, tamanhoVetorEntrada);
saidaCalculo = zeros(1,tamanhoVetorEntrada);

    for i = 1:tamanhoVetorEntrada
          %%encontrando o vetor de peso extendido
          vetorPesoExtend = vUnitario * vetorPeso(i);
          
          %%realizado o calculo da entrada com o peso
          saidaCalculo(i) = erosao (vetorEntrada.', vetorPesoExtend);  
    end
    
    saidaNu = saidaCalculo; 
end


