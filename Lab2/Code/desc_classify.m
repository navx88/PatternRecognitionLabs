function [ class ] = desc_classify(x, y, G_W, G_W0, G_n_ab, G_n_ba)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    class = 0;
    num_discriminants = size(G_W,2);
    
    most_likely_class = 0;
    lowest_number_of_misclassification = Inf;
    
    for i=1:num_discriminants
        g = G_W(:,i)'*[x; y] + G_W0(i);
        if (g > 0) && (G_n_ba(i) == 0)
            class = 1;
            break;
        elseif (g < 0) && (G_n_ab(i) == 0)
            class = -1;
            break;
        end
        
        if (g > 0) && (G_n_ba(i) < lowest_number_of_misclassification)
            lowest_number_of_misclassification = G_n_ba(i);
            most_likely_class = 1;
        elseif (g < 0)  && (G_n_ab(i) < lowest_number_of_misclassification)
            lowest_number_of_misclassification = G_n_ab(i);
            most_likely_class = -1;
        end
        
    end
    
    if (class == 0)
        class = most_likely_class;
    end
end

