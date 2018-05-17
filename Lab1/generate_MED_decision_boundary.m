function [ boundary ] = generate_MED_decision_boundary(mu_1, mu_2, mesh_X, mesh_Y)
    euclidean_dist = @(point, mean) sqrt((point-mean)' * (point-mean));
    
    boundary = zeros(size(mesh_X));
    for i=1:size(mesh_X, 1)
        for j=1:size(mesh_Y, 2)
            point = [mesh_X(i, j); mesh_Y(i, j)];
            boundary(i, j) = euclidean_dist(point, mu_1) - euclidean_dist(point, mu_2);
        end
    end    
end