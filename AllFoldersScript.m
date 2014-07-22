
% Search each folder and process ExtractAllData in each one

folders = ls;
folders = folders(3:end,:);


for i = 1: size(folders,1)
   
    if(isdir(folders(i,:)))
        folders(i,:)
        oldFolder = cd(folders(i,:));
        ExtracAllData
        cd(oldFolder);
    end
    
end