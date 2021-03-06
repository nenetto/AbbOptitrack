%% Script for Analysis 1
close all
clc
tic
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

delete('Results.csv','PointsData.csv','Mapa_Mahalanobis.csv','Mapa_Mahalanobis_interp.csv','Mapa_Mean.csv','Mapa_Mean_interp.csv');
filesInFolder = ls('*.csv');

DATA = [];

for i = 1:Nfiles
   
    fileName = filesInFolder(i,:);
    dataFile = csvread(fileName,0,0);
    
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

close all
subplot(1,2,1)
scatter3(ABBpoints(:,1),ABBpoints(:,2),ABBpoints(:,3),'+b');
axis equal
title('ABB points')
subplot(1,2,2)
hold on
scatter3(OptMeanPoints(:,1),OptMeanPoints(:,2),OptMeanPoints(:,3),'or');
scatter3(OptMahalanobisMeanPoints(:,1),OptMahalanobisMeanPoints(:,2),OptMahalanobisMeanPoints(:,3),'*g');
title('Optitrack points')
legend('Mean','Mahal mean')
view(3)
axis equal

saveas(gcf,'figure1', 'pdf')

close all
hold on
scatter3(ABBpoints(:,1),ABBpoints(:,2),ABBpoints(:,3),'+b');
scatter3(OptMeanPointsTR(:,1),OptMeanPointsTR(:,2),OptMeanPointsTR(:,3),'or');
scatter3(OptMahalanobisMeanPointsTR(:,1),OptMahalanobisMeanPointsTR(:,2),OptMahalanobisMeanPointsTR(:,3),'*g');
axis equal
view(3)
title('Transformed Points')
legend('ABB','Opt. mean','Opt. Mahal.')
saveas(gcf,'figure2', 'pdf')



%% Calculate Error for each point the Registration Matrix

ErrorOptMeanTR = sqrt(sum((ABBpoints-OptMeanPointsTR).^2,2));
ErrorMahalanobisMeanTR = sqrt(sum((ABBpoints-OptMahalanobisMeanPointsTR).^2,2));

ErrorOptMean = calculateErrorAbsolute(OptMeanPoints,ABBpoints,50.0);
ErrorMahalanobisMean = calculateErrorAbsolute(OptMahalanobisMeanPoints,ABBpoints,50.0);

% Distances to next

DistancesABB = sqrt(sum((ABBpoints(2:end,:)-ABBpoints(1:end-1,:)).^2,2));
DistancesErrorMean = sqrt(sum((OptMeanPoints(2:end,:)-OptMeanPoints(1:end-1,:)).^2,2)) - DistancesABB;
DistancesErrorMahalanobisMean = sqrt(sum((OptMahalanobisMeanPoints(2:end,:)-OptMahalanobisMeanPoints(1:end-1,:)).^2,2)) - DistancesABB;
DistancesErrorMean = abs(DistancesErrorMean);
DistancesErrorMahalanobisMean = abs(DistancesErrorMahalanobisMean);

ABBPoints_halfway = (ABBpoints(2:end,:)+ ABBpoints(1:end-1,:))/2.0;



close all
subplot(2,1,1)
plot(DistancesErrorMean,'r')
hold on
plot(DistancesErrorMahalanobisMean,'g')
title('Error for Distance between points (mm)')
legend('Opt. mean','Opt. Mahal.')
subplot(2,1,2)
plot(ErrorOptMean,'r')
hold on
plot(ErrorMahalanobisMean,'g')
title('Error for Distance to nearest (3D) (mm)')
legend('Opt. mean','Opt. Mahal.')
saveas(gcf,'figure3', 'pdf')



%% Extract the interpolated data

 x = ABBPoints_halfway(:,1); 
 y = ABBPoints_halfway(:,2);
 z = ABBPoints_halfway(:,3);
 v1 = DistancesErrorMean;
 v2 = DistancesErrorMahalanobisMean;

 di = 50;
 dh = di/2;
% Data Interpolation to a origin space
[xq,yq,zq] = meshgrid(-200:di:200,-150:di:150,-250:di:250);

 x2 = ABBpoints(:,1); 
 y2 = ABBpoints(:,2);
 z2 = ABBpoints(:,3);
[xq2,yq2,zq2] = meshgrid(min(x2):di:max(x2),min(y2):di:max(y2),min(z2):di:max(z2));

vq1 = griddata(x,y,z,v1,xq2,yq2,zq2,'linear');
vq2 = griddata(x,y,z,v2,xq2,yq2,zq2,'linear');

