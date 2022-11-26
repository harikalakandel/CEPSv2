myFiles = dir('../../../Data/SampleData/RR_Data/*.txt');

results=[];
for i=1:size(myFiles,1)

    data = load(strcat('../../../Data/SampleData/RR_Data/',myFiles(i).name))


    [PhEn] = getMS_PhEntropy_CGData(data,3,2);

    PhEn1=1;

    %[PhEn1] = getPhEntropyV1_Corrected(data,5)

    results=[results;PhEn PhEn1]

end