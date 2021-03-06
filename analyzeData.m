function analyzeData(fileData)

    %Read the file
    load(fileData);
    
    AbbData = data{1};
    OptData = data{2};

    %% Extract the mean and median
    normal_mean = mean(OptData(:,:,1:1000),3);
    % OptDataTukey = medianTukey(OptData(:,:,1001:end));
    OptMahalanobisMean = mahalanobis_mean_extraction(OptData(:,:,1001:end));
    OptDataSDFirst1000  = std(OptData(:,:,1:1000),0,3);
    OptDataSDLast1000  = std(OptData(:,:,1001:end),0,3);

    %% Save data

    % AbbData3, NormalMean3,, MahalanobisMean3

    data = cat(2,AbbData,normal_mean,OptMahalanobisMean,OptDataSDFirst1000,OptDataSDLast1000);
    fileName_cut  = regexprep(fileData, 'DATA.mat', '.csv');
    save(fileName_cut,'data');
    csvwrite(fileName_cut,data);

