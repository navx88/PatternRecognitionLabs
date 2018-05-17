function [ boundary ] = combine_regions(d_1_2, d_2_3, d_3_1)
    boundary = zeros(size(d_1_2));
    
    for i=1:size(d_1_2, 1)
        for j=1:size(d_1_2, 2)
            
            if d_1_2(i,j) >= 0 && d_2_3(i,j) <= 0
                class = 1;
            elseif d_1_2(i,j) <= 0 && d_3_1(i,j) >= 0
                class = 2;
            elseif d_2_3(i,j) >= 0 && d_3_1(i,j) <= 0
                class = 3;
            end
            
            boundary(i,j) = class;
                         
        end
    end
end