function extractDatafromFile(fileName,N)

    if nargin <2
       N=100;
    end;

    N_real = 0;
    
    AbbData = zeros(N,3);
    OptData = zeros(N,3,2000);

    fid = fopen(fileName,'r');

    for i=1:N

        % Abb points
        for j = 1:3
            tline = fgetl(fid);
            if(~ischar(tline))
                break;
            end
            AbbData(i,j) = str2double(tline);
        end

        % Opt points
        for j = 1:3
            tline = fgetl(fid);
            if(~ischar(tline))
                break;
            end
            data = textscan(tline, '%f', 'delimiter', ',');
            OptData(i,j,:) = data{1};

        end 

    end

    fclose(fid);

    
    
    fid = fopen(fileName);

    tline = fgetl(fid);
    while ischar(tline)
        N_real = N_real + 1;
        tline = fgetl(fid);
    end

    fclose(fid);
    
    
    N_real = N_real/6;
    
    %% Save data

    AbbData = AbbData(1:N_real,:);
    OptData = OptData(1:N_real,:,:);
    
    % AbbData3, NormalMean3, MedianTukey3, MahalanobisMean3

    data = cell(2);
    data{1} = AbbData;
    data{2} = OptData;
    fileName_cut  = regexprep(fileName, '.txt', 'DATA.mat');
    save(fileName_cut,'data');
    
    
    
    
    
    
end