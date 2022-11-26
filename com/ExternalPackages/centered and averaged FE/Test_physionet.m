clear;clc;close all
load sampentest
z=(z-mean(z))/std(z);
m=2;r=0.2;
[e,~,~]=sampenc(z,m,r)
[FuzSampEn]=FuzzySampEnt_TRIG(z,'T',m,r,1000,0)

%2.19, 2.20