function centroid = centroidTukey(X,n)

if nargin <2
   n = 220;
end;

depthsVector = zeros(1,size(X,1));

for i = 1:size(X,1)
    depthsVector(i) = depthTukey(X(i,:),X,n); 
end

maxDepth = max(depthsVector);

Y = X(depthsVector==maxDepth,:);
centroid = mean(Y,1);

end