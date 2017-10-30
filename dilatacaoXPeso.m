function [ dilatacaoEntradaPeso ] = dilatacaoXPeso(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%dilatacaoXPeso(vetorEntrada, vetorPeso, tamanhoVetorEntrada)
%   Funcao responsavel por realizar a dilatacao do vetor de entrada com o
%   vetor peso. O calculo sera realizado da seguinte forma: dilatacao vetor 
%   entrada pelo vetor peso a1 extendido (ate ter o tamanho da entrada).
%   Isto sera realizado com cada um dos elementos do vetor de peso.  

%Vetor unitario que sera utilizado para extender o peso
vUnitario = ones(1, tamanhoVetorEntrada);

%Saida para cada dilatacao do vetor de entrada com o vetor peso an
%extendido
saidaCalculo = zeros(1,tamanhoVetorEntrada);

    for i = 1:tamanhoVetorEntrada
          %%encontrando o vetor de peso extendido
          vetorPesoExtend = vUnitario * vetorPeso(i);
          
          %%realizado o calculo da entrada com o peso
          saidaCalculo(i) = dilatacao (vetorEntrada.', vetorPesoExtend);  
    end
    
    %%encontrando o infimo do vetor 
    dilatacaoEntradaPeso = min(saidaCalculo); 
    
end

