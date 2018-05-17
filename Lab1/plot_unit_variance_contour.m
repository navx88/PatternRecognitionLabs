function plot_unit_variance_contour(mu, sigma, color)
    [eig_vecs, eig_vals] = eig(sigma);
    theta = atan(eig_vecs(2,2)/eig_vecs(2,1));
    plot_ellipse(mu(1),mu(2),theta,sqrt(eig_vals(2,2)),sqrt(eig_vals(1,1)), color);
end
