%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica Graficos  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Indicando o tamanho da entrada e quantas iteracoes terao o treinamento 
%% validacao e teste
tamanhoEntrada = 200;
quantidadeEntradasTreinadas = 132;
quantidadeEntradasTeste = 368;

%%Abrindo arquivos para leitura
arquivo = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\saida_neuronio_treinamento.txt','r');
arquivoMSE = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mse_validacao.txt','r');
arquivoTeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\valoresTeste.txt','r');
arquivoMSETeste = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mseTeste.txt','r');
arquivoMape = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\mapeTeste.txt','r');
arquivoVetorEntrada = fopen('C:\Users\Mila\Documents\series_temporais\series_financeiras\neuronio_morfologico\neuronio_Matlab\vetorEntrada.txt','r');

%%variaveis do programa
valorDesejado = zeros(1,quantidadeEntradasTreinadas);
valorSaida = zeros(1,quantidadeEntradasTreinadas);
lixo = 0; %%utilizado para descartar as leituras que nao correspondem aos valores das informacoes
valorDesejadoTeste = zeros(1,quantidadeEntradasTeste);
valorSaidaTeste = zeros(1,quantidadeEntradasTeste);
valorSaidaMSE = zeros(1,quantidadeEntradasTeste);
valorSaidaMAPE = zeros(1,quantidadeEntradasTeste);

%%Variavel utilizada no loop
l = 1;
%%Obtendo Valor Desejado
%%(132 - que foi ate aonde o neuronio treinou = 201 + 132 = 333)
for i = 1:(201 + (quantidadeEntradasTreinadas-1)) 
    
    if(i >= 201)
        valorDesejado(l) = str2num(fgets(arquivoVetorEntrada));
        l = l + 1;
    else
        lixo = str2num(fgets(arquivoVetorEntrada));
    end
end

%%Obtendo o valor que o neuronio gerou
for k = 1:(quantidadeEntradasTreinadas-1)
    valorSaida(k) = str2num(fgets(arquivo));
end


%%plotando o grafico - TREINAMENTO
figure(1);
plot([1:132], valorDesejado, 'color', 'red');
hold on;
plot([1:132], valorSaida, 'color', 'blue');
legend('valor Desejado','Valor Obtido');
hold off;
title ('Gráfico Valor Desejado (Vermelho) e Saída Obtida (Azul) - Treinamento');


l = 1;
%%reunindo dados teste
for i = quantidadeEntradasTreinadas:(1703 + quantidadeEntradasTeste-1) 
    
    if(i >= 1703)
        valorDesejadoTeste(l) = str2num(fgets(arquivoVetorEntrada));
        l = l + 1;
    else
        lixo = str2num(fgets(arquivoVetorEntrada));
    end
end


%%Obtendo o valor que o neuronio gerou
for k = 1:(quantidadeEntradasTeste-1)
    valorSaidaTeste(k) = str2num(fgets(arquivoTeste));
end

%%plotando o grafico - TESTE
figure(2);
plot([1:368], valorDesejadoTeste, 'color', 'red');
hold on;
plot([1:368], valorSaidaTeste, 'color', 'blue');
legend('valor Desejado','Valor Obtido');
hold off;
title ('Gráfico Valor Desejado e Saída Obtida - Teste');



%%Obtendo valor MSE - TESTE
for k = 1:(quantidadeEntradasTeste-1)
    valorSaidaTeste(k) = str2num(fgets(arquivoMSETeste));
end

%%plotando o grafico - TESTE
figure(3);
plot([1:368], valorSaidaTeste, 'color', 'blue');
title ('Gráfico MSE - Teste');



%%Obtendo valor MAPE - TESTE
for k = 1:(quantidadeEntradasTeste-1)
    valorSaidaMAPE(k) = str2num(fgets(arquivoMape));
end

%%plotando o grafico - TESTE
figure(4);
plot([1:368], valorSaidaMAPE, 'color', 'blue');
title ('Gráfico MAPE - Teste');


%%fechando arquivos
fclose(arquivo);
fclose(arquivoMSE);
fclose(arquivoTeste);
fclose(arquivoMSETeste);
fclose(arquivoMape);
fclose(arquivoVetorEntrada);