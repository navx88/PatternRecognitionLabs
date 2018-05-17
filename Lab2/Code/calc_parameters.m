function [ mu, var ] = calc_parameters( samples )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    parameters = samples;
    p1 = mle(parameters(1,:));
    p2 = mle(parameters(2,:));
    
    mu = [p1(1); p2(1)];
    var = cov(samples');

end

