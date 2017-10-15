function [ saidaAjustada ] = ajustePesoC(entrada, lambda, erroCalculado)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
saidaAjustada = -2 * erroCalculado * (entrada * (1-lambda));

end

