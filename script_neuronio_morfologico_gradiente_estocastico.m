%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica com Gradiente Descentente Estocastico   %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 200;
taxaAprendizado = 0.001;
epocasValidacao = 10;
limiarErro = 0.0000001;
tamanhoBatch = 100;
numMaxIter = 100000;

%%Iniciando pesos
lambdaAntigo = 0;
lambda = rand(1);
thetaAntigo = 0;
theta = rand(1);
pesoA = normrnd(0,0.001,1,tamanhoEntrada);
pesoB = normrnd(0,0.001,1,tamanhoEntrada);
pesoC = normrnd(0,0.001,1,tamanhoEntrada);
bias = 0;
saida = 0;

%%Obtendo valores da entrada para cada etapa
vetorEntradaTreinamento = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close_treinamento.csv');
vetorEntradaTreinamento =  normalizacao(vetorEntradaTreinamento, 0, 1);

vetorEntradaValidacao = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close_validacao.csv');
vetorEntradaValidacao =  normalizacao(vetorEntradaValidacao, 0, 1);

vetorEntradaTeste = csvread('C:\Users\Mila\Documents\arquivos_doutorado\lerArquivo\BBDC4_D1_close_teste.csv');
vetorEntradaTeste =  normalizacao(vetorEntradaTeste, 0, 1);

conjuntoTreinamento = zeros(1,tamanhoBatch);
entradaTreinamento = zeros(tamanhoBatch, tamanhoEntrada);


%%Quantide de deslizamentos que a janela fara
tamanhoDeslizeJanelaTreinamento = (length(vetorEntradaTreinamento) - 200);
tamanhoDeslizeJanelaValidacao = (length(vetorEntradaValidacao) - 200);
tamanhoDeslizeJanelaTeste = (length(vetorEntradaTeste) - 200);

%%A saida desejada para cada uma das etapas
vetorSaidaDesejadaTreinamento = zeros(1, tamanhoBatch);
%%vetorSaidaDesejadaTreinamento = vetorEntradaTreinamento(201:length(vetorEntradaTreinamento));
vetorSaidaDesejadaValidacao = vetorEntradaValidacao(201:length(vetorEntradaValidacao));
vetorSaidaDesejadaTeste = vetorEntradaTeste(201:length(vetorEntradaTeste));

%%Variaveis relacionadas ao erro
somatorioErroTreinamento = 0;
somatorioErroValidacao = 0;
somatorioErroTeste = 0;
erroTreinamento = 0;
somatorioAjustePesoA = zeros(1,tamanhoEntrada);
somatorioAjustePesoB = zeros(1,tamanhoEntrada);
somatorioAjustePesoC = zeros(1,tamanhoEntrada);
somatorioAjusteTheta = 0;
somatorioAjusteLambda = 0;

erroMSETreinamento = 0;
erroMSEValidacao = Inf;
erroMSEValidacaoAnterior = Inf;

breakTreinamento = 0;
contadorExecucoes = 0;

%arquivo
arquivo = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_neuronio_treinamento.txt','w');
arquivoValidacao = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_validacao.txt','w'); 
arquivoMSE = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mse_validacao.txt','w');
arquivoTeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\valoresTeste.txt','w');
arquivoMSETeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.txt','w');
arquivoMape = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.txt','w');
arquivoPesoA = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoA.txt','w');
arquivoPesoB = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoB.txt','w');
arquivoPesoC = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\pesoC.txt','w');

arquivoVetorEntrada = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\vetorEntrada.txt','w');
%%fprintf(arquivoVetorEntrada,'%f \n', vetorEntrada);



%%--------------------------------------------------------------------------------------------
%%                                         TREINAMENTO
%%--------------------------------------------------------------------------------------------

