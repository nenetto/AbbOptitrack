%% Script for Analysis 1
close all
clc
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

for i = 1:Nfiles
   
    fileName = filesData{i};
    analyzeData(fileName);
    
end



%% Join all the files

filesInFolder = ls('*.csv');

DATA = [];

for i = 1:Nfiles
   
    fileName = filesInFolder(i,:);
    dataFile = csvread(fileName);
    
    DATA = cat(1,DATA,dataFile);
    
end

csvwrite('PointsData.csv',DATA);


%% Extract the Registration Matrix

ABBpoints = DATA(:,1:3);
OptMeanPoints = DATA(:,4:6);
OptMahalanobisMeanPoints = DATA(:,7:9);
OptDataSDFirst1000 = DATA(:,10:12);
OptDataSDLast1000 = DATA(:,13:15);


M_t_Mean = pointRegistration(ABBpoints,OptMeanPoints);
M_t_Mahalanobis = pointRegistration(ABBpoints,OptMahalanobisMeanPoints);

OptMeanPoints = pointTransformation(OptMeanPoints,M_t_Mean);
OptMahalanobisMeanPoints = pointTransformation(OptMahalanobisMeanPoints,M_t_Mahalanobis);

OptDataSDFirst1000 = pointTransformation(OptDataSDFirst1000,M_t_Mean);
OptDataSDLast1000 = pointTransformation(OptDataSDLast1000,M_t_Mahalanobis);


scatter3(ABBpoints(:,1),ABBpoints(:,2),ABBpoints(:,3),'+b');
hold on
scatter3(OptMeanPoints(:,1),OptMeanPoints(:,2),OptMeanPoints(:,3),'or');
scatter3(OptMahalanobisMeanPoints(:,1),OptMahalanobisMeanPoints(:,2),OptMahalanobisMeanPoints(:,3),'*g');
axis equal




%% Calculate Error for each point the Registration Matrix

ErrorOptMean = sqrt(sum((ABBpoints-OptMeanPoints).^2,2));
ErrorMahalanobisMean = sqrt(sum((ABBpoints-OptMahalanobisMeanPoints).^2,2));


%% Save the data


data = cat(2,ABBpoints,ErrorOptMean,ErrorMahalanobisMean,OptDataSDFirst1000,OptDataSDLast1000);
save('Results','data');
csvwrite('Results.csv',data);







