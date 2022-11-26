function [meanFDiml,stdFDiml,meanFImp,stdFImp]  = getNldwan(data,wlen,wstep,ax1)



%nldwan.m - program for calculating fractal dimension of time series
%normalized length density method;
%both logarithmic and power models
%moving window version
%normalization of amplitudes for every window

% clear
% fn=input('filename of data series: ','s');
% eval(['load ' fn])
%
% eval(['data=' fn ';'])
[nsamp,nchan]=size(data);

%transpose a horizontal vector into vertical
if nchan>1
    data=data';
    [nsamp,nchan]=size(data);
end

% wlen=input('moving window length (in samples):');
% wstep=input('moving window step (in samples):');

%number of windows
nw=floor((nsamp-wlen)/wstep)+1;

for jw=1:nw
    low=(jw-1)*wstep+1;
    high=(jw-1)*wstep+wlen;

    %data selection for each window
    ds=data(low:high,:);

    %amplitude normalization for each window
    dsmean=ds-mean(ds);
    dsnorm=dsmean/mean(abs(dsmean));

    %length of normalized signal for each window
    leng(jw)=sum(abs(diff(dsnorm)));
end

%normalized length density
denlength=leng/wlen;

%model parameters

%logarithmic
al=0.332035737452486;
t0l=0.054745045770163;
c=1.889449949907297;

%power
ad=1.907884891575251;
t0d=0.097178405177457;
kex=0.183833424812589;

%calculation of FD values for both models
for j=1:length(denlength)
    fdiml(j)=al*log(abs(denlength(j)-t0l))+c;
    fdimp(j)=ad*(abs(denlength(j)-t0d))^kex;
end

%presentation of results
%figure
if ~ isempty(ax1)
    plot(ax1{1},fdiml)
    %xlabel('window number')
    %ylabel('FD log model')
    %title(['data file: ' fn])

    set( get(ax1{1},'XLabel'), 'String', 'window number' );
    set( get(ax1{1},'YLabel'), 'String', 'FD log model' );


    plot(ax1{2},fdimp)
    
    %xlabel('window number')
    ylabel('FD pow model')

    set( get(ax1{2},'XLabel'), 'String', 'window number' );
    set( get(ax1{2},'YLabel'), 'String', 'FD pow model' );



    %figure
    %subplot(121),
    hist(ax1{3},fdiml,20)
    %xlabel('FD log model')
    set( get(ax1{3},'XLabel'), 'String', 'FD log model' );
    %title(['data file: ' fn])
    %disp(['log model:   mean: ' num2str(mean(fdiml)) '; std: ' num2str(std(fdiml))])

    %subplot(122),
    hist(ax1{4},fdimp,20)
    %xlabel('FD pow model')
    %disp(['pow model:   mean: ' num2str(mean(fdimp)) '; std: ' num2str(std(fdimp))])
    set( get(ax1{4},'XLabel'), 'String', 'FD pow model' );
    %pause
    %optional saving of results
    % ksave=input('save the FD data (y/n):','s');
    % if ksave=='y'
    %     dso=input('enter FD data filename:','s');
    %     eval(['save ' dso ' fdiml fdimp'])
    %     disp(['file saved: ' dso '.mat'])
    % end

end
meanFDiml = nanmean(fdiml);
stdFDiml = nanstd(fdiml);

meanFImp = nanmean(fdimp);
stdFImp = nanstd(fdimp);


end

