a = normrnd(5,1, 100, 1);
b = exprnd(1, 100, 1);
x = 0:0.05:10;

pdf_a = normpdf(x, 5, 1);
pdf_b = exppdf(x, 1);

plot_pdfs(a, x, pdf_a, 'A');
plot_pdfs(b, x, pdf_b, 'B');