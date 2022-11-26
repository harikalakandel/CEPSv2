function [result] = f_hjorth_c(input_signal)

%======================================================================%
%                  Function name: f_hjorth_c
%                        Firgan Feradov
%
%   Details: 
%   Complexity is one of the three statistical features, proposed by
%   Bo Hjorth, that can be used to describe an EEG signal.
%
%   Bo Hjorth, "EEG analysis based on time domain properties",
%   Electroencephalography and Clinical Neurophysiology, Volume 29, 
%   Issue 3, September 1970, Pages 306-310, ISSN 0013-4694
%
%   Function description:
%   This function calculates the Complexity of a signal from the time domain.   
%
%   Inputs: 
%   input_signal  -  EEG signal (channel/frame) with size 1xN; 
%
%   Outputs:
%   result        -  The value of the Complexity for the input signal.
%======================================================================%

% The length of the input signal is calculated
frame_length = size(input_signal,2);

%Calculating first derivative of the signal
frame_first_derivative = diff(input_signal);
first_missing_value = frame_first_derivative(1,frame_length-1);
frame_first_derivative = [frame_first_derivative,first_missing_value];

%Calculating second derivative of the signal:
frame_second_derivative = diff(frame_first_derivative);
second_missing_value = frame_second_derivative(1,frame_length-1);
frame_second_derivative = [frame_second_derivative,second_missing_value];

% Calculating mobility
Mobility = sqrt(((std( frame_first_derivative))^2)/((std(input_signal))^2));

% First derivative of mobility
Mobility_der = sqrt(((std(frame_second_derivative))^2)/((std(frame_first_derivative))^2));
% The Complexity is calculated;
result = Mobility_der/Mobility;

end

