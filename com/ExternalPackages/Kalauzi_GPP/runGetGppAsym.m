clear
close all
fig2=figure()


%ax0=fig2.CurrentAxes;

ax1=subplot(221,'Parent',fig2)
ax2=subplot(222,'Parent',fig2)

ax3=subplot(223,'Parent',fig2)
ax4=subplot(224,'Parent',fig2)





fig2={ax1,ax2,ax3,ax4};

fnam='ECG_BC_c_25_8_hrv';


dsrpo=load('ECG_BC_c_25_8_hrv.txt')



maximalOrder=50;
step=5;
minOrder=2;





[rcoef,maxmatss,pCol,rCol]=getGppAsym(fnam,dsrpo,minOrder, step, maximalOrder,fig2)



