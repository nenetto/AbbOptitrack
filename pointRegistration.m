function M_transformation = pointRegistration(Target,Source)


    Npuntos = size(Target,1);

    A = zeros(3*Npuntos,12);
    b = zeros(3*Npuntos,1);
    i = 1;

    for q=1:3:Npuntos*3

                A(q,1:4) = [Source(i,:,1), 1];
                A(q+1,5:8) = [Source(i,:,1),1 ];
                A(q+2,9:12) = [Source(i,:,1),1 ];

                b(q:q+2) = Target(i,:,1)';
    i = i+1;
    end

    [vRx, ~, ~] = Svdre(A,b);
    M_transformation =[vRx(1) vRx(2) vRx(3) vRx(4); vRx(5) vRx(6) vRx(7) vRx(8); vRx(9) vRx(10) vRx(11) vRx(12);0 0 0 1];

    
    % Usually, First Transformation is not a good estimator due to some
    % outlier data that affect to the final transformation. 
    % In order to solve it, the FRE is calculated for each point and points
    % with a FRE > abs(medianFRE)
    
    %% FRE calculation
    
    
    Source_transform = pointTransformation(Source,M_transformation);
    
    FRE = (Target-Source_transform).^2;
    FRE = sqrt(sum(FRE,2));
    
    limit = mean(FRE) + 1 * std(FRE);

    
    Target_cut = Target(FRE<limit,:);
    Source_cut = Source(FRE<limit,:);
    
    Npuntos = size(Target_cut,1);

    A = zeros(3*Npuntos,12);
    b = zeros(3*Npuntos,1);
    i = 1;

    for q=1:3:Npuntos*3

                A(q,1:4) = [Source_cut(i,:,1), 1];
                A(q+1,5:8) = [Source_cut(i,:,1),1 ];
                A(q+2,9:12) = [Source_cut(i,:,1),1 ];

                b(q:q+2) = Target_cut(i,:,1)';
    i = i+1;
    end

    [vRx, ~, ~] = Svdre(A,b);
    M_transformation =[vRx(1) vRx(2) vRx(3) vRx(4); vRx(5) vRx(6) vRx(7) vRx(8); vRx(9) vRx(10) vRx(11) vRx(12);0 0 0 1];

    
    
    
end