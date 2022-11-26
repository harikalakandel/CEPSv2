function varargout = correlationDimension(x, varargin)
% CORRELATIONDIMENSION Correlation Dimension
%
%   VALUE = CORRELATIONDIMENSION(X) estimates the correlation dimension of the
%   uniformly sampled time-domain signal in matrix/timetable X. If X has
%   multiple columns and multiple rows, CORRELATIONDIMENSION computes the
%   correlation dimension by treating X as multivariate time series, where
%   each column represents one time series. VALUE is a scalar storing the
%   correlation dimension.
%
%   VALUE = CORRELATIONDIMENSION(X, LAG) estimates the correlation dimension for
%   the time delay LAG. The LAG is equivalent to the 'Lag' name-value pair.
%
%   VALUE = CORRELATIONDIMENSION(X, [], DIM) estimates the correlation dimension
%   for the embedding dimension DIM. The DIM is equivalent to the 'Dimension'
%   name-value pair.
%
%   VALUE = CORRELATIONDIMENSION(X, LAG, DIM) estimates the correlation dimension
%   for the time delay LAG and the embedding dimension DIM.
%
%   VALUE = CORRELATIONDIMENSION(..., Name, Value) estimates the correlation
%   dimension of the time-domain signal in matrix/timetable X by specifying
%   parameters in name-value pair:
%
%   'Dimension' - Embedding dimension D. D can be a scalar or a vector. When D
%   is a scalar, every column in X is reconstructed using dimension D. When D
%   is a vector having same length as the number of column in X, the embedding
%   dimension for column i is D(i). The default value is 2.
%
%   'Lag'       -  Delay L in phase space reconstruction. L can be a scalar or
%   a vector. When L is a scalar, every column in X is reconstructed using lag
%   L. When L is a vector having same length as the number of column in X, the
%   reconstruction delay for column i is L(i). The default value is 1.
%
%   'MaxRadius' - Maximum radius for determining with-in range points. The
%   default value is 0.2*sqrt(tr(cov(X))).
%
%   'MinRadius' - Minimum radius for determining with-in range points. The
%   default value is MaxRadius/1000.
%
%   'NumPoints' - Generate N points between MinRadius and MaxRadius. When N =
%   1, use MaxRadius. The default value is 10.
%
%   [VALUE, RRANGE, CORRI] = CORRELATIONDIMENSION(...) also returns the radius
%   range RRANGE and the corresponding correlation integral CORRI diagnostic
%   purposes.
%
%   CORRELATIONDIMENSION(...) with no output arguments plots the
%   log(Correlation Integral) versus log(Radius).
%
%   EXAMPLE 1: Correlation Dimension of random Gaussian noise
%   x = randn(1000,1);
%   value = correlationDimension(x);
%
%   See also LYAPUNOVEXPONENT, APPROXIMATEENTROPY, PHASESPACERECONSTRUCTION

% Copyright 2017-2018 The MathWorks, Inc.

narginchk(1,13); % Data and all possible NV pairs
nargoutchk(0,3);

[x, lag, dim, rvec, numpts, isSingle, isRmaxDefined] = parseAndValidateInputs(x, varargin{:});

% step 1: phase space reconstruction
try
X = predmaint.internal.NonlinearFeatures.getPhaseSpace(x, lag, dim);
catch
    X =NonlinearFeatures.getPhaseSpace(x, lag, dim);
end
np = size(X,1);
Mdl = KDTreeSearcher(X(1:np,:), 'Distance', 'euclidean');

% step 2: calculate the number of within-range points
[logrvec, logC, Cepsilon] = countWithinRangePoints(Mdl, X, np, rvec);

if length(logC) <= 1
  if isRmaxDefined
    error(message('predmaint:analysis:LineFittingFailureCD'));
  else
    % Estimated maximum radius is too conservative. Now, use the
    % statistics of reconstructed phase space to estimate the maximum
    % radius.
    numSD = 1;
    maxIter = 100;
    maxIterFlag = 0;
    while(length(logC)<=1)
      rmax = numSD * sqrt(trace(cov(X)));
      rvec = logspace(log10(rvec(1)), log10(rmax), numpts)';
      [logrvec, logC, Cepsilon] = countWithinRangePoints(Mdl, X, np, rvec);
      numSD = numSD + 1;
      if numSD >= maxIter
        maxIterFlag = 1;
        break
      end
    end
    if maxIterFlag
      error(message('predmaint:analysis:LineFittingFailureCD'));
    else
      warning(num2str(rvec(end)));
    end
  end
end

% regression
P = polyfit(logrvec,logC,1);
value = P(1);

