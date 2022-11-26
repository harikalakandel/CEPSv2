fileDir = dir('../../../Data/SampleData/EEG_Data/');

N=10
noSector=N



currData = load('../../../Data/SampleData/EEG_Data/file_1.txt');
plot(currData)

CGADisp=nan(N,N);
for noSector=1:N
%for i=1:size(fileDir,1)
   % currData = load(strcat('../../../Data/SampleData/EEG_Data/',fileDir(i).name));
    
    for scale=1:N
        
        CGADisp(noSector,scale)= getMS_PhEntropy_CGADisp(currData,noSector,scale);
    end
%end
end


CGAData=nan(N,N);
for noSector=1:N
%for i=1:size(fileDir,1)
   % currData = load(strcat('../../../Data/SampleData/EEG_Data/',fileDir(i).name));
    
    for scale=1:N
        
        CGAData(noSector,scale)= getMS_PhEntropy_CGData(currData,noSector,scale);
    end
%end
end



CGADisp
CGAData
