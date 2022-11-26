function [result] = f_hjorth_m( input_signal )

%======================================================================%
%                  Function name: f_hjorth_m
%                        Firgan Feradov
%
%   Details: 
%   Mobility is one of the three statistical features, proposed by
%   Bo Hjorth, that can be used to describe an EEG signal.
%
%   Bo Hjorth, "EEG analysis based on time domain properties",
%   Electroencephalography and Clinical Neurophysiology, Volume 29, 
%   Issue 3, September 1970, Pages 306-310, ISSN 0013-4694
%
%   Function description:
%   This function calculates the Mobility of a signal from the time domain.   
%
%   Inputs: 
%   input_signal  -  EEG signal (channel/frame) with size 1xN; 
%
%   Outputs:
%   result        -  The value of the Mobility for the input signal.
%======================================================================%

frame_length = size(input_signal,2);

%Calculating first derivative of the frame
frame_first_derivative = diff(input_signal);
first_missing_value = frame_first_derivative(1,frame_length-1);
frame_first_derivative = [frame_first_derivative,first_missing_value];

% Hjorth Mobility is calculated;
result = sqrt(((std( frame_first_derivative))^2)/((std(input_signal))^2));

end

