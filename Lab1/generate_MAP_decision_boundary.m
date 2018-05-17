function [ boundary ] = generate_MAP_decision_boundary(mu_1, mu_2, sigma_1, sigma_2, prior_1, prior_2, mesh_X, mesh_Y)
    
    boundary = zeros(size(mesh_X));
    for i=1:size(mesh_X, 1)
        for j=1:size(mesh_Y, 2)
            point = [mesh_X(i, j); mesh_Y(i, j)];
            boundary(i, j) = ((point - mu_2)' * inv(sigma_2) * (point - mu_2) ...
                              - (point - mu_1)' * inv(sigma_1) * (point - mu_1) ...
                              - 2 * log(prior_2/prior_1) - log(det(sigma_1)/det(sigma_2)));
        end
    end    
end