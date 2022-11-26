files=dir('RR_Data\*.txt')
color={'red','blue','green','black'}
m=2;
ans1=[];
for i=1:size(files,1)
      data = load(strcat('..\..\..\..\..\Data\SampleData\RR_Data\',files(i).name));
      tmpSamp= sampEnProfiling(data,m);
      
      
     % plot(ans(:,2),'color',color{i})
     % hold on
     tmpSamp1=tmpSamp;
     tmpSamp1=tmpSamp1(~isinf(tmpSamp1(:,2)),:);
     ans1=[ans1;[ SampEn(data(2:end-1,1),m,2*std(data)) ] nanmean(tmpSamp1(:,2))  nanmax(tmpSamp1(:,2)) nanmin(tmpSamp1(:,2)) nanstd(tmpSamp1(:,2)) sum(isinf(tmpSamp(:,2)))];
     
end

ans1
h=bar(ans1(:,1:2))
set(h, {'DisplayName'}, {'Datashare','Profiling'})
legend() 


%%% single file
plot(data(:,1))
plot(tmpSamp(:,2))
legend('Data','Entropy Profiling')