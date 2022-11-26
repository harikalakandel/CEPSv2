files = dir('Resamp_IBI_5-min_4Hz_Trim/*.txt')
Kmax= 20;
Lcol=[];
for i=1:size(files,1)
    
    tmpFileName=strsplit(files(i).name,'_Nex');
    tmpFileName = strsplit(tmpFileName{1},'resam_');
    
    fileNames{1,i}=tmpFileName{2};
    data = load(strcat('Resamp_IBI_5-min_4Hz_Trim/',files(i).name));
    [HFD,L] = Higuchi_FD(data, Kmax) ;
    Lcol = [Lcol; L];
end


myTable = array2table(Lcol','VariableNames', fileNames)


writetable(myTable,'L_Collection.csv') 