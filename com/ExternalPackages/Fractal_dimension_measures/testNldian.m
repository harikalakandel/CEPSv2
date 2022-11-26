data = load('ECG_BC_c_25_8_hrv.txt');
wlen=3;
wstep = 2;
%[fdiml,fdimp,hd] = getNldian(data,'ECG_BC_c_25_8_hrv.txt',wlen,wstep)

fig1 = figure(1)

ax1=subplot(221,'Parent',fig1)
ax2=subplot(222,'Parent',fig1)

ax3=subplot(223,'Parent',fig1)
ax4=subplot(224,'Parent',fig1)

title('Nldian')

[meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldian(data,3,2,{ax1,ax2,ax3,ax4})


%[meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldian(data,3,2,{ax1,ax2,ax3,ax4})

