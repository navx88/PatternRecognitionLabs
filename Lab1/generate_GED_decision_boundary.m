function [ boundary ] = generate_GED_decision_boundary(mu_1, mu_2, sigma_1, sigma_2, mesh_X, mesh_Y)
    generalized_euclidean_dist = @(point, mean, sigma) sqrt((point-mean)' * inv(sigma) * (point-mean));
    
    boundary = zeros(size(mesh_X));
    for i=1:size(mesh_X, 1)
        for j=1:size(mesh_Y, 2)
            point = [mesh_X(i, j); mesh_Y(i, j)];
            boundary(i, j) = generalized_euclidean_dist(point, mu_1, sigma_1) - generalized_euclidean_dist(point, mu_2, sigma_2);
        end
    end    
end