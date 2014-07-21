function extractDatafromFile(fileName,N)

    if nargin <2
       N=100;
    end;

    AbbData = zeros(N,3);
    OptData = zeros(N,3,2000);

    fid = fopen(fileName,'r');

    for i=1:N

        % Abb points
        for j = 1:3
            tline = fgetl(fid);
            AbbData(i,j) = str2double(tline);
        end

        % Opt points
        for j = 1:3
            tline = fgetl(fid);
            data = textscan(tline, '%f', 'delimiter', ',');
            OptData(i,j,:) = data{1};

        end 

    end

    fclose(fid);
    
    %% Save data

    % AbbData3, NormalMean3, MedianTukey3, MahalanobisMean3

    data = cell(2);
    data{1} = AbbData;
    data{2} = OptData;
    fileName_cut  = regexprep(fileName, '.txt', 'DATA.mat');
    save(fileName_cut,'data');
    
    
    
    
    
    
end