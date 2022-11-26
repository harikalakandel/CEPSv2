files = dir('../../../Data/SampleData/RR_Data/*.txt')
ans=[];
for f =1:size(files,1)
    disp(files(f).name)
    data = load(strcat('../../../Data/SampleData/RR_Data/',files(f).name));
    ans=[ans;pdf(data)];
end
ans