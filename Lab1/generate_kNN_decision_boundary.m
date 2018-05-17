function [ boundary ] = generate_kNN_decision_boundary2(K, samp_1, samp_2, mesh_X, mesh_Y)
    euclidean_dist = @(point, mean) sqrt((point-mean)' * (point-mean));
    
    boundary = zeros(size(mesh_X));
    for i=1:size(mesh_X, 1)
        for j=1:size(mesh_Y, 2)
            point = [mesh_X(i, j); mesh_Y(i, j)];
            dist1 = 999;
            dist2 = 999;
            for k=1:size(samp_1, 1)
                samp = [samp_1(k,1); samp_1(k,2)];
                dist1 = min([dist1,euclidean_dist(point,samp)]);
            end
            for k=1:size(samp_2, 1)
                samp = [samp_2(k,1); samp_2(k,2)];
                dist2 = min([dist2,euclidean_dist(point,samp)]);
            end
            boundary(i, j) = dist1 - dist2;
        end
    end    
end