% cast output to single if needed
if isSingle
  value = cast(value,'single');
  rvec = cast(rvec,'single');
  Cepsilon = cast(Cepsilon,'single');
end

if nargout == 0
  predmaintguis.internal.plot.coeffFittingPlot(exp(logrvec), exp(logC), mfilename);
end

if nargout > 0
  varargout{1} = value;
end

if nargout > 1
  varargout{2} = rvec;
end

if nargout > 2
  varargout{3} = Cepsilon;
end

end


function [logrvec, logC, Cepsilon] = countWithinRangePoints(Mdl, X, np, rvec)
Cepsilon = zeros(length(rvec),1);
for i = 1:np
  [idx, dist] = rangesearch(Mdl, X(i,:), rvec(end));
  idxKeep = cell2mat(idx)~=i;
  for j = 1:length(rvec)
    Cepsilon(j) = Cepsilon(j) + sum( idxKeep & cell2mat(dist)<=rvec(j));
  end
end
Cepsilon = Cepsilon*2/(np*(np-1));

logC = log(Cepsilon);
idxKeep  = (~isinf(logC)) & (~isnan(logC));
logrvec = log(rvec(idxKeep));
logC = logC(idxKeep);
end


function [x, lag, dim, rvec, numpts, isSingle, isRmaxDefined] = parseAndValidateInputs(x, varargin)
% Input type checking
validateattributes(x, {'single','double','timetable'}, {'nonempty','size', [NaN, NaN]}, mfilename, 'X');
isSingle = isa(x, 'single');

% Handle timetable
if istimetable(x)
  predmaint.internal.utilValidateattributesTimetable(x, {'sorted', 'regular', 'multichannel'}, mfilename, 'X');
  [x,t] = predmaint.internal.utilParseTimetable(x);
  validateattributes(t, {'single','double'}, {'nonnan','finite','real'}, mfilename, 'T');
end

% Data integrity checking
validateattributes(x, {'single','double'}, {'nonnan','real','finite','nonsparse'}, mfilename, 'X');

% Vector is always considered as a single-channel signal
if isvector(x)
  x = x(:);
end

if isscalar(x)
  error(message('predmaint:general:nonScalarInput', 'X'));
end

% Parse and validate name-value pairs
p = inputParser;
p.FunctionName = mfilename;
addOptional(p, 'Lag', 1, ...
  @(x) validateattributes(x, {'numeric'}, {'nonnan','finite','real','integer','nonnegative'}, mfilename, 'Lag'));
addOptional(p, 'Dimension', 2, ...
  @(x) validateattributes(x, {'numeric'}, {'nonempty','nonnan','finite','real','integer','positive'}, mfilename, 'Dimension'));
addParameter(p, 'MaxRadius', [], ...
  @(x) validateattributes(x, {'numeric'}, {'nonnan','finite','real','positive'}, mfilename, 'MaxRadius'));
addParameter(p, 'MinRadius', [], ...
  @(x) validateattributes(x, {'numeric'}, {'nonnan','finite','real','positive'}, mfilename, 'MinRadius'));
addParameter(p, 'NumPoints', 10, ...
  @(x) validateattributes(x, {'numeric'}, {'nonempty','nonnan','finite','real','integer','scalar','>',1}, mfilename, 'NumPoints'));
parse(p,varargin{:});

% Assign default Lag value to handle the calling format f(x,[],dim)
if ~isempty(p.Results.Lag)
  lag = p.Results.Lag;
else
  lag = 1;
end

dim = p.Results.Dimension;
numpts = p.Results.NumPoints;

% Validate number of element in Dim and Lag
nc = size(x,2);
if numel(lag) > 1
  validateattributes(lag, {'numeric'}, {'numel',nc}, mfilename, 'Lag');
end
if numel(dim) > 1
  validateattributes(dim, {'numeric'}, {'numel',nc}, mfilename, 'Dimension');
end

% Assign default MaxRadius value to handle the calling format f(...,'MaxRadius',[])
if ~isempty(p.Results.MaxRadius)
  isRmaxDefined = true;
  rmax = p.Results.MaxRadius;
else
  isRmaxDefined = false;
  rmax = 0.2*sqrt(trace(cov(x)));
end
validateattributes(rmax, {'numeric'}, {'scalar'}, mfilename, 'MaxRadius');

% Consistency of MinRadius and MaxRadius
if ~isempty(p.Results.MinRadius)
  rmin = p.Results.MinRadius;
else
  rmin = rmax/1000; % MinRadius, when not specified, depends on MaxRadius.
end
validateattributes(rmin, {'numeric'}, {'scalar','>',0,'<',rmax}, mfilename, 'MinRadius');
rvec = logspace(log10(rmin), log10(rmax), numpts)';
end
