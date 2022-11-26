function example_upemd()
% Example  UPEMD  (Uniform Phase EMD): date 2021-1120
% input parameters:
numSift = 10; %default 10, for duffing numSift=2000
numPhase = 16; % only for speedMode=2; otherwise this parameter is useless
numImf = 9;

i_example = 6;
if (i_example==1) % two-tone signal with intermittency
   ampSin = 0.2; % amplitude of the assisted sinusoids
elseif (i_example==6) % brain blood flow velocity
     ampSin = 10; % amplitude of the assisted sinusoids  
else 
    fprintf('Wrong Input !!\n');
   assert(1==0); 
end

[fs,x] = input_signal(i_example);

mfvtr = fs*[1/2 1/4 1/8 1/16 1/32 1/64 1/128 1/256];

typeSpline = 2;
toModifyBC = 1;

% (sig, numSift, maxPhase0, ampSin0, fs0, mfvtr, typeSpline, toModifyBC)
[imf1, fs1, mfvtr1] = upemd(x,numSift,numPhase,ampSin); 
plot_figure_list(11,'upemd',imf1(:,:)); 

[imf2, fs2, mfvtr2] = upemd(x,10,16,ampSin);
plot_figure_list(12,'upemd',imf2(:,:));

[imf3, fs3, mfvtr3] = upemd(x,numSift,numPhase,ampSin,fs,mfvtr,typeSpline,toModifyBC); 
plot_figure_list(13,'upemd',imf3(:,:));

[imf4, fs4, mfvtr4] = upemd(x,numSift,numPhase,ampSin,fs,mfvtr,2,1); 
plot_figure_list(14,'upemd',imf4(:,:));   

if (1) % Run EMD 
tic;
[imf5] = emd_ncu(x, 1, 2, numImf, numSift); imf5 = imf5'; 
toc;

plot_figure_list(15,'EMD',imf5(:,:));   
end % 1
    
return; % example_upemd 
   

function [fs,x] = input_signal(i_example) 
if (i_example==1) % two-tone signal with intermittency
  fs = 1;
  t=0:960-1;
  ndata = size(t,2);
  xlow = 1*cos(2*pi/240*t+1);
  xhigh = zeros(1,ndata);
  
  wiggle = 0.1*sin(2*pi*t(1:80)/8);
  n1= 400; n2=  479;
  xhigh(n1:n2)=wiggle;
  x = xlow + xhigh;      

elseif (i_example==6) % brain blood flow velocity
 fs = 50;
 load -ascii S0305SB_base.BFVL.txt;
 x = S0305SB_base_BFVL; x=x';
 [1];
else
   fprintf('Wrong Input !!\n');
   assert(1==0); 
end
return; % input_signal

function [] = plot_figure_list(fig_num, figTitle, y)
        
numimf = size(y,1);
t1=1;
t2=size(y,2);

sumdy(1) = 0;
for (i=1:numimf-1)
    dy(i) = min(y(i,t1:t2))-max(y(i+1,t1:t2));
    sumdy(i+1) = sumdy(i) + 1.2*dy(i);
end

figure(fig_num);clf; hold on;
for (i=1:numimf)
  plot(y(i,t1:t2)+sumdy(i)-0.1*(i-1),'r','LineWidth',2.0);   
end
title(figTitle);
[1];
return;

    
