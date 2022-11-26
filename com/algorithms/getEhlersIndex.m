% There is one other very simple HRA measure we can add - [Ehlers' index (EI), ' ...
%     'estimated by the skewness of differences between successive samples (without reference to Poincaré plots):]
% 
% This should come first in the Excel Results file. 

function [EI]=getEhlersIndex(data)

  diff = data(2:end,:)-data(1:end-1,:);
  EI = sum(diff.^3)/(sum(diff.^2))^(3/2)

end