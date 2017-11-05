%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Gradiente com Momentum    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 200;
iteracoesTreinamentoValidacao = 1503;
iteracoesTeste = 369;
taxaAprendizado = 0.001;
epocasValidacao = 10;
limiarErro = 0.0000001;

%%Iniciando pesos
%%lambda = 0.1;
%%theta = 0.1;
lambda = rand(1);
theta = rand(1);
pesoA = randomizar(-1,1,tamanhoEntrada);
pesoB = randomizar(-1,1,tamanhoEntrada);
pesoC = randomizar(-1,1,tamanhoEntrada);
bias = 1;
saida = zeros(1,iteracoesTreinamentoValidacao);

%%Variaveis para salvar o peso para o calculo do momentum
pesoAnteriorA = zeros(1, tamanhoEntrada);
pesoAnteriorB = zeros(1, tamanhoEntrada);
pesoAnteriorC = zeros(1, tamanhoEntrada);
pesoAnteriorTheta = zeros(1, tamanhoEntrada);
pesoAnteriorLambda = zeros(1, tamanhoEntrada);

%%variaveis que calculam o momentum
momentumA = zeros(1, tamanhoEntrada);
momentumB = zeros(1, tamanhoEntrada);
momentumC = zeros(1, tamanhoEntrada);
momentumLambda = zeros(1, tamanhoEntrada);
momentumTheta = zeros(1, tamanhoEntrada);

cteMomentumA = 0.1;
cteMomentumB = 0.1;
cteMomentumC = 0.1;
cteMomentumLambda = 0.1;
cteMomentumTheta = 0.1;


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
mseCrescente = 0;
erro = Inf;
i = 1;
k = 0;
m = 1;

%arquivo
arquivo = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_neuronio_treinamento_momentum.txt','w');
arquivoMSE = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mse_validacao_momentum.txt','w');
arquivoTeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\valoresTeste_momentum.txt','w');
arquivoMSETeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste_momentum.txt','w');
arquivoMape = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste_momentum.txt','w');
arquivoPesoA = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoA_momentum.txt','w');
arquivoPesoB = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoB_momentum.txt','w');
arquivoPesoC = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoC_momentum.txt','w');

arquivoVetorEntrada = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\vetorEntrada.txt','w');
fprintf(arquivoVetorEntrada,'%f \n', vetorEntrada);
%%--------------------------------------------------------------------------------------------
%%Treinamento e Validacao
%%--------------------------------------------------------------------------------------------

while (i < iteracoesTreinamentoValidacao) && (breakValidacao == 0) && (abs(erro) > limiarErro)
    
%% realizando o calculo do neuronio

%%olho = sprintf('i: %d',i);
%%disp(olho);


%%olho = sprintf('breakValidacao %d', breakValidacao);
%%disp(olho);

% mi = min dilatacao e nu = max erosao
mi = dilatacaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoC, bias);
saida(i) = (lambda * alfa) + ((1 - lambda) * beta);

%%olho = sprintf('SAIDA: %d', saida(i));
%%disp(olho);

%%escrevendo saida
fprintf(arquivo,'%f \n', saida(i));

%%--------------------------------------------------------------------------------------------
%%Calculando erros
%%--------------------------------------------------------------------------------------------

%% LEmbrar que o erro�eh um somatorio
%%Erro total = valor desejado - valor obtido

%%somatorioErro(i) = calculoErro(valorDesejado(i+1), saida(i))^2;
somatorioErro(i) = calculoErro(valorDesejado(i+tamanhoEntrada), saida(i))^2;

%%for j = 1:i
%%erro = erro + somatorioErro(j);
%%end

%%erro = calculoErro(valorDesejado(i+1), saida(i));
erro = calculoErro(valorDesejado(i+tamanhoEntrada), saida(i));

%%calculando ajustes
%%Peso A
vU = vetorU(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);


%%na primeira execucao vetor peso nao tem anterior
if i == 1
    momentumA = zeros(1,length(pesoA));
else 
   momentumA = momentumPeso(pesoA, pesoAnteriorA, cteMomentumA);
end

%%salvando o vetor peso A - para calcular o momentum
pesoAnteriorA = pesoA;

%%Calculo do peso
pesoA = pesoA - (taxaAprendizado * ajustePesoATotal(lambda, theta, erro, mi, vU, vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada)) - momentumA;

%%salvando informacoes arquivo
fprintf(arquivoPesoA,'%f \n', pesoA);




