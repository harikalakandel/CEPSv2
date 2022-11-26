files=dir('RR_Data\*.txt');

L = 2;
num_int = 3;
results=nan(15,10);
names={};

    for i=1:size(files,1)
        names{i,1}=files(i).name;
        for L=1:10
        data=load(strcat('RR_Data\',files(i).name));
        [results(i,L),~] = ShannonEn_Giuseppe(data,L,num_int);
        end
    end
