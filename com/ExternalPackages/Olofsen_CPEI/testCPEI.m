files = dir('../../../Data/SampleData/RR_Data/*.txt');

epz = 0.01;
allResults=[];
allResultsWithRange=[];

for i=1:size(files,1)
    currData = load(strcat('../../../Data/SampleData/RR_Data/',files(i).name));

  
    [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz);

    allResults=[allResults;[i epz epei,pe1,pe2,p1tie,p2tie,pk12]];

    q = quantile(currData,[.25 .50 .75]);

    epz_v=(q(3)-q(1))*epz;

   % epz_v = (q3-q1)*epz;
   [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz_v);

   allResultsWithRange=[allResultsWithRange;[i epz_v epei,pe1,pe2,p1tie,p2tie,pk12]];

end

allResults
allResultsWithRange





epz = 0.1
allResults=[];
allResultsWithRange=[];

for i=1:size(files,1)
    currData = load(strcat('../../../Data/SampleData/RR_Data/',files(i).name));

  
    [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz);

    allResults=[allResults;[i epz epei,pe1,pe2,p1tie,p2tie,pk12]];

    q = quantile(currData,[.25 .50 .75]);

    epz_v=(q(3)-q(1))*epz;

   % epz_v = (q3-q1)*epz;
   [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz_v);

   allResultsWithRange=[allResultsWithRange;[i epz_v epei,pe1,pe2,p1tie,p2tie,pk12]];

end

allResults
allResultsWithRange






epz = 1;
allResults=[];
allResultsWithRange=[];

for i=1:size(files,1)
    currData = load(strcat('../../../Data/SampleData/RR_Data/',files(i).name));

  
    [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz);

    allResults=[allResults;[i epz epei,pe1,pe2,p1tie,p2tie,pk12]];

    q = quantile(currData,[.25 .50 .75]);

    epz_v=(q(3)-q(1))*epz;

   % epz_v = (q3-q1)*epz;
   [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(currData,epz_v);

   allResultsWithRange=[allResultsWithRange;[i epz_v epei,pe1,pe2,p1tie,p2tie,pk12]];

end

allResults
allResultsWithRange



