% EEG Shimmer

load('BA_a_25_1_TotAll_FIR');
EEG=table2array(TotAll);
[N,c]=size(EEG);
Shim=zeros(1,19);
ShdB=Shim;
apq3=Shim;
apq5=Shim;
%figure(1);
for i=1:19
    %subplot(19,1,i);plot(EEG(:,i));
    [Shim(i),ShdB(i),apq3(7),apq5(i)]=Shimmer(double(EEG(:,i)));
end

figure(2);
subplot 411;plot(Shim);title('Shim');xlabel('Electrode')
subplot 412;plot(ShdB);title('ShdB');xlabel('Electrode')
subplot 413;plot(apq3);title('apq3');xlabel('Electrode')
subplot 414;plot(apq5);title('apq5');xlabel('Electrode')