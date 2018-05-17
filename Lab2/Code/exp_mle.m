function [ pdf ] = exp_mle( data, x )
    lambda = mle(data, 'distribution', 'exponential');
    pdf = exppdf(x, lambda);
end

