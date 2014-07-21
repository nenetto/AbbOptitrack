function mahala_mean = mahalanobis_mean(X)

    mahala_mean = zeros(size(X,1),3);
   

    for i=1:size(X,1)
        M = squeeze(X(i,:,:))';  
        mahal_distance = mahal(M,M);
        mahal_distance_inv = 1./mahal_distance;
        mahal_distance_inv_normalized = mahal_distance_inv/sum(mahal_distance_inv);
        
        M(:,1) = M(:,1).*mahal_distance_inv_normalized;
        M(:,2) = M(:,2).*mahal_distance_inv_normalized;
        M(:,3) = M(:,3).*mahal_distance_inv_normalized;
        
        mahala_mean(i,:) = 1000*mean(M,1);
        
    end





end