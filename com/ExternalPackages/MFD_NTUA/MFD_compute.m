%% Start file for Multiscale Fractal Dimension Computation
%
% Read the signal 
% Preprocessing: Frame and/or window the signal
% MFD: Chose parameters for maxscale M and window W that are needed for the
% MFD computation
% Run frdimsigfmc1.m and compute MFD
%
% Plotting of errorbars: as examples are user
% 1. A music signal that can be found in the directory with the MFD code
% 2. A synthesized note implemented as sinusoids that are added
% 3. An EEG signal
%
% Author: N. Zlatintsi
% Adapted for the CEPS package April. 2022
%
% The MFD code parameters are adapted for each individual signal. 
% Regarding the music signals and the synthesized sinusoid "note"
% more details can be found: 
% A. Zlatintsi and P. Maragos, "Multiscale Fractal Analysis of Musical 
% Instrument Signals with Application to Recognition", IEEE Trans. on Audio,
% Speech and Language Processing, vol. 21, no. 4, pp.737-748, Apr. 2013.
% Link: http://cvsp.cs.ntua.gr/publications/jpubl+bchap/ZlatintsiMaragos_MultiscaleFractalAnalMusicInstrumSignalsApplicRecogn_ieeetASLP2013.pdf


clear all; close all;

% Plotting parameters 
fnts = 20; fntss = 16; 


%% ************************************************************************
% Example I: A music signal
% *************************************************************************
% 
% In this example a music file of ca. 2 seconds is used to compute the MFD, which
% is computed in 30 ms windows.
% [sigFramed,sigWindowed] = signalFramed(x,fs, windowLength, windowShift,
% 0) is a function used for windowing the signal. The last parameter of the
% function defines whether a Hamming window will be applied (set = 1) or not (set =
% 0)
% Errorbars are plotted for the whole music signal.

% read the music file
[x,fs] = audioread('BbClarinet.wav');

% Preprocessing of the audio file=> 
% Convert Stereo file to Mono, DC Removal, Normalization

x = mean(x,2);       % Stereo to Mono
xn = x - mean(x);    % DC Removal
x = xn/max(abs(xn)); % Signal normalization

t = [0:length(x)-1]/fs; % time vector

% Plot the signal
figure; 
plot(t,x);
title('A clarinet note','FontSize',fnts)
xlabel('Time (sec)','FontSize',fnts)
axis('tight')


% Buffer and/or Window (with Hamming) the signal
windowLength = 30/1000;       % window length in sec 
windowShift = windowLength/2; % window shift

[sigFramed,sigWindowed] = signalFramed(x,fs, windowLength, windowShift, 0);
clear sigWindowed;

% ------------------------------------
% Compute MultiScale Fractal Dimension
% using frdimsigfmc1.m
% ------------------------------------

% Define maxscale M and window W
% those parameters were chosen specifically for the music signals
M = ceil(floor(windowLength*fs)/10);
W = 10;

% Run the algorithm and compute for the whole signal the MFDs
d=[]; dim = [];
totalFrames = size(sigFramed,2);
for i = 1:totalFrames
    d=frdimsigfmc1(sigFramed(:,i),'maxscale',M,'window',W);
    dim=[dim d];
end

% Plotting errorbars, mapping time to scales
map=(1/M:M/(fs/1000)/(M-W+1):M/(fs/1000));

m = mean(dim,2); % mean 
st = std(dim,[],2); % standard deviation
    
figure; 
errorbar(map, m, st,'k');
axis([0 3 0.9 2]);
set(gca,'xTick',0:0.5:3,'yTick',1:0.1:2,'FontSize',fntss);
title('Multiscale Fractal Dimension Profile of a music signal')
xlabel('SCALE (millisec)','FontSize',fnts); 
ylabel('FRACTAL DIMENSION','FontSize',fnts);


%% ************************************************************************ 
% Example II: Overtones of the note C3
% *************************************************************************
%
% Create a musical note using sinusoidal signals of specific frequencies
% x1 is sine with frequency equal to C3 
% Afterwards, you add the overtones 
% Compute MFD on this synthesized signal 
% The plots produced here can be found as Fig. 13: Mean MFD and standard deviation 
% of sinusoidal signals while adding sinusoids of frequency equal to the
% harmonics of C3 (131 Hz) in
%
% A. Zlatintsi and P. Maragos, "Multiscale Fractal Analysis of Musical 
% Instrument Signals with Application to Recognition", 
% IEEE TASLP, vol. 21, no. 4, pp.737-748, Apr. 2013.


         
fs = 44100;   
% Define the sinusoids
T = 1/fs; 
phi = 2 * pi * 0.25;   
t = [0:T:1];  