%%Peso B
vV = vetorV(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

%%na primeira execucao vetor peso nao tem anterior
if i == 1
    momentumB = zeros(1,length(pesoB));
else 
   momentumB = momentumPeso(pesoB, pesoAnteriorB, cteMomentumB);
end

%%salvando o vetor peso A - para calcular o momentum
pesoAnteriorB = pesoB;

pesoB = pesoB - (taxaAprendizado * ajustePesoBTotal( lambda, theta, erro, vetorEntrada(i:(i+(tamanhoEntrada-1))), nu, vV, pesoB, tamanhoEntrada)) - momentumB;
fprintf(arquivoPesoB,'%f \n', pesoB);

%%Peso C

%%na primeira execucao vetor peso nao tem anterior
if i == 1
    momentumC = zeros(1,length(pesoC));
else 
   momentumC = momentumPeso(pesoC, pesoAnteriorC, cteMomentumC);
end

%%salvando o vetor peso A - para calcular o momentum
pesoAnteriorC = pesoC;

pesoC = pesoC - (taxaAprendizado * ajustePesoC(vetorEntrada(i:(i+(tamanhoEntrada-1))), lambda, erro).') - momentumC;
fprintf(arquivoPesoC,'%f \n', pesoC);

%%Theta

%%na primeira execucao vetor peso nao tem anterior
if i == 1
    momentumTheta = zeros(1,length(theta));
else 
   momentumTheta = momentumPeso(theta, pesoAnteriorTheta, cteMomentumTheta);
end

%%salvando o vetor peso A - para calcular o momentum
pesoAnteriorTheta = theta;


theta = theta - (taxaAprendizado * ajustePesoTheta(lambda, mi, nu, erro)) - momentumTheta;

%%lambda

%%na primeira execucao vetor peso nao tem anterior
if i == 1
    momentumLambda = zeros(1,length(lambda));
else 
   momentumLambda = momentumPeso(lambda, pesoAnteriorLambda, cteMomentumLambda);
end

%%salvando o vetor peso A - para calcular o momentum
pesoAnteriorLambda = lambda;

lambda = lambda - (taxaAprendizado * ajustePesoLambda(alfa, beta, erro)) - momentumLambda;

%%--------------------------------------------------------------------------------------------
%%--------------------------------------------------------------------------------------------


%%--------------------------------------------------------------------------------------------
%%Validando treinamento
%%--------------------------------------------------------------------------------------------
%%olho = sprintf('tamanho ValorDesejado: %d', i+tamanhoEntrada);
%%disp(olho);

somatorioErroQuadrado(i) = (valorDesejado(i+tamanhoEntrada) - saida(i)).^2;

%%olho = sprintf('SOMATORIO INSTANTANEO: %f', somatorioErroQuadrado(i));
%%disp(olho);

%%for j = 1:i
%%    somatorio = somatorio + somatorioErroQuadrado(j);
%%end

%%olho = sprintf('SOMATORIO TOTAL: %f', somatorio);
%%disp(olho);


%%mse(i) = somatorio/i;

%%olho = sprintf('MSE: %f', mse(i));
%%disp(olho);

%%olho = sprintf('MSE MATLAB: %f', immse(valorDesejado(i+tamanhoEntrada),saida(i)));
%%disp(olho);

%%disp(mse(i));
%%escrevendo mse
%%fprintf(arquivoMSE,'%f\n',mse(i));

fprintf(arquivoMSE,'%f\n',somatorioErroQuadrado(i));


    if k < epocasValidacao
      k = k + 1;
    else
        %iniciando variavel
        k = 0;
        
       if somatorioErroQuadrado(i) < somatorioErroQuadrado (i - epocasValidacao)
          mseCrescente = 0;
       else
          mseCrescente = mseCrescente + 1; 
       end
       
       
       if(mseCrescente >= 3)
           breakValidacao = 1;
       else
           breakValidacao = 0;
       end
    end

olho = sprintf('breakValidacao %d', breakValidacao);
disp(olho);

olho = sprintf('Iteracao %d', i);
disp(olho);


%%atualizando ponteiros
i = i + 1;
end

%%limpando i
%%i = 1;
i = 1703;

%%--------------------------------------------------------------------------------------------
%%Teste
%%--------------------------------------------------------------------------------------------
while (m < iteracoesTeste)
    
    
%% realizando o calculo do neuronio

% mi = min dilatacao e nu = max erosao
mi = dilatacaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
nu = erosaoXPeso(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

alfa = (theta * mi) + ((1 - theta) * nu); 
beta = neuronioMLP(vetorEntrada(i:(i+(tamanhoEntrada-1))), pesoC, bias);
saida(m) = (lambda * alfa) + ((1 - lambda) * beta);

%%olho = sprintf('Alfa: %d', alfa);
%%disp (olho);
%%olho = sprintf('Beta: %d', beta);
%%disp (olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


%%escrevendo saida em arquivo
%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saidaNeuronio.xlsx', saida(i));
fprintf(arquivoTeste,'%f\n',saida(m));

%%calculando erros

%%MSE
somatorioErroQuadrado(m) = (valorDesejado(i+tamanhoEntrada) - saida(m)).^2;

%%for j = 1:i
  %%  somatorio = somatorio + somatorioErroQuadrado(j);
%%end

%%mse(i) = somatorio/i;

mse(m) = somatorioErroQuadrado(m);
%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.xlsx', mse (i));
fprintf(arquivoMSETeste,'%f\n',mse(m));

%%MAPE
%%somatorio = somatorio + ((valorDesejado(i+1) - saida(i)) / valorDesejado(i+1));
somatorio = ((valorDesejado(i+tamanhoEntrada) - saida(m)) / valorDesejado(i+tamanhoEntrada + 1));
%%olho = sprintf('valorDesejado: %d', valorDesejado(i+1));
%%disp(olho);
%%olho = sprintf('Saida: %d', saida(i));
%%disp (olho);


mape(m) = 100/m * somatorio;


%%olho = sprintf('variavel i: %d', i);
%%disp(olho);


%xlswrite('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.xlsx', mape (i));
fprintf(arquivoMape,'%f\n',mape(m));


%%aumentando a variavel
i = i + 1;

%%quantidade de iteracoes
m = m + 1;
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
fclose(arquivoVetorEntrada);
