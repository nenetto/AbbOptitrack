function Points_t = pointTransformation(Points,M_t)


    Points = cat(2,Points,ones(size(Points,1),1));

    Points_t = Points*M_t';
    
    Points_t = Points_t(:,1:3);
    
end