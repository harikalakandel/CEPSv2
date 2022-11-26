classdef NonlinearFeatures
  %NONLINEARFEATURES Utility functions used by phaseSpaceReconstruction,
  %correlationDimension, approximateEntropy, lyapunovExponent commands.
  
  % Copyright 2018 The MathWorks, Inc.
  
  methods (Static, Sealed = true)
    function [lag, dim] = getPhaseSpaceReconstructionParams(data, lag, dim)
      cases = 2*isnumeric(lag) + isnumeric(dim);
      
      switch cases
        case 0
          [~,lag,dim] = phaseSpaceReconstruction(data);
        case 1
          [~,lag,~] = phaseSpaceReconstruction(data, [], dim);
        case 2
          [~,~,dim] = phaseSpaceReconstruction(data, lag);
        case 3
          % pass-through case
      end
    end
    
    function X = getPhaseSpace(x, lag, dim)
      % GETPHASESPACE Phase space reconstruction for a multivariate timeseries x
      % given lag and embedding dimension.
      [N, numTS] = size(x);
      isSingle = isa(x,'single');
      
      if length(dim)==1
        dim = repmat(dim, 1, numTS);
      end
      
      if length(lag)==1
        lag = repmat(lag, 1, numTS);
      end
      
      if isSingle
        ArrayType = 'single';
      else
        ArrayType = 'double';
      end
      
      np = N - (max(dim)-1)*max(lag);
      if np <= 0
        error(message('predmaint:analysis:notEnoughDataPhaseSpaceRecon'));
      end
      
      % Delay reconstruction
      X = zeros(np, sum(dim), ArrayType);
      startIdx = 0;
      for c = 1:numTS
        tau = lag(c);
        m = dim(c);
        
        for i = 1:m
          rmin = 1 + (i-1)*tau;
          rmax = rmin + np - 1;
          X(:,startIdx+i) = x(rmin:rmax,c);
        end
        startIdx = startIdx + m;
      end
    end
    
    function nearestPtIdx = getNearestNeighbors(mdl, X, np, MinSeparation)
      % GETNEARESTNEIGHBORS Find nearest neighbors of points in X given a kd
      % tree object MDL. The nearest neighbors should be separated by MinSeparation.
      nearestPtIdx = zeros(np,1);
      for s = 1:np
        idx = knnsearch(mdl, X(s,:), 'K', MinSeparation+2, 'Distance', 'euclidean');
        npt = idx(find(abs(idx-s) >= MinSeparation, 1, 'first'));
        if ~isempty(npt)
          nearestPtIdx(s) = npt;
        else
          nearestPtIdx(s) = idx(end);
        end
      end
    end
    
    function mInfo = getMutualInfo(x, y, numBin)
      % GETMUTUALINFO Calculate mutual information of two vectors x and y by
      % specifying the number of bins.
      [N,~] = hist3([x,y], [numBin,numBin]);
      
      Pxy = N/sum(N(:));
      Px = sum(Pxy, 2);
      Py = sum(Pxy, 1);
      
      tmp = Pxy.*log2(Pxy./Px./Py);
      tmp(isnan(tmp)) = 0;
      mInfo = sum(tmp(:));
    end
  end
end
