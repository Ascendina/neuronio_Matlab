function [ momentum ] = momentumPeso(peso, pesoAnterior, cteMomentum)
%momentumPesa(peso, pesoAnterior)
%   Funcao responsavel por fazer o calculo do momento de um vetor de peso
%   para isto precisa do valor atual do peso e do valor anterior do peso e
%   da constante do momentum

momentum = zeros(1, length(peso));

for i = 1:length(peso)
    momentum(i) = cteMomentum * (peso(i) - pesoAnterior(i));
end

end

