files = dir('../../../Data/SampleData/RR_Data/*.txt')

results=[];
for i=1:size(files,1)
    data = load(strcat('../../../Data/SampleData/RR_Data/',files(i).name));
    fd = AmplitudeFD(data);
    fd1 = DistanceFD(data);
    fd4 = SignFD(data);
    order = 18;
    fd3 = PintersectFD(data);
    fd2 =  LintersectFD(data);
    results=[results;fd fd1 fd2 fd3 fd4];
end

results