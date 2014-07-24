function errorResult = calculateErrorAbsolute(evaluatedPoints,truePoints,fixdistance)

index = findClosestIndex(truePoints,fixdistance);

N = size(evaluatedPoints,1);

errorResult = zeros(N,1);
errorOverPoints = [];
for i=1:N
    
    point = evaluatedPoints(i,:);
    
    for j=1:size(index{i},2)
        
        er = point-evaluatedPoints(index{i}(j),:);
        er = norm(er,2)-50.0;
        
        %errorResult(i) = errorResult(i) + er;
        errorOverPoints(j) = er;
    end
    
    
    %errorResult(i) = errorResult(i)/size(index{i},2);
    errorResult(i) = median(errorOverPoints);
    
end



end