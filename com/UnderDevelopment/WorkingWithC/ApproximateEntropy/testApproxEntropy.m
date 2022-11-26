files= dir('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\*.txt')



for fIndex=1:size(files,1)
    currData=load(strcat('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\',files(fIndex).name));
    getApproxEntropy(currData)
end