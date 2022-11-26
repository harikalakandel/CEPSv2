% //-----------------------------------------------------------------------------
% // calculate probabilities for Renyi entropy
% // these probs are not normalised, so must be normalised when running RenyiEntropy()
% // if Choose() specifies data samples to skip, this calculates all including the gaps
% // RenyiEntropy() just misses those extra ones out 
% //
%void Analyse::RenyiProbs(int words, int pattern, double tolerance)
function probability = getRenyiProbs(vecData,words, pattern,tolerance)
%   if (verbose >= 2)
%   {
%     cout << "Calculating probs...\n";
%   }
%   
%  probability = new double[words];
   probability = words;
   
   dataStrt = 1;
  
 % // calculate covariance matrix
 % if (verbose >= 3)
 % {
   % // create blank arrays
  %  double *dMean = new double[pattern];
  %  double **covar = new double*[pattern];
  

    
%     for (int ndx1=0; ndx1<pattern; ndx1++)
%     {
%       dMean[ndx1] = 0.0;
%       covar[ndx1] = new double[pattern];
%       for (int ndx2=0; ndx2<pattern; ndx2++)
%       {
%         covar[ndx1][ndx2] = 0.0;
%       }
%     }
    dMean = zeros(pattern,1);
    covar=zeros(pattern,pattern);
    
%     // estimate means
%     for (int pos=0; pos<words; pos++)
%     {
%       for (int ndx=0; ndx<pattern; ndx++)
%       {
%         dMean[ndx] += vecData[dataStrt + pos + ndx];   // dataStrt begins at 0
%       }
%     }

    for pos=1:words
        for ndx=1:pattern
            %%??? start from 1 so -2
        
            dMean(ndx,1)=dMean(ndx,1)+vecData(dataStrt + pos + ndx-2,1);
          
        end
    end
    
%     for (int ndx=0; ndx<pattern; ndx++)
%     {
%       dMean[ndx] /= words;
%     }
    dMean = dMean./words;
    
%     for (int pos=0; pos<words; pos++)
%     {
%       for (int ndx1=0; ndx1<pattern; ndx1++)
%       {
%         for (int ndx2=0; ndx2<pattern; ndx2++)
%         {
%           double dev1 = vecData[dataStrt + pos + ndx1] - dMean[ndx1];
%           double dev2 = vecData[dataStrt + pos + ndx2] - dMean[ndx2];
%           covar[ndx1][ndx2] += dev1 * dev2;
%         }
%       }
%     }
    
    
    for pos=1:words
        for ndx1=1:pattern
            for ndx2=1:pattern
                dev1 = vecData(dataStrt + pos + ndx1-2,1) - dMean(ndx1);
                dev2 = vecData(dataStrt + pos + ndx2-2,1) - dMean(ndx2);
                covar(ndx1,ndx2) = covar(ndx1,ndx2)+ dev1 * dev2;
            end
        end
    end
    
    
%     for (int ndx1=0; ndx1<pattern; ndx1++)
%     {
%       for (int ndx2=0; ndx2<pattern; ndx2++)
%       {
%         covar[ndx1][ndx2] /= (words-1);
%         printf ("covar %d %d %f\n", ndx1, ndx2, covar[ndx1][ndx2]);
%       }
%     }
    covar = covar./(words-1)
 
    %double det = covar[0][0];
    det = covar(1,1)
%     if (pattern > 1)
%     {
%       det = (covar[0][0] * covar[1][1]) - (covar[0][1] * covar[1][0]);
%     }
    if pattern >1
        det = (covar(1,1) * covar(2,2)) - (covar(1,2) * covar(2,1))
    end
    %printf ("det %f\n", det);
    
%     for (int ndx1=0; ndx1<pattern; ndx1++)
%     {
%       for (int ndx2=0; ndx2<pattern; ndx2++)
%       {
%         covar[ndx1][ndx2] /= sqrt(det);
%         printf ("covar %d %d %f\n", ndx1, ndx2, covar[ndx1][ndx2]);
%       }
%     }
    covar = covar/(det^(0.5));
   
    
    
    
%     //det = (covar[0][0] * covar[1][1]) - (covar[0][1] * covar[1][0]);
%     //printf ("det %f\n", det);
    
%     for (int ndx=0; ndx<pattern; ndx++)
%     {
%       delete [] covar[ndx];
%     }
%     delete covar;
%     delete dMean;
  %}
  %end
  
  %%???not sure how to calculate stdev
  stdev = std(vecData);
 % //double gaussC = 2 * tolerance * tolerance;
  %double gaussC = 2 * tolerance * tolerance * stdev * stdev;
   gaussC = 2 * tolerance * tolerance * stdev * stdev;
  %//double prob_total = 0.0;
%   for (int pos1=0; pos1<words; pos1++)
%   {
%     probability[pos1] = 0.0;
%     for (int pos2=0; pos2<words; pos2++)
%     {
%       double dist_sq = 0.0;
%       for (int ndx=0; ndx<pattern; ndx++)
%       {
%         dist_sq += pow(vecData[dataStrt + pos1 + ndx] - vecData[dataStrt + pos2 + ndx], 2.0);
%       }
%       //cout << " " << dist_sq << " " << exp(-dist_sq / gaussC) << endl;
%       probability[pos1] += exp(-dist_sq / gaussC);
%     }
%     
%     
%     
%     //cout << "total " << probability[pos1] << endl;
%     //prob_total += probability[pos1];
%   }
  for pos1=1:words
      probability(pos1) = 0.0;
      for pos2=1:words
            dist_sq = 0.0;
            for ndx=1:pattern
                dist_sq = dist_sq + (vecData(dataStrt + pos1 + ndx-2) - vecData(dataStrt + pos2 + ndx-2))^2;
            end
            probability(pos1) = probability(pos1)  + exp(-dist_sq / gaussC);
      end
       probability(pos1) = probability(pos1)+ exp(-dist_sq / gaussC);
  end
    
  
  %//probability[pos1] /= prob_total;   // normalise probs to sum to 1
%   if (verbose >= 2)
%   {
%     for (int pos1=0; pos1<words; pos1++)
%     {
%       cout << pos1 << " " << probability[pos1] << endl;
%     }
%   }
%}
end