%%(i < iteracoesTreinamentoValidacao) && 
while (contadorExecucoes < numMaxIter) && (abs(erroMSEValidacao) > limiarErro)
    %%Apresentando o numero da iteracao
    olho = sprintf('ITERACAO: %d \n',contadorExecucoes);
    disp(olho);

    %%Avisando ao usuario que esta na fase de treinamento
    display('treinamento');
    
    %%escolhendo os vetores para treinamento
    conjuntoTreinamento = randsample(1:tamanhoDeslizeJanelaTreinamento,tamanhoBatch);
    
    for i=1:length(conjuntoTreinamento)
        entradaTreinamento(i,:) = vetorEntradaTreinamento(conjuntoTreinamento(i):(conjuntoTreinamento(i)+tamanhoEntrada-1));
        vetorSaidaDesejadaTreinamento(i) = vetorEntradaTreinamento(conjuntoTreinamento(i)+tamanhoEntrada);
    end
    
    
    %%limpando o somatorio para ter somente a media das amostras
    somatorioAjustePesoA = 0;
    somatorioAjustePesoB = 0;
    somatorioAjustePesoC = 0;
    somatorioAjusteTheta = 0;
    somatorioAjusteLambda= 0;
    somatorioErroTreinamento = 0;
        
    %%calculando a saida do neuronio para o treinamento
    for j = 1:tamanhoBatch

        %%----------------------------------------------------
        %%Calculando a saida do neuronio
        %%----------------------------------------------------
        
        % mi = min dilatacao e nu = max erosao
        mi = dilatacaoXPeso(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoA, tamanhoEntrada);
        nu = erosaoXPeso(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoB, tamanhoEntrada);

        alfa = (theta * mi) + ((1 - theta) * nu); 
        beta = neuronioMLP(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoC, bias);
        saida = (lambda * alfa) + ((1 - lambda) * beta);

        %%Salvando os valores do valor desejado (obtendo sempre 200 elementos a
        %%frente
       %% vetorSaidaDesejadaTreinamento(j) = entradaTreinamento (j + tamanhoEntrada);
        
        %%escrevendo saida
        fprintf(arquivo,'%f\n', saida);
        
        %%calculando o somatorio do erro
        somatorioErroTreinamento = somatorioErroTreinamento + (vetorSaidaDesejadaTreinamento(j) - saida).^2;
        
        %%erro instantaneo
        erroTreinamento = (vetorSaidaDesejadaTreinamento(j) - saida);
        
        %%----------------------------------------------------
        %%Calculando o ajuste a cada execucao
        %%----------------------------------------------------
        
        %%Peso A
        vU = vetorU(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoA, tamanhoEntrada);
        somatorioAjustePesoA = somatorioAjustePesoA + ajustePesoATotal(lambda, theta, erroTreinamento, mi, vU, entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoA, tamanhoEntrada);

        %%Peso B
        vV = vetorV(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', pesoB, tamanhoEntrada);
        somatorioAjustePesoB = somatorioAjustePesoB + ajustePesoBTotal( lambda, theta, erroTreinamento, entradaTreinamento(j:(j+(tamanhoEntrada-1))).', nu, vV, pesoB, tamanhoEntrada);

        %%Peso C
        somatorioAjustePesoC = somatorioAjustePesoC + ajustePesoC(entradaTreinamento(j:(j+(tamanhoEntrada-1))).', lambda, erroTreinamento).';
               
        %%Theta
        somatorioAjusteTheta = somatorioAjusteTheta + ajustePesoTheta(lambda, mi, nu, erroTreinamento);

        %%lambda
        somatorioAjusteLambda = somatorioAjusteLambda + ajustePesoLambda(alfa, beta, erroTreinamento);
   
    end
    
    %%----------------------------------------------------
    %%Aplicando o ajuste dos pesos
    %%----------------------------------------------------
    
    pesoA = pesoA - (taxaAprendizado * somatorioAjustePesoA/tamanhoBatch);
    pesoB = pesoB - (taxaAprendizado * somatorioAjustePesoB/tamanhoBatch);
    pesoC = pesoC - (taxaAprendizado * somatorioAjustePesoC/tamanhoBatch);
    
    
    %%Garantindo que os pesos theta e lambda estejam entre 0 e 1
    thetaAntigo = theta;
    theta = theta - (taxaAprendizado * somatorioAjusteTheta/tamanhoBatch);
    
    if(theta < 0)|| (theta >1)
        theta = thetaAntigo;  
    end
    
    lambdaAntigo = lambda;
    lambda = lambda - (taxaAprendizado * somatorioAjusteLambda/tamanhoBatch);
    
    if(lambda < 0)|| (lambda > 1)
        lambda = lambdaAntigo;
    end
    
    %%Calculo do erro MSE Treinamento
    erroMSETreinamento = somatorioErroTreinamento/tamanhoBatch;
      
    
%%--------------------------------------------------------------------------------------------
%%                                 VALIDACAO
%%--------------------------------------------------------------------------------------------
    %%Avisando ao usuario que esta na fase de Validacao
    display('Validacao');
    
    %%calculando a saida do neuronio para a validacao
    for j = 1:tamanhoDeslizeJanelaValidacao
        
        %%----------------------------------------------------
        %%Calculando a saida do neuronio
        %%----------------------------------------------------
        
        % mi = min dilatacao e nu = max erosao
        mi = dilatacaoXPeso(vetorEntradaValidacao(j:(j+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
        nu = erosaoXPeso(vetorEntradaValidacao(j:(j+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

        alfa = (theta * mi) + ((1 - theta) * nu); 
        beta = neuronioMLP(vetorEntradaValidacao(j:(j+(tamanhoEntrada-1))), pesoC, bias);
        saida = (lambda * alfa) + ((1 - lambda) * beta);
        
        %%Salvando saida validacao
        fprintf(arquivoValidacao,'%f\n',saida);
        
        %%Calculando o somatorio do erro
        somatorioErroValidacao = somatorioErroValidacao + (vetorSaidaDesejadaTreinamento(j) - saida).^2;
    end
    
    %%calculo do erro mse
    erroMSEValidacao = somatorioErroValidacao/tamanhoDeslizeJanelaValidacao;
    %%display(erroMSEValidacao);
    fprintf(arquivoMSE,'%f\n',erroMSEValidacao);
    
    
    %%Fazendo analise da curva do MSE
    if erroMSEValidacao > erroMSEValidacaoAnterior
        breakTreinamento = breakTreinamento + 1;
    else 
        breakTreinamento = 0;
    end
    
    %%Atualizando o MSE anterior
    erroMSEValidacaoAnterior = erroMSEValidacao;
    
    contadorExecucoes = contadorExecucoes + 1;
    
    
    %%Apresentando o MSE
    olho = sprintf('MSE Validacao: %d \n',erroMSEValidacao);
    disp(olho);
end

%%--------------------------------------------------------------------------------------------
%%                                         TESTE
%%--------------------------------------------------------------------------------------------

%%Iniciando J
j = 1;

%%Avisando ao usuario que esta na fase de teste
    display('teste');
while (j <= tamanhoDeslizeJanelaTeste)
 
        %%----------------------------------------------------
        %%Calculando a saida do neuronio
        %%----------------------------------------------------
        
        % mi = min dilatacao e nu = max erosao
        mi = dilatacaoXPeso(vetorEntradaTeste(j:(j+(tamanhoEntrada-1))), pesoA, tamanhoEntrada);
        nu = erosaoXPeso(vetorEntradaTeste(j:(j+(tamanhoEntrada-1))), pesoB, tamanhoEntrada);

        alfa = (theta * mi) + ((1 - theta) * nu); 
        beta = neuronioMLP(vetorEntradaTeste(j:(j+(tamanhoEntrada-1))), pesoC, bias);
        saida = (lambda * alfa) + ((1 - lambda) * beta);
        
        %%salvando a saida
        fprintf(arquivoTeste,'%f\n',saida);
        
        
    %%calculo do erro mse
    somatorioErroTeste = somatorioErroTeste + (vetorSaidaDesejadaTeste(j) - saida).^2;
    erroMSETeste = somatorioErroTeste/j;
    fprintf(arquivoMSETeste,'%f\n',erroMSETeste);
    
    %%atualizando m
    j = j + 1;
end    

%%fechando arquivos
fclose(arquivo);
fclose(arquivoValidacao);
fclose(arquivoMSE);
fclose(arquivoTeste);
fclose(arquivoMSETeste);
fclose(arquivoMape);
fclose(arquivoPesoA);
fclose(arquivoPesoB);
fclose(arquivoPesoC);
fclose(arquivoVetorEntrada);



%%--------------------------------------------------------------------------------------------
%%                                 PLOTANDO OS GRAFICOS
%%--------------------------------------------------------------------------------------------
%%Variaveis para leitura de arquivos
valorSaidaTreinamento = zeros(1,tamanhoDeslizeJanelaTreinamento);
valorSaidaValidacao = zeros(1,tamanhoDeslizeJanelaValidacao);
valorMSEValidacao = zeros(1,(contadorExecucoes-1));
valorSaidaTeste = zeros(1,tamanhoDeslizeJanelaTeste);
valorMSETeste = zeros(1,tamanhoDeslizeJanelaTeste);


%Abrindo os arquivos para leitura
arquivo = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_neuronio_treinamento.txt','r');
arquivoValidacao = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_validacao.txt','r'); 
arquivoMSE = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mse_validacao.txt','r');
arquivoTeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\valoresTeste.txt','r');
arquivoMSETeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.txt','r');



%%%%%%%%%%%%%%%%%%%%%%%%
%     TREINAMENTO      %
%%%%%%%%%%%%%%%%%%%%%%%%

%%Obtendo o valor que o neuronio gerou - treinamento
for k = 1:tamanhoDeslizeJanelaTreinamento
    valorSaidaTreinamento(k) = str2num(fgets(arquivo));
end

%%plotando o grafico - TREINAMENTO
figure(1);
plot([1:length(vetorSaidaDesejadaTreinamento)], vetorSaidaDesejadaTreinamento, 'color', 'red');
hold on;
plot([1:tamanhoDeslizeJanelaTreinamento], valorSaidaTreinamento, 'color', 'blue');
legend('valor Desejado','Valor Obtido');
hold off;
title ('Gráfico Valor Desejado (Vermelho) e Saída Obtida (Azul) - Treinamento');



%%%%%%%%%%%%%%%%%%%%%%%%
%      VALIDACAO       %
%%%%%%%%%%%%%%%%%%%%%%%%


%%Obtendo o valor que o neuronio gerou - Validacao
for k = 1:tamanhoDeslizeJanelaValidacao
    valorSaidaValidacao(k) = str2num(fgets(arquivoValidacao));
end

%%plotando o grafico
figure(2);
plot([1:length(vetorSaidaDesejadaValidacao)], vetorSaidaDesejadaValidacao, 'color', 'red');
hold on;
plot([1:tamanhoDeslizeJanelaValidacao], valorSaidaValidacao, 'color', 'blue');
legend('valor Desejado','Valor Obtido');
hold off;
title ('Gráfico Valor Desejado (Vermelho) e Saída Obtida (Azul) - Validacao');


%%Obtendo valor MSE - Validacao
%%for k = 1:tamanhoDeslizeJanelaValidacao
for k = 1:(contadorExecucoes - 1)
    valorMSEValidacao(k) = str2num(fgets(arquivoMSE));
end

%%plotando o grafico MSE Validacao
figure(3);
plot([1:(contadorExecucoes - 1)], valorMSEValidacao, 'color', 'blue');
title ('Gráfico MSE - Validacao');


%%%%%%%%%%%%%%%%%%%%%%%%
%        TESTE         %
%%%%%%%%%%%%%%%%%%%%%%%%

%%Obtendo o valor que o neuronio gerou - Teste
for k = 1:tamanhoBatch
    valorSaidaTeste(k) = str2num(fgets(arquivoTeste));
end

%%plotando o grafico
figure(4);
plot([1:tamanhoBatch], vetorSaidaDesejadaTeste, 'color', 'red');
hold on;
plot([1:tamanhoBatch], valorSaidaTeste, 'color', 'blue');
legend('valor Desejado','Valor Obtido');
hold off;
title ('Gráfico Valor Desejado (Vermelho) e Saída Obtida (Azul) - Teste');


%%Obtendo valor MSE - Teste
for k = 1:tamanhoDeslizeJanelaTeste
    valorMSETeste(k) = str2num(fgets(arquivoMSETeste));
end

%%plotando o grafico MSE Validacao
figure(5);
plot([1:tamanhoDeslizeJanelaTeste], valorMSETeste, 'color', 'blue');
title ('Gráfico MSE - Teste');


%Fechando o arquivo
fclose(arquivo);
fclose(arquivoValidacao);
fclose(arquivoMSE);
fclose(arquivoTeste);
fclose(arquivoMSETeste);
