
%% testing with RR files
files=dir('RR_Data\*.txt');
names={};
for i=1:size(files,1)
    data = load(strcat('RR_Data\',files(i).name));
    names{i,1}=files(i).name;
    results(i,1)=FD_C(data,n);
    results(i,2)=FD_M(data,n);    
    results(i,3)=FM_M(data,n);
end




