function [denlength] = getNLengthDensity(data,wlen,wstep)



[nsamp,nchan]=size(data);

%transpose a horizontal vector into vertical
 if nchan>1
 data=data';
 [nsamp,nchan]=size(data);
 end

%amplitude normalization for the whole signal
datamean=data-mean(data);
datanorm=datamean/mean(abs(datamean));

%wlen=input('moving window length (in samples):');
%wstep=input('moving window step (in samples):');

%number of windows
nw=floor((nsamp-wlen)/wstep)+1;

 for jw=1:nw
     low=(jw-1)*wstep+1;
     high=(jw-1)*wstep+wlen;
     
     %data selection for each window
     ds=datanorm(low:high,:);
     
     %length of normalized signal for each window
     leng(jw)=sum(abs(diff(ds)));
 end
 
%normalized length density
denlength=leng/wlen;




end

