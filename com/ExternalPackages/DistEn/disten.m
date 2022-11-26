function varargout = disten(ser, m, tau, B)
%DISTEN distribution entropy
% 
% Inputs:
%           ser    --- time-series (vector in a column)
%           m      --- embedding dimension (scalar)
%           tau    --- time delay (scalar)
%           B      --- bin number for histogram (scalar)
% 
% Ref.
%       [1] Peng Li, Chengyu Liu, Ke Li, Dingchang Zheng, Changchun Liu,
%           Yinglong Hou. "Assessing the complexity of short-term heartbeat
%           interval series by distribution entropy", Med Biol Eng Comput,
%           2015, 53: 77-87.
% 
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%                      (C) Peng Li 2013-2017
% If you use the code, please make sure that you cite reference [1]
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 
% See also JDISTEN, MMFE, APEN, SAMPEN, FUZZYEN
% 
% $Author:  Peng Li, PhD
%           Affiliation when this work was done:
%                   School of Control Science and Engineering
%                       Shandong University
%                   Jinan 250061, P. R. China
%                   pli@sdu.edu.cn
% $Date:    17 Jun 2015
% $Modif.:  
% 

% parse inputs
narginchk(4, 4);

% rescaling
ser = (ser - min(ser)) ./ (max(ser) - min(ser));

% distance matrix
N   = length(ser) - (m-1)*tau;
ind = hankel(1:N, N:length(ser));
rnt = ser(ind(:, 1:tau:end));
dv  = pdist(rnt, 'chebychev');

% esimating probability density by histogram
num  = hist(dv, linspace(0, 1, B));
freq = num./sum(num);

% disten calculation
DistEn = -sum(freq.*log2(freq+eps)) ./ log2(B);

% outputs
varargout{1} = DistEn;