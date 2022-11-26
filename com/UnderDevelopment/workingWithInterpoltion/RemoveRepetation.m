allDir = dir('C:\Users\dp15aad\Downloads\RBA_EDA\\EDA*')
for i =1:size(allDir,1)
    allFiles = dir(strcat('C:\Users\dp15aad\Downloads\\RBA_EDA\',allDir(i).name,'\RBA*'))
    eval(strcat('mkdir RBA_EDA_processed\',allDir(i).name));
    for f=1:size(allFiles,1)
        currData = load(strcat('C:\Users\dp15aad\Downloads\RBA_EDA\',allDir(i).name,'\',allFiles(f).name));
        currDataF = currData(1:8:size(currData,1),:);
        fName=strcat('RBA_EDA_processed\',allDir(i).name,'\',allFiles(f).name);
        save (fName, 'currDataF', '-ascii');
    end
end

