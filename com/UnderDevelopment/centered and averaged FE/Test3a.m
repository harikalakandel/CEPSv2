% Script related to the following paper
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 
clear;clc;close all
m=5;
L=1000;
alpha=0.25;

t=0:1/(L-1):1;data=sawtooth(2*pi*8*t,alpha);r=std(data)/10;
[SE_T,NSE_T]=     FuzzySampEnt_TRIG(data,'T',m,r,1000,0);
[SE_R,NSE_R]=     FuzzySampEnt_TRIG(data,'R',m,r,1000,0);
[SE_I,NSE_I]=     FuzzySampEnt_TRIG(data,'I',m,r,1000,0);
[SE_G,NSE_G]=     FuzzySampEnt_TRIG(data,'G',m,r,1000,0);

[SE_Tc,NSE_Tc]=   FuzzySampEnt_TRIG(data,'T',m,r,1000,1);
[SE_Rc,NSE_Rc]=   FuzzySampEnt_TRIG(data,'R',m,r,1000,1);
[SE_Ic,NSE_Ic]=   FuzzySampEnt_TRIG(data,'I',m,r,1000,1);
[SE_GTc,NSE_Gc]=  FuzzySampEnt_TRIG(data,'G',m,r,1000,1);

[SE_Tf,NSE_Tf]=   FuzzySampEnt_TRIG(data,'T',m,r,2,0);
[SE_Rf,NSE_Rf]=   FuzzySampEnt_TRIG(data,'R',m,r,2,0);
[SE_If,NSE_If]=   FuzzySampEnt_TRIG(data,'I',m,r,2,0);
[SE_Gf,NSE_Gf]=   FuzzySampEnt_TRIG(data,'G',m,r,2,0);

[SE_Tfc,NSE_Tfc]= FuzzySampEnt_TRIG(data,'T',m,r,2,1);
[SE_Rfc,NSE_Rfc]= FuzzySampEnt_TRIG(data,'R',m,r,2,1);
[SE_Ifc,NSE_Ifc]= FuzzySampEnt_TRIG(data,'I',m,r,2,1);
[SE_GTfc,NSE_Gfc]=FuzzySampEnt_TRIG(data,'G',m,r,2,1);

NSvect=ceil([NSE_T NSE_R NSE_I NSE_G]);
NSvectf=ceil([NSE_Tf NSE_Rf NSE_If NSE_Gf]);
NSvectc=ceil([NSE_Tc NSE_Rc NSE_Ic NSE_Gc]);
NSvectfc=ceil([NSE_Tfc NSE_Rfc NSE_Ifc NSE_Gfc]);



subplot(221);plot(data);xlabel('time');title('sawtooth time series with \alpha=0.25')
subplot(222);
bar(1:4,NSvect,'c');hold on;bar(5:8,NSvectf,'g');bar(9:12,NSvectc,'m');bar(13:16,NSvectfc,'b');hold off

legend('normal','fuzzy','centered','fuzzy centered');
title('Number of TRIG similar 5-patterns');
xlabel('TRIG (normal, fuzzy, centered, fuzzy centered)')

clear;clc;%close all
m=5;
L=1000;
alpha=0.5;

t=0:1/(L-1):1;data=sawtooth(2*pi*8*t,alpha);r=std(data)/10;
[SE_T,NSE_T]=     FuzzySampEnt_TRIG(data,'T',m,r,1000,0);
[SE_R,NSE_R]=     FuzzySampEnt_TRIG(data,'R',m,r,1000,0);
[SE_I,NSE_I]=     FuzzySampEnt_TRIG(data,'I',m,r,1000,0);
[SE_G,NSE_G]=     FuzzySampEnt_TRIG(data,'G',m,r,1000,0);

[SE_Tc,NSE_Tc]=   FuzzySampEnt_TRIG(data,'T',m,r,1000,1);
[SE_Rc,NSE_Rc]=   FuzzySampEnt_TRIG(data,'R',m,r,1000,1);
[SE_Ic,NSE_Ic]=   FuzzySampEnt_TRIG(data,'I',m,r,1000,1);
[SE_GTc,NSE_Gc]=  FuzzySampEnt_TRIG(data,'G',m,r,1000,1);

[SE_Tf,NSE_Tf]=   FuzzySampEnt_TRIG(data,'T',m,r,2,0);
[SE_Rf,NSE_Rf]=   FuzzySampEnt_TRIG(data,'R',m,r,2,0);
[SE_If,NSE_If]=   FuzzySampEnt_TRIG(data,'I',m,r,2,0);
[SE_Gf,NSE_Gf]=   FuzzySampEnt_TRIG(data,'G',m,r,2,0);

[SE_Tfc,NSE_Tfc]= FuzzySampEnt_TRIG(data,'T',m,r,2,1);
[SE_Rfc,NSE_Rfc]= FuzzySampEnt_TRIG(data,'R',m,r,2,1);
[SE_Ifc,NSE_Ifc]= FuzzySampEnt_TRIG(data,'I',m,r,2,1);
[SE_GTfc,NSE_Gfc]=FuzzySampEnt_TRIG(data,'G',m,r,2,1);

NSvect=ceil([NSE_T NSE_R NSE_I NSE_G]);
NSvectf=ceil([NSE_Tf NSE_Rf NSE_If NSE_Gf]);
NSvectc=ceil([NSE_Tc NSE_Rc NSE_Ic NSE_Gc]);
NSvectfc=ceil([NSE_Tfc NSE_Rfc NSE_Ifc NSE_Gfc]);


subplot(223);plot(data);xlabel('time');title('sawtooth time series with \alpha=0.5')
subplot(224);
bar(1:4,NSvect,'c');hold on;bar(5:8,NSvectf,'g');bar(9:12,NSvectc,'m');bar(13:16,NSvectfc,'b');hold off

legend('normal','fuzzy','centered','fuzzy centered');
title('Number of TRIG similar 5-patterns');
xlabel('TRIG (normal, fuzzy, centered, fuzzy centered)')


