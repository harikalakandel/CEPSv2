
addpath('../');

fDir=dir('*.txt')


tmpVal = {};

%%writing Heading
tmpVal{1,1}='N-Sector';
for fIndex=1:size(fDir,1)
    
    tmpVal{1,fIndex+1}=fDir(fIndex).name;
    for noSector=2:50
        tmpVal{noSector,1}=noSector;
    end
end

for fIndex=1:size(fDir,1)
    currData = load( fDir(fIndex).name);
   
    
 for noSector=2:50
     currResult=[];
    for i=1:size(currData,2)

        currResult=[currResult;getPhEntropyV1_Corrected(currData(isnan(currData(:,i))==0,i),noSector)];
    end
    tmpVal{noSector,fIndex+1}=mean(currResult);
 end
end
tmpVal



