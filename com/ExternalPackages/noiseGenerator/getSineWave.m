function [sineWave] = getSineWave(fs,F,Len,amp)
% fs = 512; % Sampling frequency (samples per second) 
%  dt = 1/fs; % seconds per sample 
%  StopTime = 0.25; % seconds 
%  t = (0:dt:StopTime)'; % seconds 
%  F = 60; % Sine wave frequency (hertz) 
%  data = sin(2*pi*F*t);
%  plot(t,data)



  dt = 1/fs; % seconds per sample 
  StopTime = Len*dt;
  t = (0:dt:StopTime)'; % seconds 
%  F = 60; % Sine wave frequency (hertz) 
  sineWave = amp*sin(2*pi*F*t);
%  plot(t,data)



end

