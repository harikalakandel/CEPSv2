files=dir('../Data/ECG_Data/*.mat')

for fIndex=1:size(files,1)
   
   load(strcat('../Data/ECG_Data/',files(fIndex).name));
   fName = strsplit(files(fIndex).name,'.');
   data = eval(fName{1});
   %,files(fIndex).name)
   save(strcat('../Data/ECG_DataOK/chkMe.mat'),'data');
end