vq1 = filterNaNValues(vq1);
vq2 = filterNaNValues(vq2);


Points = [xq(:),yq(:),zq(:)];
DistancesErrorMean_interp = vq1(:);
DistancesErrorMahalanobisMean_interp = vq2(:);



%% Show the distance error

N = length(DistancesErrorMean);
close all
subplot(2,1,1)
hist(DistancesErrorMean,N)
 xlim([0,1.5])
 title('Hist. Distance Error Mean (mm)')
subplot(2,1,2)
hist(DistancesErrorMahalanobisMean,N)
 xlim([0,1.5])
 title('Hist. Distance Error Mahal (mm)')
saveas(gcf,'figure4', 'pdf')
 

close all
subplot(2,1,1)
hist(ErrorOptMean,N*4)
 xlim([0,1.5])
 title('Hist. Distance Error Mean 3D (mm)')
subplot(2,1,2)
hist(ErrorMahalanobisMean,N*4)
 xlim([0,1.5])
 title('Hist. Distance Error Mahal 3D (mm)')
saveas(gcf,'figure5', 'pdf')




%% Field Map figure


%% Mahalanobis Map INTERP

limit = mean(DistancesErrorMahalanobisMean_interp) + 1.96 * std(DistancesErrorMahalanobisMean_interp);
indxA = DistancesErrorMahalanobisMean_interp < limit;

x = ABBpoints(indxA,1);
y = ABBpoints(indxA,2);
z = ABBpoints(indxA,3);
v = DistancesErrorMahalanobisMean_interp(indxA);

headers = {'x_coord ', 'y_coord ', 'z_coord ', '(a)Error Mahal.(mm)'};
M = [x,y,z,v];
csvwrite_with_headers('Mapa_Mahalanobis_interp.csv',M,headers);



%% Mean Map INTERP

limit = mean(DistancesErrorMean_interp) + 1.96 * std(DistancesErrorMean_interp);
indxB = DistancesErrorMean_interp < limit;

x = ABBpoints(indxB,1);
y = ABBpoints(indxB,2);
z = ABBpoints(indxB,3);
v = DistancesErrorMean_interp(indxB);

headers = {'x_coord ', 'y_coord ', 'z_coord ', '(a)Error Mean(mm)'};
M = [x,y,z,v];
csvwrite_with_headers('Mapa_Mean_interp.csv',M,headers);

%% Mean Map 

limit = mean(ErrorOptMean) + 1.96 * std(ErrorOptMean);
indxC = ErrorOptMean < limit;

x = ABBpoints(indxC,1);
y = ABBpoints(indxC,2);
z = ABBpoints(indxC,3);
v = ErrorOptMean(indxC);

headers = {'x_coord ', 'y_coord ', 'z_coord ', '(b)Error Mean(mm)'};
M = [x,y,z,v];
csvwrite_with_headers('Mapa_Mean.csv',M,headers);


%% Mean Mahalanobis Map 

limit = mean(ErrorMahalanobisMean) + 1.96 * std(ErrorMahalanobisMean);
indxD = ErrorMahalanobisMean < limit;

x = ABBpoints(indxD,1);
y = ABBpoints(indxD,2);
z = ABBpoints(indxD,3);
v = ErrorMahalanobisMean(indxD);

headers = {'x_coord ', 'y_coord ', 'z_coord ', '(b)Error Mahal.(mm)'};
M = [x,y,z,v];
csvwrite_with_headers('Mapa_Mahalanobis.csv',M,headers);


%% Save the data


data = cat(2,ABBpoints,DistancesErrorMahalanobisMean_interp,...
                        DistancesErrorMean_interp,...
                        ErrorOptMean,...
                        ErrorMahalanobisMean,...
                        indxA,...
                        indxB,...
                        indxC,...
                        indxD);
save('Results','data');
headers = {'x_coord ', 'y_coord ', 'z_coord ',...
            'Distance.Next.Mean.mm',...
            'Distance.Next.Mahal.mm',...
            'Error.3Dclosest.Mean.mm',...
            'Error.3Dclosest.Mahal.mm',...
            'No.Outliers.Distance.Next.Mean.mm.FACTOR',...
            'No.Outliers.Distance.Next.Mahal.mm.FACTOR',...
            'No.Outliers.Error.3Dclosest.Mean.mm.FACTOR',...
            'No.Outliers.Error.3Dclosest.Mahal.mm.FACTOR'};

csvwrite_with_headers('Results.csv',data,headers);


toc



