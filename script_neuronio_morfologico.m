%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 200;
iteracoesTreinamentoValidacao = 1503;
iteracoesTeste = 369;
taxaAprendizado = 0.05;
epocasValidacao = 3;
limiarErro = 0.1;

%%Iniciando pesos
lambda = 0.1;
theta = 0.1;
%%pesoA = ones(1,tamanhoEntrada);
%%pesoB = ones(1,tamanhoEntrada);
%%pesoC = ones(1,tamanhoEntrada);
%pesoA = randi([0,1],1,tamanhoEntrada);
%pesoB = randi([0,1],1,tamanhoEntrada);
%pesoC = randi([0,1],1,tamanhoEntrada);
pesoA = rand(1,tamanhoEntrada);
pesoB = rand(1,tamanhoEntrada);
pesoC = rand(1,tamanhoEntrada);
bias = 1;
saida = zeros(1,iteracoesTreinamentoValidacao);

%%Obtendo valores da entrada
%%vetorEntrada = xlsread('entrada.xlsx');
vetorEntrada = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close.csv');
vetorEntrada =  normalizacao(vetorEntrada, 0, 1);

%%Para o calculo do erro
%%valorDesejado = xlsread('valorDesejado.xlsx');
valorDesejado = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close.csv');
valorDesejado = normalizacao(valorDesejado, 0, 1);


%%criando vetores de apoio
erroPesoA = ones(1,tamanhoEntrada);
erroPesoB = ones(1,tamanhoEntrada);
erroPesoC = ones(1,tamanhoEntrada);
%%erroPesoA = randi([1,10],1,tamanhoEntrada);
%%erroPesoB = randi([1,10],1,tamanhoEntrada);
%%erroPesoC = randi([1,10],1,tamanhoEntrada);
erroTheta = 1;
erroLambda = 1;

somatorioErro = zeros(1,iteracoesTreinamentoValidacao);
somatorioErroQuadrado = zeros(1,iteracoesTreinamentoValidacao);
mse = zeros(1,iteracoesTreinamentoValidacao);
mape = zeros(1,iteracoesTeste);
%iniciando variavel
somatorio = 0;

%%condicoes de parada
breakValidacao = 0;
erro = 0;
i = 1;
k = 0;

%arquivo
arquivo = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_neuronio_treinamento.txt','w');
arquivoMSE = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mse_validacao.txt','w');
arquivoTeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\valoresTeste.txt','w');
arquivoMSETeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.txt','w');
arquivoMape = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.txt','w');
arquivoPesoA = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoA.txt','w');
arquivoPesoB = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoB.txt','w');
arquivoPesoC = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoC.txt','w');

%%--------------------------------------------------------------------------------------------
%%Treinamento e Validacao
%%--------------------------------------------------------------------------------------------
while (i < iteracoesTreinamentoValidacao) && (breakValidacao == 0) && (erro < limiarErro)
    
%% realizando o calculo do neuronio

% mi = min dilatacao e nu = max erosao
%%olho = sprintf('variavel i: %d', i);
%%disp(olho);

%%disp(length(vetorEntrada(i:(i+199))));
%%disp(length(pesoA));
mi = dilatacaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoC, bias);
saida(i) = (lambda * alfa) + ((1 - lambda) * beta);

%%olho = sprintf('saida: %d', saida(i));
%%disp(olho);

%%escrevendo saida
fprintf(arquivo,'%d \n', saida(i));

%%--------------------------------------------------------------------------------------------
%%Calculando erros
%%--------------------------------------------------------------------------------------------

%% LEmbrar que o erro´eh um somatorio
%%Erro total = valor desejado - valor obtido

somatorioErro(i) = calculoErro(valorDesejado(i+1), saida(i));
%%olho = sprintf('somatorio erro: %d', somatorioErro(i));
%%disp(olho);


for j = 1:i
erro = erro + somatorioErro(j);
end

%%olho = sprintf('Erro: %d', erro);
%%disp(olho);


%%calculando ajustes
%%Peso A
vU = vetorU(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
pesoA = pesoA - (taxaAprendizado * ajustePesoATotal(lambda, theta, erro, mi, vU, vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada));
fprintf(arquivoPesoA,'%d \n', pesoA);

%%Peso B
vV = vetorV(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);
pesoB = pesoB - (taxaAprendizado * ajustePesoBTotal( lambda, theta, erro, vetorEntrada(i:(i+(tamanhoEntrada-1))), nu, vV, pesoB, tamanhoEntrada));
fprintf(arquivoPesoB,'%d \n', pesoB);

%%Peso C
pesoC = pesoC - (taxaAprendizado * ajustePesoC(vetorEntrada(i:(i+(tamanhoEntrada-1))), lambda, erro).');
fprintf(arquivoPesoC,'%d \n', pesoC);

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


for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;

%%escrevendo mse
fprintf(arquivoMSE,'%d\n',mse(i));

    if k < epocasValidacao
      k = k + 1;
    else
        %iniciando variavel
        k = 0;
        
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
mi = dilatacaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoC, bias);
saida(i) = (lambda * alfa) + ((1 - lambda) * beta);

%%olho = sprintf('Alfa: %d', alfa);
%%disp (olho);
%%olho = sprintf('Beta: %d', beta);
%%disp (olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


%%escrevendo saida em arquivo
%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saidaNeuronio.xlsx', saida(i));
fprintf(arquivoTeste,'%d\n',saida(i));

%%calculando erros

%%MSE
somatorioErroQuadrado(i) = (valorDesejado(i+1) - saida(i)).^2;

for j = 1:i
    somatorio = somatorio + somatorioErroQuadrado(j);
end

mse(i) = somatorio/i;

%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.xlsx', mse (i));
fprintf(arquivoMSETeste,'%d\n',mse(i));

%%MAPE
somatorio = somatorio + ((valorDesejado(i+1) - saida(i)) / valorDesejado(i+1));
%%olho = sprintf('valorDesejado: %d', valorDesejado(i+1));
%%disp(olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


mape(i) = 100/i * somatorio;


%%olho = sprintf('variavel i: %d', i);
%%disp(olho);


%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.xlsx', mape (i));
fprintf(arquivoMape,'%d\n',mape(i));


%%aumentando a variavel
i = i + 1;
end

%%fechando arquivos
fclose(arquivo);
fclose(arquivoMSE);
fclose(arquivoTeste);
fclose(arquivoMSETeste);
fclose(arquivoMape);
fclose(arquivoPesoA);
fclose(arquivoPesoB);
fclose(arquivoPesoC);