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

% 

L = 639;

M_t_Mean = pointRegistration(ABBpoints(1:L,:),OptMeanPoints(1:L,:));
M_t_Mahalanobis = pointRegistration(ABBpoints(1:L,:),OptMahalanobisMeanPoints(1:L,:));

OptMeanPointsTR = pointTransformation(OptMeanPoints,M_t_Mean);
OptMahalanobisMeanPointsTR = pointTransformation(OptMahalanobisMeanPoints,M_t_Mahalanobis);

OptDataSDFirst1000TR = pointTransformation(OptDataSDFirst1000,M_t_Mean);
OptDataSDLast1000TR = pointTransformation(OptDataSDLast1000,M_t_Mahalanobis);


subplot(1,3,1)
scatter3(ABBpoints(:,1),ABBpoints(:,2),ABBpoints(:,3),'+b');
axis equal
subplot(1,3,2)
hold on
scatter3(OptMeanPoints(:,1),OptMeanPoints(:,2),OptMeanPoints(:,3),'or');
scatter3(OptMahalanobisMeanPoints(:,1),OptMahalanobisMeanPoints(:,2),OptMahalanobisMeanPoints(:,3),'*g');
axis equal

subplot(1,3,3)
hold on
scatter3(ABBpoints(:,1),ABBpoints(:,2),ABBpoints(:,3),'+b');
scatter3(OptMeanPointsTR(:,1),OptMeanPointsTR(:,2),OptMeanPointsTR(:,3),'or');
scatter3(OptMahalanobisMeanPointsTR(:,1),OptMahalanobisMeanPointsTR(:,2),OptMahalanobisMeanPointsTR(:,3),'*g');
axis equal




%% Calculate Error for each point the Registration Matrix

ErrorOptMean = sqrt(sum((ABBpoints-OptMeanPointsTR).^2,2));
ErrorMahalanobisMean = sqrt(sum((ABBpoints-OptMahalanobisMeanPointsTR).^2,2));

% Distances

DistancesABB = sqrt(sum((ABBpoints(2:end,:)-ABBpoints(1:end-1,:)).^2,2));

DistancesErrorMean = sqrt(sum((OptMeanPoints(2:end,:)-OptMeanPoints(1:end-1,:)).^2,2)) - DistancesABB;
DistancesErrorMahalanobisMean = sqrt(sum((OptMahalanobisMeanPoints(2:end,:)-OptMahalanobisMeanPoints(1:end-1,:)).^2,2)) - DistancesABB;

DistancesErrorMean = abs(DistancesErrorMean);
DistancesErrorMahalanobisMean = abs(DistancesErrorMahalanobisMean);

figure
plot(DistancesErrorMean)
hold on
plot(DistancesErrorMahalanobisMean,'g')



%% Extract the gradient
% 
% OptMeanPoints
% 
% x = OptMeanPoints(indx,1);
% y = OptMeanPoints(indx,2);
% z = OptMeanPoints(indx,3);
% N = length(OptMeanPoints);
% [xq,yq,zq] = meshgrid(linspace(xmin,xmax,N),linspace(ymin,ymax,N),linspace(zmin,zmax,N));
% 
% d = 50; % distancia entre valor y valor
% [PX,PY,PZ] = gradient(F,d,d,d)






%% Save the data


data = cat(2,ABBpoints,ErrorOptMean,ErrorMahalanobisMean,OptDataSDFirst1000TR,OptDataSDLast1000TR);
save('Results','data');
csvwrite('Results.csv',data);


%% Show the distance error

% N = 1000;
% 
% figure
% subplot(2,1,1)
% hist(DistancesErrorMean,N)
%  xlim([0,1.5])
% subplot(2,1,2)
% hist(DistancesErrorMahalanobisMean,N)
%  xlim([0,1.5])


%% Field Map figure
% 

x = ABBpoints(indx,1);
y = ABBpoints(indx,2);
z = ABBpoints(indx,3);
v = ErrorMahalanobisMean(indx);


headers = {'x_coord ', 'y_coord ', 'z_coord ', 'Error (mm) '};
M = [x,y,z,v];
csvwrite_with_headers('Mapa.csv',M,headers);





