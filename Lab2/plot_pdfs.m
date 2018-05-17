function [ ] = plot_pdfs( data, x, pdf, dist )
    gauss_pdf = gaussian_mle(data, x);
    exp_pdf = exp_mle(data, x);
    unif_pdf = uniform_mle(data, x);

    parzen_pdf_01 = parzen_est(data, 0.1, x);
    parzen_pdf_04 = parzen_est(data, 0.4, x);

    figure;
    title(strcat(dist, ': Gaussian estimation'));
    hold on;
    plot(x, gauss_pdf);
    plot(x, pdf);
    figure;
    title(strcat(dist, ': Exponential estimation'));
    hold on;
    plot(x, exp_pdf);
    plot(x, pdf);
    figure;
    title(strcat(dist, ': Uniform estimation'));
    hold on;
    plot(x, unif_pdf);
    plot(x, pdf);
    figure;
    title(strcat(dist, ': Parzen estimation (h=0.1)'));
    hold on;
    plot(x, parzen_pdf_01);
    plot(x, pdf);
    figure;
    title(strcat(dist, ': Parzen estimation (h=0.4)'));
    hold on;
    plot(x, parzen_pdf_04);
    plot(x, pdf);
end

