files = dir('../../Data/SampleData/RR_Data/*.txt')
%PLZC(data,m,lag)
m=3;
lag=2;
for f=1:size(files,1)
    data = load(strcat('../../Data/SampleData/RR_Data/',files(f).name));
    
    PLZC(data,m,lag)
end