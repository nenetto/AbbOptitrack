function mahala_mean = mahalanobis_mean_extraction(X)

    mahala_mean = zeros(size(X,1),3);
   

    for i=1:size(X,1)
        M = squeeze(X(i,:,:))';  
        mahala_mean(i,:) = mahalanobis_mean(M);
        
        if(isnan(mahala_mean(i,:)))
            warning('***************************************************')
            warning('********                                    *******')
            warning('****        LOS DATOS PODRIAN ESTAR MAL        ****')
            warning('********                                    *******')
            warning('***************************************************')
            
            mahala_mean(i,:) = mean(M,1);
        end
        
    end





end