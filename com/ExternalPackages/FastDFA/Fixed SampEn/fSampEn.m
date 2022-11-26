function [y,y_ARV,y_RMS,xindices]=fSampEn(x,Nwindow,Nstep,m,r,STD)

% FSAMPEN Fixed Sample Entropy estimation.
%
%   Description of this method can be found in references [1] and [2].
%   
%   This rutine is provided as is with no warranty and can be used freely 
%   only for research purposes and only if you cite references [1] and [2].
%
%   Y = FSAMPEN(X) returns the Fixed Sample Entropy (fSampEn) estimate [1],
%   [2], Y, of a discrete-time signal vector X using the Sample Entropy 
%   algorithm [3]. By default, the SampEn is computed using a moving window
%   of 1000 samples, with a time-step of 100 samples (90 % of overlap
%   between consecutive windows), m=1, r=0.3*STD and STD is the standard
%   deviation of the whole signal.
%
%   If the signal length is less than 1000 samples, then the SampEn of the
%   entire signal is calculated
%
%   Y = FSAMPEN(X,NWINDOW) uses a moving window of NWINDOW samples.
%   Y = FSAMPEN(X,Nwindow,NSTEP) uses a time-step of NSTEP samples.
%   Y = FSAMPEN(X,Nwindow,NSTEP,M) specifies the parameter M in the
%   computation of the SampEn in each window
%   Y = FSAMPEN(X,Nwindow,NSTEP,M,R) specifies the fixed tolerance value
%   used to compute the SampEn in each window.
%   If R is a negative value, then the absolute value of R
%   is used as a factor of the standard deviation of the entire signal 
%   for calculating the fixed tolerance value: abs(R)*std(X)
%   Y = FSAMPEN(X,Nwindow,NSTEP,M,R,STD) specifies the global standard
%   deviation. If R is negative value between -1 and 0, then it is used this
%   STD value instead of the standard deviation of the entire signal 
%   for calculating the fixed tolerance value: abs(R)*STD
%
%
%   EXAMPLE:
% 
%     % Example of application of fSampEn: 
%     Fs = 1000;   t = 0:1/Fs:20;
%     x = cos(2*pi*t*(1/5));
%     x=(x+abs(x))/2;
%     x=x.*randn(size(t));
%     x=x+randn(size(t))*0.1;
%       
% 
%     ttemplate=linspace(-8,8,400);
%     template=exp(-(ttemplate.^2)/2).*cos(ttemplate);
%     template=diff(template);
%     noise=zeros(size(t));
%     Fnoise=1.2;
%     train=round(1/Fnoise*Fs/2):round(1/Fnoise*Fs):10*Fs-round(1/Fnoise*Fs/2);
%     noise(train)=ones(size(train));
%     noise=xcov(template,noise);
%     noise=noise(round(length(template)/2)+(1:length(t)));
%     noise=noise*400;
% 
%       
%     [y,y_ARV,y_RMS]=fSampEn(x+noise);
% 
%     figure
%     SCSZ=get(0,'ScreenSize');
%     set(gcf,'Position',[0.1*SCSZ(3) 0.1*SCSZ(4) 0.8*SCSZ(3) 0.7*SCSZ(4)])
%     subplot(2,1,1)
%     plot(t,x+noise)
%     title('Random signal of varying amplitude (frequency 0.2 Hz) with impulsive noise (frequency 1.2 Hz)')
%     xlabel('t(s)')
%     subplot(2,1,2)
%     plot(t,y,t,y_ARV,t,y_RMS)
%     legend('fSampEn','ARV','RMS','Location','NorthWest')
%     xlabel('t(s)')
%       
%  
%   Authors: Luis Estrada, Abel Torres, Leonardo Sarlabous, Raimon Jané
%   Date: 05/15/2014  
%
%  
%   References:
%
%     [1] L. Estrada, A. Torres, L. Sarlabous, and R. Jané, "Improvement in
%         neural respiratory drive estimation from diaphragm
%         electromyographic signals using fixed sample entropy," 
%         IEEE J. Biomed. Heal. Informatics, vol. 20, no. 2, pp. 476–485, 
%         Mar. 2016.
%     [2] L. Sarlabous,A. Torres, J. A. Fiz, andR. Jané, "Evidence towards 
%         improved estimation of respiratory muscle effort from diaphragm 
%         mechanomyographic signals with cardiac vibration interference 
%         using sample entropy with fixed tolerance values," PLoS One, 
%         vol. 9, no. 2, pp. 1–9, Jan. 2014.
%     [3] J. S. Richman and J. R. Moorman, "Physiological time-series 
%         analysis using approximate entropy and sample entropy," 
%         Am. J. Physiol. Hear. Circ. Physiol., vol. 278, no. 6, 
%         pp. H2039–H2049, Jun. 2000.


