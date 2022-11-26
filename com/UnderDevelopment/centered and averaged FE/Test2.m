% Script related to the following paper
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 
clear;clc;close all
m=6;
load dataOneOverFNoise_beta1p0; %Data 1/f^beta with beta=1;
%load sampentest;Data=z;
n=1;
Data=Data-mean(Data);Data=Data/std(Data);
r=std(Data)/10;
[SE_T(n),NSE_T(n)]=     FuzzySampEnt_TRIG(Data,'T',m,r,1000,0);
[SE_R(n),NSE_R(n)]=     FuzzySampEnt_TRIG(Data,'R',m,r,1000,0);
[SE_I(n),NSE_I(n)]=     FuzzySampEnt_TRIG(Data,'I',m,r,1000,0);
[SE_G(n),NSE_G(n)]=     FuzzySampEnt_TRIG(Data,'G',m,r,1000,0);
[SE_Tc(n),NSE_Tc(n)]=   FuzzySampEnt_TRIG(Data,'T',m,r,1000,1);
[SE_Rc(n),NSE_Rc(n)]=   FuzzySampEnt_TRIG(Data,'R',m,r,1000,1);
[SE_Ic(n),NSE_Ic(n)]=   FuzzySampEnt_TRIG(Data,'I',m,r,1000,1);
[SE_Gc(n),NSE_Gc(n)]=   FuzzySampEnt_TRIG(Data,'G',m,r,1000,1);
[SE_Tf(n),NSE_Tf(n)]=   FuzzySampEnt_TRIG(Data,'T',m,r,2,0);
[SE_Rf(n),NSE_Rf(n)]=   FuzzySampEnt_TRIG(Data,'R',m,r,2,0);
[SE_If(n),NSE_If(n)]=   FuzzySampEnt_TRIG(Data,'I',m,r,2,0);
[SE_Gf(n),NSE_Gf(n)]=   FuzzySampEnt_TRIG(Data,'G',m,r,2,0);
[SE_Tfc(n),NSE_Tfc(n)]= FuzzySampEnt_TRIG(Data,'T',m,r,2,1);
[SE_Rfc(n),NSE_Rfc(n)]= FuzzySampEnt_TRIG(Data,'R',m,r,2,1);
[SE_Ifc(n),NSE_Ifc(n)]= FuzzySampEnt_TRIG(Data,'I',m,r,2,1);
[SE_Gfc(n),NSE_Gfc(n)]= FuzzySampEnt_TRIG(Data,'G',m,r,2,1);

NSvect=ceil([NSE_T NSE_R NSE_I NSE_G]);
NSvectf=ceil([NSE_Tf NSE_Rf NSE_If NSE_Gf]);
NSvectc=ceil([NSE_Tc NSE_Rc NSE_Ic NSE_Gc]);
NSvectfc=ceil([NSE_Tfc NSE_Rfc NSE_Ifc NSE_Gfc]);

Svect=([SE_T SE_R SE_I SE_G]);
Svectf=([SE_Tf SE_Rf SE_If SE_Gf]);
Svectc=([SE_Tc SE_Rc SE_Ic SE_Gc]);
Svectfc=([SE_Tfc SE_Rfc SE_Ifc SE_Gfc]);

figure
subplot(211);plot(Data);xlabel('time');title('1/f^{\beta} time series with \beta=1')
subplot(223);
bar(1:4,NSvect,'c');hold on;bar(5:8,NSvectf,'g');bar(9:12,NSvectc,'m');bar(13:16,NSvectfc,'b');hold off
legend('normal','fuzzy','centered','fuzzy centered');
title('Number of TRIG similar 6-patterns');
xlabel('TRIG (normal, fuzzy, centered, fuzzy centered)')

subplot(224);
bar(1:4,Svect,'c');hold on;bar(5:8,Svectf,'g');bar(9:12,Svectc,'m');bar(13:16,Svectfc,'b');hold off
legend('normal','fuzzy','centered','fuzzy centered');
title('Fuzzy Sample entropy TRIG with 6-patterns');
xlabel('TRIG (normal, fuzzy, centered, fuzzy centered)')