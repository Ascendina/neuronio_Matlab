function [ saidaLinear ] = neuronioMLP(vetorEntrada, vetorPeso, bias)
%neuronioMLP(vetorEntrada, vetorPeso, bias)
%   Funcao responsavel por realizado o calculo linear do neuronio. O
%   calculo e realizado da seguinte forma:somatorio do (vetor de entrada (i) multiplicado
%   pelo vetor de peso(i)). Este e o calculo utilizado no neuronio MLP. Ao
%   final do somatorio e adicionado o valor do bias



resultado = zeros(1,length(vetorEntrada));

for i = 1:length(vetorEntrada)
   resultado(i) = vetorEntrada(i) * vetorPeso(i); 
end


%%resultado = vetorPeso * vetorEntrada;
saidaLinear = sum(resultado);
saidaLinear = saidaLinear + bias;
end

