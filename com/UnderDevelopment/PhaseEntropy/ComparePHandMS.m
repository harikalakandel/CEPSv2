% Regarding the validity of CG displacement in multiscale PhEn, I would like to say that it has the discriminating power as tested with my data. However, I have some queries listed below for its validity as a tool.
% 
% 1. Is there any difference between entropy computation with the k number of sectors and the multiscale entropy computed with (k/n) number of sectors with scale (n).
% 2. for instance, k = 16 fr regular PhEn. and k=4 with scale =4 in multiscale PhEn.
% If there is a difference theoretically or computationally, then this metric would also be useful.


fileDir = dir('../../../Data/SampleData/EEG_Data/');

N=10
kSector=N



currData = load('../../../Data/SampleData/EEG_Data/file_1.txt');
plot(currData)

CGAData=nan(N+1,N+1);
CGAData(1,2:end)=1:N;
CGAData(2:end,1)=1:N;
for kSector=1:N
%for i=1:size(fileDir,1)
   % currData = load(strcat('../../../Data/SampleData/EEG_Data/',fileDir(i).name));
    
    for scale=1:N
        
        CGAData(kSector+1,scale+1)= getMS_PhEntropy_CGData(currData,kSector,scale);
        
        
    end
%end
end


CGAData


CGA=nan(N+1,N+1);
CGA(1,2:end)=1:N;
CGA(2:end,1)=1:N;

diff = CGA;

for kSector=1:N
%for i=1:size(fileDir,1)
   % currData = load(strcat('../../../Data/SampleData/EEG_Data/',fileDir(i).name));
    
    for scale=1:N
        
        CGA(kSector+1,scale+1)= getPhEntropyV1_Corrected(currData,kSector*scale);
        diff(kSector+1,scale+1)= CGA(kSector+1,scale+1) - CGAData(kSector+1,scale+1);
    end
%end
end

CGA
diff