%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 200;
iteracoesTreinamentoValidacao = 1702;
iteracoesTeste = 567;
taxaAprendizado = 0.05;
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
%%vetorEntrada = xlsread('entrada.xlsx');
vetorEntrada = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close.csv');

%%Para o calculo do erro
%%valorDesejado = xlsread('valorDesejado.xlsx');
valorDesejado = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close.csv');

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

%%condicoes de parada
breakValidacao = 0;
erro = 0;
i = 1;
%%--------------------------------------------------------------------------------------------
%%Treinamento e Validacao
%%--------------------------------------------------------------------------------------------
while (i < iteracoesTreinamentoValidacao) && (breakValidacao == 0) && (erro < limiarErro)
    
%% realizando o calculo do neuronio

% mi = min dilatacao e nu = max erosao
%%olho = sprintf('variavel i: %d', i);
%%disp(olho);

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

somatorioErro(i) = calculoErro(valorDesejado(i+1), saida(i));

for j = 1:i
erro = erro + somatorioErro(j);
end

%%calculando ajustes
%%Peso A
vU = vetorU(vetorEntrada(i), pesoA, tamanhoEntrada);
pesoA = pesoA - (taxaAprendizado * ajustePesoATotal(lambda, theta, erro, mi, vU, vetorEntrada(i), pesoA, tamanhoEntrada));

%%Peso B
vV = vetorV(vetorEntrada(i), pesoB, tamanhoEntrada);
pesoB = pesoB - (taxaAprendizado * ajustePesoBTotal( lambda, theta, erro, vetorEntrada(i), nu, vV, pesoB, tamanhoEntrada));

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
somatorioErroQuadrado(i) = (valorDesejado(i+1) - saida(i)).^2;

%iniciando variavel
somatorio = 0;

for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;

    %iniciando variavel
    k = 0;
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
%%i = 1;


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

%%olho = sprintf('Alfa: %d', alfa);
%%disp (olho);
%%olho = sprintf('Beta: %d', beta);
%%disp (olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


%%escrevendo saida em arquivo
xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saidaNeuronio.xlsx', saida(i));


%%calculando erros

%%MSE
somatorioErroQuadrado(i) = (valorDesejado(i+1) - saida(i)).^2;

for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;

xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.xlsx', mse (i));

%%MAPE
somatorio = somatorio + ((valorDesejado(i+1) - saida(i)) / valorDesejado(i+1));
%%olho = sprintf('valorDesejado: %d', valorDesejado(i+1));
%%disp(olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


mape(i) = 100/i * somatorio;


%%olho = sprintf('variavel i: %d', i);
%%disp(olho);


xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.xlsx', mape (i));


%%aumentando a variavel
i = i + 1;
end
