dFiles = dir('../../..//Data/SampleData/RR_Data/*.txt')
m=3
lag = 2
PJSC=[];
PE=[];
RPE=[];
q=2;

%RPE=Renyi_perm_entropy(ts,wl,lag,q)


for f=1:size(dFiles,1)
  
        for lag = 2:2
            data = load(strcat('../../..//Data/SampleData/RR_Data/',dFiles(f).name));
            PJSC=[PJSC;JS_complexity(data,m,lag)];
            PE = [PE;perm_entropy(data,m,lag)];
            RPE=[RPE;Renyi_perm_entropy(data,m,lag,q)];
        end
  
end

%[PE, ind]=sort(PE);
%PJSC = PJSC(ind)

%plot(PJSC,PE)
[PJSC PE RPE]
