%% Script for Analysis 1

% This script extract the points, mean, Tukey mean and Mahalanobis mean and
% save the data for each file with the same name of file

filesInFolder = ls('d*.txt');

%matlabpool open local

Nfiles = size(filesInFolder,1);


for i = 1:Nfiles
    extractDatafromFile(filesInFolder(i,:),100)
    filesData{i} = regexprep(filesInFolder(i,:), '.txt', 'DATA.mat');
end

%matlabpool close


%% Extract the means and SD

parfor i = 1:Nfiles
   
    fileName = filesData{i};
    analyzeData(fileName);
    
    
end