f = [131 262 393 524 655 789 917 1046 1177 1308]; % frequencies for C3
x1 = cos(2*pi*f(1)*t + phi);   % C3 Harmonic 1 Fundamental  
x2 = cos(2*pi*f(2)*t + phi);   % C4 1 Octave higher
x3 = cos(2*pi*f(3)*t + phi);   % G4 A fifth above C4
x4 = cos(2*pi*f(4)*t + phi);   % C5 2 octaves above fund. and a fourth above G4
x5 = cos(2*pi*f(5)*t + phi);   % E5 A third above G4
x6 = cos(2*pi*f(6)*t + phi);   % G5 A fifth above C5, Harms. 4,5 & 6 form a mojor cord
x7 = cos(2*pi*f(7)*t + phi);   % almost B5b An overtone to avoid
x8 = cos(2*pi*f(8)*t + phi);   % almost B5b An overtone to avoid
x9 = cos(2*pi*f(9)*t + phi);   % almost B5b An overtone to avoid
x10 = cos(2*pi*f(10)*t + phi); % almost B5b An overtone to avoid

x = [x1; x1+x2; x1+x2+x3; x1+x2+x3+x4; x1+x2+x3+x4+x5; x1+x2+x3+x4+x5+x6;...
    x1+x2+x3+x4+x5+x6+x7; x1+x2+x3+x4+x5+x6+x7+x8; x1+x2+x3+x4+x5+x6+x7+x8+x9; ...
    x1+x2+x3+x4+x5+x6+x7+x8+x9+x10;];

figure;
plot(t(1,:),x(7,:));
title('A synthesized note','FontSize',fnts);
xlabel('Time (sec)','FontSize',fnts);
axis('tight');

% A for loop to plot all 10 sinusoidal signals to demostrate the
% differences of the MFD profiles when more sines are added
for i = 1 : size(x,1)
    
    sigFramed = []; sigWindowed = [];
    % Buffering 
    [sigFramed,~] = signalFramed(x(i,:), fs, windowLength, windowShift, 0);
    % Compute the  MultiScale Fractal Dimension
    % define the MFD parameters
    M = ceil(floor(windowLength*fs)/10);
    W=10;
    % map is needed for ploting the errorbars (map time to MFD scales)
    map=(1/M:M/(fs/1000)/(M-W+1):M/(fs/1000));
    
    d=[]; dim = [];
    totalFrames = size(sigFramed,2);
    for mint = 1 :totalFrames
        d = frdimsigfmc1(sigFramed(:,mint),'maxscale',M,'window',W);
        dim=[dim d];
    end
    
    m = mean(dim,2);
    st = std(dim,[],2);
    
    figure; 
    errorbar(map, m, st,'k');
    fnts = fnts;
    axis([0 3 0.9 2]);
    set(gca,'xTick',0:0.5:3,'yTick',1:0.1:2,'FontSize',fntss);
    xlabel('SCALE (millisec)','FontSize',fnts); 
    ylabel(['FRACTAL DIMENSION (nr sin = ', num2str(i), ')'],'FontSize',fnts);
end


%% ************************************************************************ 
% Example III: An EEG signal
% *************************************************************************
% In example_bio.mat you can find an EEG signal (alpha band) with duration of
% 15 seconds.
% The sampling frequency is fs = 128 Hz and the MFD computation is
% performed in the whole signal.
% The MFD parameters are specifally chosen for this signal.


file = load('example_bio.mat') % an EEG signal of 15 sec.
x = cell2mat(struct2cell(file));
fs = 128; %128 Hz
t = [0:length(x)-1]/fs; % time vector

figure;
plot(t,x);
title('A bio signal extracted from EEG (a band)','FontSize',fnts)
xlabel('Time (sec)','FontSize',fnts)
ylabel('EEG signal','FontSize',fnts)
axis('tight')


% ------------------------------------
% Compute MultiScale Fractal Dimension
% using frdimsigfmc1.m
% ------------------------------------

% Define maxscale M and window W
% Those parameters were chosen after experimentation specifically for the bio signal
M = 15*fs/5; % M = 384, 15 is the length of the signal (sec)
W = 30; 

map=(1/M:M/(fs/5)/(M-W+1):M/(fs/5)); % maping to scales

% Run the algorithm and compute MFD for the whole 15 sec signal

d=frdimsigfmc1(x,'maxscale',M,'window',W);

figure;
plot(map, d);
set(gca,'xTick',0:5:15,'FontSize',fntss);
title('Multiscale Fractal Dimension')
xlabel('SCALE (sec)','FontSize',fnts); 
ylabel('FRACTAL DIMENSION','FontSize',fnts);