if nargin<1,
    
    % Example of application of fSampEn: 
    Fs = 1000;   t = 0:1/Fs:20;
    x = cos(2*pi*t*(1/5));
    x=(x+abs(x))/2;
    x=x.*randn(size(t));
    x=x+randn(size(t))*0.1;
      

    ttemplate=linspace(-8,8,400);
    template=exp(-(ttemplate.^2)/2).*cos(ttemplate);
    template=diff(template);
    noise=zeros(size(t));
    Fnoise=1.2;
    train=round(1/Fnoise*Fs/2):round(1/Fnoise*Fs):10*Fs-round(1/Fnoise*Fs/2);
    noise(train)=ones(size(train));
    noise=xcov(template,noise);
    noise=noise(round(length(template)/2)+(1:length(t)));
    noise=noise*400;

      
    [y,y_ARV,y_RMS]=fSampEn(x+noise);

    figure
    SCSZ=get(0,'ScreenSize');
    set(gcf,'Position',[0.1*SCSZ(3) 0.1*SCSZ(4) 0.8*SCSZ(3) 0.7*SCSZ(4)])
    subplot(2,1,1)
    plot(t,x+noise)
    title('Random signal of varying amplitude (frequency 0.2 Hz) with impulsive noise (frequency 1.2 Hz)')
    xlabel('t(s)')
    subplot(2,1,2)
    plot(t,y,t,y_ARV,t,y_RMS)
    legend('fSampEn','ARV','RMS','Location','NorthWest')
    xlabel('t(s)')
    
    return
end
if nargin<2,Nwindow=min([1000 length(x)]);end
if nargin<3,Nstep=round(Nwindow*0.1);end
if nargin<4,m=1;end
if nargin<5,r=-0.3;end
if nargin<6,STD=std(x);end
if r<0,r=abs(r)*STD;end


    
N = length(x); 
y = zeros(N,1);
Nwindow = floor(Nwindow/2); % se puede mejorar calculando si es par o impar la ventana 
steps = Nwindow+1:Nstep:N-Nwindow; 
totalsteps = length(steps);  

tstart=tic;
for k = 1:totalsteps,
    indices = (steps(k) - Nwindow):(steps(k) + Nwindow);
    y(steps(k),1)=SampEn(x(indices),m,r);
    y_ARV(steps(k),1)=mean(abs(x(indices)));
    y_RMS(steps(k),1)=sqrt(mean(x(indices).^2));
    if k==10,
        telapsed=toc(tstart);
        disp(['Estimated time: ' num2str(telapsed/10*(totalsteps)) ' s'])
    end
  
end

telapsed=toc(tstart);
disp(['Elapsed time: ' num2str(telapsed) ' s'])


if steps(1) > 1,
    y(1:steps(1)-1,1) = y(steps(1),1)*ones(steps(1)-1,1);
    y_ARV(1:steps(1)-1,1) = y_ARV(steps(1),1)*ones(steps(1)-1,1);
    y_RMS(1:steps(1)-1,1) = y_RMS(steps(1),1)*ones(steps(1)-1,1);
    
end
if steps(totalsteps) < N,
    y((steps(totalsteps)+1):N,1) = y(steps(totalsteps),1)...
                                       *ones(N-steps(totalsteps),1);
    y_ARV((steps(totalsteps)+1):N,1) = y_ARV(steps(totalsteps),1)...
                                       *ones(N-steps(totalsteps),1);
    y_RMS((steps(totalsteps)+1):N,1) = y_RMS(steps(totalsteps),1)...
                                       *ones(N-steps(totalsteps),1);   
end

xindices = steps;


for  k = 1:totalsteps-1,
    vectx = (steps(k) + 1:steps(k+1) - 1);
    pend = (y(steps(k+1)) - y(steps(k)))/Nstep;
    y(vectx) = pend * (vectx - steps(k)) + y(steps(k));
    pend = (y_ARV(steps(k+1)) - y_ARV(steps(k)))/Nstep;
    y_ARV(vectx) = pend * (vectx - steps(k)) + y_ARV(steps(k));
    pend = (y_RMS(steps(k+1)) - y_RMS(steps(k)))/Nstep;
    y_RMS(vectx) = pend * (vectx - steps(k)) + y_RMS(steps(k));
end



function  yw = SampEn(xw,m,r)

N=length(xw);
Nm=N-m;
xw=xw(:);

% 1. Subsequences for m+1
Xm1=zeros(Nm,m+1);
for i=0:m,
    Xm1(:,i+1)=xw((1:Nm)+i);
end
% Subsequences for m
Xm=Xm1(:,1:m);
    
for i=1:Nm,
    % 2. Distances between Xm1(i) and Xm(i) and the rest of subsequences:
    Xm1_i=ones(Nm-1,m+1);
    for k=1:m+1,
        Xm1_i(:,k)=Xm1_i(:,k).*Xm1(i,k);
    end
    Xm_i=Xm1_i(:,1:m);    
    index=[1:i-1 i+1:Nm];
    dm=max(abs(Xm_i-Xm(index,:)),[],2);
    dm1=abs(Xm1_i(:,m+1)-Xm1(index,m+1));

    % 3/5. Frequency of similar patterns (with  dm<=r):
    dmtol=(dm<=r);
    B(i)=sum(dmtol)/(Nm-1);
    
    % 4/5. Frequency of similar patterns (with dm1<=r):
    dm1tol=((dm1<=r) & dmtol);
    A(i)=sum(dm1tol)/(Nm-1);  
end

% 6. Average for Bm and Am:
Bm=mean(B);
Am=mean(A);
% 7. Sample entropy (SampEn)
yw=-log(Am/Bm);
   