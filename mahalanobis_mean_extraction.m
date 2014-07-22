function mahala_mean = mahalanobis_mean_extraction(X)

    mahala_mean = zeros(size(X,1),3);
   

    for i=1:size(X,1)
        M = squeeze(X(i,:,:))';  
        mahala_mean(i,:) = mahalanobis_mean(M);
        
    end





end