files=dir('../Data/HRVAnalysis_Results/*.txt')

for fIndex=1:size(files,1)
    fileID = fopen(strcat('../Data/HRVAnalysis_Results/',files(fIndex).name),'r');
end