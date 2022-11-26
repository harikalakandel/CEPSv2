%% Inputs: 
% data: data to be analyzed. Example: data=wfbm(0.5,1000);
% type: kind of isometry ('T': Translation, 'R': vertical Reflexion:, 'I': Inversion, 'G': Glide reflexion. 
% m: size of the pattern (m-motif). m must be >1.
% r: amplitude of the tolerance.
% p: power of the membership function. p=2 for gaussian function, p>1000 for rectangular function (classical case).
% Centering: Centering=1 for centered patterns and Centering=0 for non centered pattern (classical case)
% Output: Fuzzy sample entropy and number of similar m-pattern for a certain type of symmetry.
% Example:
 data=wfbm(0.5,1000);type='T';m=2;r=std(data)/10;p=1000; Centering=0;
 [FSE_T,N_T]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering);
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 


clear;
clc;
close all
files = dir('RR_Data\*.txt');
FuzSampEn_CA=zeros(size(files,1),2);
for center=[0,1]
    FuzSampEn=nan(size(files,1),4);
    for fIndex=1:size(files,1)
        z = load(strcat('RR_Data\',files(fIndex).name));
        z=(z-mean(z))/std(z);
        m=2;
        r=std(z);
        [e,~,~]=sampenc(z,m,r);
        type={'T','R','I','G'};
        for typeID=1:size(type,2)
            typeChar = char(type{typeID});
            [FuzSampEn(fIndex,typeID)]=FuzzySampEnt_TRIG(z,typeChar,m,r,1000,center);
        end

    end
    %% apply 3... page 5 of 14
    FuzSampEn_CA(:,center+1)=mean(FuzSampEn,2);
end

FuzSampEn_CA

%2.19, 2.20