function [ pdf ] = uniform_mle( data, x )
    data = mle(data, 'distribution', 'uniform');
    a = data(1);
    b = data(2);
    pdf = unifpdf(x, a, b);
end

