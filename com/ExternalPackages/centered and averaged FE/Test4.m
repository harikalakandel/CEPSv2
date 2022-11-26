% Script related to the following paper
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 
clear;clc;close all
m=3;

load dataOneOverFNoise;%data
[Nmax,~]=size(data);

for n=1:Nmax;n
    Data=data(n,:);Data=Data-mean(Data);Data=Data/std(Data);r=std(Data)/10;
    [SE_T(n),NSE_T(n)]=FuzzySampEnt_TRIG(Data,'T',m,r,1000,0);
    [SEc_T(n),NSEc_T(n)]=FuzzySampEnt_TRIG(Data,'T',m,r,1000,1);
    [SEf_T(n),NSEf_T(n)]=FuzzySampEnt_TRIG(Data,'T',m,r,2,0);
    [SEfc_T(n),NSEfc_T(n)]=FuzzySampEnt_TRIG(Data,'T',m,r,2,1);
    [SE_R(n),NSE_R(n)]=FuzzySampEnt_TRIG(Data,'R',m,r,1000,0);
    [SEc_R(n),NSEc_R(n)]=FuzzySampEnt_TRIG(Data,'R',m,r,1000,1);
    [SEf_R(n),NSEf_R(n)]=FuzzySampEnt_TRIG(Data,'R',m,r,2,0);
    [SEfc_R(n),NSEfc_R(n)]=FuzzySampEnt_TRIG(Data,'R',m,r,2,1);
    
    [SE_I(n),NSE_I(n)]=FuzzySampEnt_TRIG(Data,'I',m,r,1000,0);
    [SEc_I(n),NSEc_I(n)]=FuzzySampEnt_TRIG(Data,'I',m,r,1000,1);
    
    [SEf_I(n),NSEf_I(n)]=FuzzySampEnt_TRIG(Data,'I',m,r,2,0);
    [SEfc_I(n),NSEfc_I(n)]=FuzzySampEnt_TRIG(Data,'I',m,r,2,1);
    
    [SE_G(n),NSE_G(n)]=FuzzySampEnt_TRIG(Data,'G',m,r,1000,0);
    [SEc_G(n),NSEc_G(n)]=FuzzySampEnt_TRIG(Data,'G',m,r,1000,1);
    
    [SEf_G(n), NSEf_G(n)]=FuzzySampEnt_TRIG(Data,'G',m,r,2,0);
    [SEfc_G(n),NSEfc_G(n)]=FuzzySampEnt_TRIG(Data,'G',m,r,2,1); 
end
   
SEf_IndAvg=(SEf_T+SEf_R+SEf_I+SEf_G)/4;
SEfc_IndAvg=(SEfc_T+SEfc_R+SEfc_I+SEfc_G)/4;
SE_IndAvg=(SE_T+SE_R+SE_I+SE_G)/4;
SEc_IndAvg=(SEc_T+SEc_R+SEc_I+SEc_G)/4;

NSEf_IndAvg=(NSEf_T+NSEf_R+NSEf_I+NSEf_G)/4;
NSEfc_IndAvg=(NSEfc_T+NSEfc_R+NSEfc_I+NSEfc_G)/4;
NSE_IndAvg=(NSE_T+NSE_R+NSE_I+NSE_G)/4;
NSEc_IndAvg=(NSEc_T+NSEc_R+NSEc_I+NSEc_G)/4;



figure;boxplot([SE_T' SE_IndAvg' SEf_T' SEf_IndAvg'  SEc_T'  SEc_IndAvg' SEfc_T' SEfc_IndAvg' ]);ylim([0 4]);grid

figure;boxplot([NSE_T' NSE_IndAvg'  NSEf_T' NSEf_IndAvg' NSEc_T'  NSEc_IndAvg' NSEfc_T' NSEfc_IndAvg' ]);ylim([0 2*L]);grid




