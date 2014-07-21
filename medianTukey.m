function median = medianTukey(X,n)

    if nargin <2
       n=220;
    end;

    median = zeros(size(X,1),3);

    for i=1:size(X,1)
       Y = squeeze(X(i,:,:))';        
        median(i,:) = centroidTukey(Y,n);
    end

end