clear
hrvRecords=readtable('../../Covid19_HRV/datasets/hrv_measurements.csv','HeaderLines',1);
resultPath='../Data/Covid19hrvRR';

USER_CODE_INDEX=1;
RR_INDEX= 22;

for rowNum=1:size(hrvRecords,1)
    fileName=strcat(resultPath,'/',char(hrvRecords{rowNum,1}),'_',num2str(rowNum),'.txt');
    tmpDataToWrite=char(hrvRecords{rowNum,RR_INDEX});
    dataToWrite=str2double(strsplit(tmpDataToWrite,','))';
    fid=fopen(fileName,'w');
    FormatSpec='%0.3f\r\n';
    fprintf(fid,FormatSpec, dataToWrite');
    fclose(fid);
end
