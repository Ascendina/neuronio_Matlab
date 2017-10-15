function [ saidaAjustada ] = ajustePesoTheta(lambda, mi, nu, erroCalculado)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    saidaAjustada = -2 * (erroCalculado) * (lambda * (mi - nu));

end

