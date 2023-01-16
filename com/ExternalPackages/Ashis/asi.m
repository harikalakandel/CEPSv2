function [ ASI ] = asi( data )
% This function id used to compute Asymetric Spread Index (ASI) index
% Please cite the below mentioned publication for using this code in your
% work
% Ashish Rohila, and Ambalika Sharma. 
% "Asymmetric spread of heart rate variability." 
% Biomedical Signal Processing and Control 60 (2020): 101985.
%  doi = https://doi.org/10.1016/j.bspc.2020.101985

% Author: Ashish Rohila

%%
data = data(:);    % Convert the input data into a column vector

if size(data,2)  ~= 1;
    error('input must be a vector')
end

%%
x = data-min(data);   % Choosing reference point as minimum of data vector for slope computation
x0 = x(1:end-1);
x1 = x(2:end);  

slope = atan(x1./x0);   % Computation of slope angles
slope_r = (slope-pi/4); % computing slope relative to line of identity
dist = sqrt(x1.^2+x0.^2);  % Computation of distance

A = abs(slope_r.*dist);  % Comput                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ation of arc length corresponding to a point in Poincare Plot

ASI = std(A(slope_r>0))/(2*std(A));
ASI = ASI*100;          % ASI value in percentage

end


