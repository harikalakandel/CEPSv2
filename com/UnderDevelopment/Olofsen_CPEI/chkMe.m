

%[epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI_Ex(data,0.2,3);
%% add option to give 1% of intra Quartal range
dataFiles = dir('RR_Data/*.txt');
results=[];
for i=1:size(dataFiles,1)
    data = load(strcat('RR_Data/',dataFiles(i).name));
    threshold = (quantile(data,0.75)-quantile(data,0.25))*0.01
    [epei_,pe1_,pe2_,p1tie_,p2tie_,pk12_] = CPEI(data,threshold);
    
    
    results=[results;round(i) threshold epei,pe1,pe2,p1tie,p2tie,pk12];
end  
disp('   RRfileNo threshold    epe1      pe1       pe2      p1tie      p2tie        pk12')
disp(results)
  
