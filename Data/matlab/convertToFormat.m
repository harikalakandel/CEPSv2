clear
files=dir('*.mat');
for i=1:size(files,1)
    currFile=load(files(i).name);
    f1=fieldnames(currFile);
    f1=f1{1};
    data = eval(strcat('currFile.',f1));
    disp(files(i).name)
    try
        data = data{:,:};
    catch
        %% do nothing
    end
    save(strcat('Results\',files(i).name),'data');
end