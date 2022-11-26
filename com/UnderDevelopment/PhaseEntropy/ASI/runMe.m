clear;
clc;
close all
files = dir('RR_Data\*.txt');
results=nan(size(files,1),1);
%FuzSampEn_CA=zeros(size(files,1),2);
for fIndex=1:size(files,1)
    z = load(strcat('RR_Data\',files(fIndex).name));
    results(fIndex,1)=asi(z);
end
results