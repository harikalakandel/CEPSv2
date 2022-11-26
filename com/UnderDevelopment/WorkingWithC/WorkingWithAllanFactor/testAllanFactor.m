vecData = [28    68    66    17    12    50    96    35    59    23    76    26    51    70    90    96    55    14    15    26    85 25    26    82    25    93]';

allan=nan(20,1);
for window=1:20
    allan(window,1) = getAllanFactor(vecData,window);
end
allan'

dbFiles = dir('RR_Files/*.txt')
myResults={};
%%header
myResults{1,1}='Files';
 for windowSize=1:20
     myResults{1,windowSize+1}=strcat('wSize-',num2str(windowSize));
 end
for fIndex=1:size(dbFiles,1)
   
    myResults{fIndex+1,1}=dbFiles(fIndex).name;
    vecData = load(strcat('RR_files/',dbFiles(fIndex).name));
    for windowSize=1:20
        myResults{fIndex+1,windowSize+1}= getAllanFactor(vecData,window);
    end
end
myResults