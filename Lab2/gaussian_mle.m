function [ pdf ] = gaussian_mle( data, x )
    data = mle(data);
    mu = data(1);
    sigma = data(2);

    pdf = normpdf(x, mu, sigma);
end

