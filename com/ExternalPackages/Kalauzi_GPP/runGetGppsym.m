clear
fig2=figure()


%ax0=fig2.CurrentAxes;

ax1=subplot(221,'Parent',fig2)
ax2=subplot(222,'Parent',fig2)

ax3=subplot(223,'Parent',fig2)
ax4=subplot(224,'Parent',fig2)





fig2={ax1,ax2,ax3,ax4};

fnam='RBA_B001_07_Nex_ECG_Kub_IBI_3';


dsrpo=load('RBA_B001_07_Nex_ECG_Kub_IBI_3.txt')
pauseGraph=false;
maxOrder=100;
[sd1,sd2,c1,c2,pCol,rCol]=getGPPsym(fnam,dsrpo,maxOrder,fig2)

t=[sd1',sd2',c1',c2',pCol,rCol];
%t=mat2cell(t,size(t,1),size(t,2));
var = {'sd1','sd2','c1','c2','pCol','rCol'}
fig = uifigure
uit = uitable(fig,'data',t)
set(uit,'ColumnName',var)
