% Example of application of fSampEn: 
close all
clear
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
    
   
    
    subplot(2,1,1)
    plot([x+noise],'color','blue')
    legend(['original signal' ])
    subplot(2,1,2)
    plot(y,'color','green')    
    legend(['fSampEn'])
    
  
    