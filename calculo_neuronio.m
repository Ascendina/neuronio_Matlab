%% Criando script para realizar o calculo da rede neural morfologica

%%realizando a leitura inicial dos vetores de peso e entrada
pesoA = xlsread('pesoA.xlsx');
pesoB = xlsread('pesoB.xlsx');
pesoC = xlsread('pesoC.xlsx');
vetorEntrada = xlsread('entrada.xlsx');

%%atualizando valores dos parametros 
lambda = 0.5;
theta = 0.5;
bias = 1;
tamanhoEntrada = 6;
quantidadeEntradas = 1;

saida = ones(1,tamanhoEntrada);

for i = 1:quantidadeEntradas
%% realizando o calculo do neuronio
alfa = (theta * dilatacaoXPeso(vetorEntrada(i), pesoA, tamanhoEntrada)) + ((1 - theta) * erosaoXPeso(vetorEntrada(i), pesoB, tamanhoEntrada)); 
saida(i) = (lambda * alfa) + ((1 - lambda) * neuronioMLP(vetorEntrada(i), pesoC, bias))

end

%%escrevendo saida
xlswrite('C:\Users\Mila\Documents\series temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saidaNeuronio.xlsx', saida);