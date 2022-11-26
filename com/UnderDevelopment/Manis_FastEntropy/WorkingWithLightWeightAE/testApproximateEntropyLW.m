files=dir('RR_Data/*.txt')
ans=[];
m=2;

for i=1:size(files,1)
     
      data = load(strcat('RR_Data/',files(i).name));
      r = 2*std(data);
      ans= [ans;SampEn(data,m,r) Approximate_entropy_lightweight(data,size(data,1),m,r)];
end

ans