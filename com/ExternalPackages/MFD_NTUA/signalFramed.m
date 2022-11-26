function [sigFramed,sigWindowed] = signalFramed(x,fs,windowLength, windowShift, windowed)
% [sigFramed,sigWindowed] = signalFramed(x,fs,windowLength, windowShift, windowed) 
% buffers and windows the signal 
%
% Author: N. Zlatintsi, 2012
% Adapted for the CEPS package April. 2022


Wav_Samples = length(x);

%% Window the signal
sigFramed=[]; sigWindowed=[];

sigFramed = buffer(x,round(windowLength*fs),round((windowShift)*fs), 'nodelay');
nFrames = ceil((Wav_Samples-round(windowLength*fs))/round((windowLength-windowShift)*fs));
sigFramed = sigFramed(:,1:nFrames);
if windowed == 1
    sigWindowed = diag(sparse(hamming(round(windowLength*10^-3*fs))))*sigFramed;
%     sigWindowed = sigWindowed(:,1:nFrames);
else
    sigWindowed = 0;
end
