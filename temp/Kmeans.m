function [ prototypes, iterations ] = Kmeans( data, K )

    % assumes data is 4xL, where:
    %   data(3,:) refer to actual class
    %   data(1,:) are feature 1 values 
    %   data(2,:) are feature 2 values
    
    prototypes = zeros(2,K);
    L = length(data);
    
    iterate = 1;
    iterations = 0;
    
    for i=1:K
        prototypes(:,i) = data(1:2,randi(L));
%         prototypes(1,i) = data(1,randi(L));
%         prototypes(2,i) = data(2,randi(L));
    end
    
    
    
%     prototypes
    
    while(iterate)
%         temp = zeros(2,1)
%         dist_min = 0;
        oldprotos = prototypes;
        sums = zeros(3,K); % reset sum for mean calc
        % sums(3,:) is the number of pts for each sum
        
        for i=1:L % iterate through all pts in set
            
            dist_min = 999999; % reset min dist
            estclass = 0; % reset estimated class id
            pt = data(1:2,i); % store the current pt
            
            for j=1:K % iterate through classes for each pt
                % check if pt is closer to current class
                if dist_min > norm(pt-prototypes(:,j))
                    % if true, set new dist min
                    dist_min = norm(pt-prototypes(:,j));
                    estclass = j; % set estclass id
                end
            end
            
            % enter pt to appropriate class sum
            sums(1:2,estclass) = sums(1:2,estclass) + pt;
            sums(3,estclass) = sums(3,estclass) + 1;
            
        end
        
        for i=1:K
            prototypes(1:2,i) = sums(1:2,i)/sums(3,i);
        end
        
        if oldprotos == prototypes
            iterate = 0;
        end
        
%         iterations
%         sums
%         oldprotos
%         prototypes
        
        iterations = iterations + 1;
        if(iterations >= 200)
            iterate = 0;
        end
            
    end
end

