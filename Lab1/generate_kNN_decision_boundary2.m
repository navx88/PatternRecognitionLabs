function [ boundary ] = generate_kNN_decision_boundary2(K, samp_1, samp_2, mesh_X, mesh_Y)
    euclidean_dist = @(point, mean) sqrt((point-mean)' * (point-mean));
    
    boundary = zeros(size(mesh_X));
    for i=1:size(mesh_X, 1)
        for j=1:size(mesh_Y, 2)
            point = [mesh_X(i, j); mesh_Y(i, j)];
            dists1 = zeros(1,size(samp_1,1));
            dists2 = zeros(1,size(samp_2,1));
            for k=1:size(samp_1, 1)
                samp = [samp_1(k,1); samp_1(k,2)];
                dists1(k) = euclidean_dist(point,samp);
            end
            for k=1:size(samp_2, 1)
                samp = [samp_2(k,1); samp_2(k,2)];
                dists2(k) = euclidean_dist(point,samp);
            end
            dists1 = sort(dists1);
            dists2 = sort(dists2);
            dist1 = 0;
            dist2 = 0;
            for n=1:K
                dist1 = dist1 + dists1(n);
                dist2 = dist2 + dists2(n);
            end
            dist1 = dist1/K;
            dist2 = dist2/K;
            boundary(i, j) = dist1 - dist2;
        end
    end    
end