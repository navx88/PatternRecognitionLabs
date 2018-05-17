function [ y ] = parzen_est( data, h, x )
    N = size(data, 1);
    y = zeros(size(x,2));

    for i = 1:size(x, 2)
       y(i) = 0;
       for j = 1:N
          y(i) = y(i) + (1/sqrt(2*pi)*exp(-(x(i)-data(j))^2/(2*h^2))/h);
       end
       y(i) = y(i)/N;
    end
end