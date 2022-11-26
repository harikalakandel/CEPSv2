cd('../../../ExternalPackages/noiseGenerator')
dataBlueNoise=nan(50000,9);
dataPinkNoise=nan(50000,9);
dataRedNoise=nan(50000,9);
dataVioletNoise=nan(50000,9);




sLength=[100,200,500,1000,2000,5000,10000,20000,50000];
for i=1:size(sLength,2)
    N=sLength(1,i);
    dataBlueNoise(1:N,i)=bluenoise(N)';
    dataPinkNoise(1:N,i)=pinknoise(N)';
    dataRedNoise(1:N,i)=rednoise(N)';
    dataVioletNoise(1:N,i)=violetnoise(N)';
end
cd('../../algorithms/PhaseEntropy/workWithNoise')

fid=fopen('DataBlueNoise.txt','w');
for i=1:N
    fprintf(fid, '%f ',dataBlueNoise(i,:));
    fprintf(fid, '\n ');
end
fclose(fid);

fid=fopen('DataRedNoise.txt','w');
for i=1:N
    fprintf(fid, '%f ',dataRedNoise(i,:));
    fprintf(fid, '\n ');
end
fclose(fid);


fid=fopen('DataPinkNoise.txt','w');
for i=1:N
    fprintf(fid, '%f ',dataPinkNoise(i,:));
    fprintf(fid, '\n ');
end
fclose(fid);


fid=fopen('DataVioletNoise.txt','w');
for i=1:N
    fprintf(fid, '%f ',dataVioletNoise(i,:));
    fprintf(fid, '\n ');
end
fclose(fid);