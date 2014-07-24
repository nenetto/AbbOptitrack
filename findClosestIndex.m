function index = findClosestIndex(Points,distance)

    N = size(Points,1);

    distance = double(distance);

    neib = zeros(6,3);
    neib_valid = [];
    index = cell(N,1);

    for i=1:N
        %for each point create the six neibourghs

        neib(1,:) = Points(i,:) + [0,0,distance];
        neib(2,:) = Points(i,:) + [0,0,-distance];
        neib(3,:) = Points(i,:) + [0,distance,0];
        neib(4,:) = Points(i,:) + [0,-distance,0];
        neib(5,:) = Points(i,:) + [distance,0,0];
        neib(6,:) = Points(i,:) + [-distance,0,0];

        k = 1;
        for j=1:6
            Lia = find(ismember(Points,neib(j,:),'rows'), 1);
            if(~isempty(Lia))
                neib_valid(k) = Lia;
                k = k+1;
            end
        end

            index{i} = neib_valid;


    end

end
