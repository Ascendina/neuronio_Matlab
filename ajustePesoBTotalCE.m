function [ saidaAjustada ] = ajustePesoBTotalCE( lambda, theta, saidaDesejada, saidaObtida, vetorEntrada, maxV, vetorV, vetorB, tamanhoEntrada)
%ajustePesoBTotal( lambda, theta, erroCalculado, vetorEntrada, maxV, vetorV, vetorB, tamanhoEntrada)
%   Funcao responsavel por realizar o ajuste do peso B. O ajuste e
%   realizado com cada um dos elementos do vetor B.
%   maxV - maior valor da erosao da entrada pelo vetor peso;
%   vetorV - todos os valores da erosao da entrada pelo vetor peso;

%%criando um vetor para receber o peso ajustado de B
vetorPesoBAjustado = zeros(1,tamanhoEntrada);

%%For que fara a atualizacao dos pesos de A de um por um
for i = 1:tamanhoEntrada
    vetorPesoBAjustado(i) = ajustePesoBCE(lambda, theta, saidaDesejada, saidaObtida, vetorEntrada, vetorV(i), maxV, vetorV, vetorB(i), tamanhoEntrada);
    
end    
    
   saidaAjustada = vetorPesoBAjustado;

end


