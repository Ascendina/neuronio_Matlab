function [ saidaAjustada ] = ajustePesoATotalCE(lambda, theta, saidaDesejada, saidaObtida, minU, vetorU, vetorEntrada, vetorA, tamanhoEntrada )
%ajustePesoATotal(lambda, theta, erroCalculado, minU, vetorU, vetorEntrada, vetorA, tamanhoEntrada )
%   Funcao responsavel por realizar o ajuste do peso A. O ajuste e
%   realizado com cada um dos elementos do vetor A.
%   minU - menor valor da dilatacao da entrada pelo vetor peso;
%   vetorU - todos os valores da dilatacao da entrada pelo vetor peso;


%%criando um vetor para receber o peso ajustado de A 
vetorPesoAjustadoA = zeros(1,tamanhoEntrada);

olho = sprintf('tamanho Entrada ACE: %d', tamanhoEntrada);
    disp(olho);
    
%%For que fara a atualizacao dos pesos de A de um por um
for i = 1:tamanhoEntrada
    
    vetorPesoAAjustado(i) = ajustePesoACE(lambda, theta, saidaDesejada, saidaObtida, vetorU(i), minU, vetorU, vetorEntrada, vetorA(i), tamanhoEntrada);
    
end    
    
   saidaAjustada = vetorPesoAAjustado;
end

