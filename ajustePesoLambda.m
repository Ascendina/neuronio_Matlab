function [ saidaAjustada ] = ajustePesoLambda(alfa, beta, erroCalculado)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
saidaAjustada = -2 * (erroCalculado)* (alfa - beta);

end

