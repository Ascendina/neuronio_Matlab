%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%    Rede Neural Morfologica   %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Parametros - tamanho
tamanhoEntrada = 6;
iteracoesTreinamentoValidacao = 1000;
taxaAprendizado = 0.5;
epocasValidacao = 3;

%%Iniciando pesos
lambda = 0.1;
theta = 0.1;
pesoA = ones(1,tamanhoEntrada);
pesoB = ones(1,tamanhoEntrada);
pesoC = ones(1,tamanhoEntrada);
bias = 1;


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

while (i < iteracoesTreinamentoValidacao)
    
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

%%Erro total = valor desejado - valor obtido
erro = calculoErro(valorDesejado(i), saida(i));

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

    if k < epocasValidacao
      k = k + 1;
    else
       
    end


%%atualizando ponteiros
i = i + 1;
end