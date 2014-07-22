function mahala_mean = mahalanobis_mean(X)
   
        mahal_distance = mahal(X,X);
        mahal_distance_inv = 1./mahal_distance;
        mahal_distance_inv_normalized = mahal_distance_inv/sum(mahal_distance_inv);
        
        X(:,1) = X(:,1).*mahal_distance_inv_normalized;
        X(:,2) = X(:,2).*mahal_distance_inv_normalized;
        X(:,3) = X(:,3).*mahal_distance_inv_normalized;
        
        mahala_mean = 1000*mean(X,1);

end