function [result] = f_hjorth_a( input_signal )

%======================================================================%
%                  Function name: f_hjorth_a
%                         Firgan Feradov
%
%   Details: 
%   Activity is one of the three statistical features, proposed by
%   Bo Hjorth, that can be used to describe an EEG signal.
%
%   Bo Hjorth, "EEG analysis based on time domain properties",
%   Electroencephalography and Clinical Neurophysiology, Volume 29, 
%   Issue 3, September 1970, Pages 306-310, ISSN 0013-4694
%
%   Function description:
%   This function calculates the Activity of a signal from the time domain.   
%
%   Inputs: 
%   input_signal  -  EEG signal (channel/frame) with size 1xN; 
%
%   Outputs:
%   result        -  The value of the Activity for the input signal.
%======================================================================%

result = (std(input_signal))^2;

end

