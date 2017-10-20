%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 6;
iteracoesTreinamentoValidacao = 1000;
iteracoesTeste = 100;
taxaAprendizado = 0.5;
epocasValidacao = 3;
limiarErro = 0.1;

%%Iniciando pesos
lambda = 0.1;
theta = 0.1;
pesoA = ones(1,tamanhoEntrada);
pesoB = ones(1,tamanhoEntrada);
pesoC = ones(1,tamanhoEntrada);
bias = 1;
saida = zeros(1,iteracoesTreinamentoValidacao);

%%Obtendo valores da entrada
vetorEntrada = xlsread('entrada.xlsx');

%%Para o calculo do erro
valorDesejado = xlsread('valorDesejado.xlsx');

%%criando vetores de apoio
erroPesoA = ones(1,tamanhoEntrada);
erroPesoB = ones(1,tamanhoEntrada);
erroPesoC = ones(1,tamanhoEntrada);
erroTheta = 1;
erroLambda = 1;

somatorioErro = zeros(1,iteracoesTreinamentoValidacao);
somatorioErroQuadrado = zeros(1,iteracoesTreinamentoValidacao);
mse = zeros(1,iteracoesTreinamentoValidacao);
mape = zeros(1,iteracoesTeste);

%%--------------------------------------------------------------------------------------------
%%Treinamento e Validacao
%%--------------------------------------------------------------------------------------------
while (i < iteracoesTreinamentoValidacao) && (breakValidacao == 0) && (erro < limiarErro)
    
%% realizando o calculo do neuronio

% mi = min dilatacao e nu = max erosao
mi = dilatacaoXPeso(vetorEntrada(i), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i), pesoC, bias);
saida(i) = (lambda * alfa) + ((1 - lambda) * beta);

%%--------------------------------------------------------------------------------------------
%%Calculando erros
%%--------------------------------------------------------------------------------------------

%% LEmbrar que o erro´eh um somatorio
%%Erro total = valor desejado - valor obtido

somatorioErro(i) = calculoErro(valorDesejado(i), saida(i));

for j = 1:i
erro = erro + somatorioErro(j);
end

%%calculando ajustes
%%Peso A
vetorU = vetorU(vetorEntrada(i), pesoA, tamanhoEntrada);
pesoA = pesoA - (taxaAprendizado * ajustePesoATotal(lambda, theta, erro, mi, vetorU, vetorEntrada(i), pesoA, tamanhoEntrada));

%%Peso B
vetorV = vetorV(vetorEntrada(i), pesoB, tamanhoEntrada);
pesoB = pesoB - (taxaAprendizado * ajustePesoBTotal( lambda, theta, erro, vetorEntrada(i), nu, vetorV, pesoB, tamanhoEntrada));

%%Peso C
pesoC = pesoC - (taxaAprendizado * ajustePesoC(vetorEntrada(i), lambda, erro));

%%Theta
theta = theta - (taxaAprendizado * ajustePesoTheta(lambda, mi, nu, erro));

%%lambda
lambda = lambda - (taxaAprendizado * ajustePesoLambda(alfa, beta, erro));

%%--------------------------------------------------------------------------------------------
%%--------------------------------------------------------------------------------------------


%%--------------------------------------------------------------------------------------------
%%Validando treinamento
%%--------------------------------------------------------------------------------------------
somatorioErroQuadrado(i) = (valorDesejado(i) - saida(i)).^2;

for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;


    if k < epocasValidacao
      k = k + 1;
    else
       if mse(i) < mse (i - epocasValidacao)
           breakValidacao = 0;
       else
           breakValidacao = 1;
       end
    end


%%atualizando ponteiros
i = i + 1;
end

%%limpando i
i = 1;


%%--------------------------------------------------------------------------------------------
%%Teste
%%--------------------------------------------------------------------------------------------
while (i < iteracoesTeste)
    
    
%% realizando o calculo do neuronio

% mi = min dilatacao e nu = max erosao
mi = dilatacaoXPeso(vetorEntrada(i), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i), pesoC, bias);
saida(i) = (lambda * alfa) + ((1 - lambda) * beta);


%%escrevendo saida em arquivo
xlswrite('C:\Users\Mila\Documents\series temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saidaNeuronio.xlsx', saida(i));


%%calculando erros

%%MSE
somatorioErroQuadrado(i) = (valorDesejado(i) - saida(i)).^2;

for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;

xlswrite('C:\Users\Mila\Documents\series temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.xlsx', mse (i));

%%MAPE
somatorio = somatorio + ((valorDesejado(i) - saida(i)) / valorDesejado(i));
mape = 100/i * somatorio;
xlswrite('C:\Users\Mila\Documents\series temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.xlsx', mape (i));

end
