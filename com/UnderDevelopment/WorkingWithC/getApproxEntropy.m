% //-----------------------------------------------------------------------------
% // calculate approximate entropy
% //
% void Analyse::ApproxEntropy(char* command)
% parameters:
% 1 vecData
% 2 pattern
% 3 tolerance 
function [approx_entropy]=getApproxEntropy(vecData,varargin)
% {
%   if (vecData.size() == 0)
%   {
%     cerr << "\nNo data: please load a file.";
%     return;
%   }
if size(vecData,1)==0
    return;
end


run('Analysis_Const.m');
run('Analysis_Init.m');

% 
%   int pattern = DEFAULT_PATTERN;
%   double tolerance = DEFAULT_TOLERANCE;

pattern = DEFAULT_PATTERN;
tolerance = DEFAULT_TOLERANCE;



% 
%   // Read value from input and set pattern length
%   char* pch = strtok(command, " \t");   // first token will be "pattern"
% 
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     pattern = atoi(pch);
%   }
if nargin>1
    pattern=varargin{1};
end
%   if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX)
%   {
%     pattern = DEFAULT_PATTERN;
%   }
if pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX
    pattern = DEFAULT_PATTERN;
end
% 
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     tolerance = atof(pch);
%   }
if nargin>2
    tolerance=varargin{2};
end

%   if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
%   {
%     tolerance = DEFAULT_TOLERANCE;
%   }

if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
     tolerance = DEFAULT_TOLERANCE;
end


% 
%   //float estimate_approximate_entropy(float *data, int size, int embedded_dim, float r_coeff)
% 
%   int i, j, k, vsize, r;
%   float approx_entropy;
%   float cond_prob;
% 
%   r = (int) (tolerance * stdev + 0.5); /* tolerance value */
r = floor( (tolerance * stdev + 0.5));
% 
%   vsize = vecData.size() - pattern;
vsize = size(vecData,1)-pattern;
% 
%   int* accept_cntr1 = new int[vsize];
%   int* accept_cntr2 = new int[vsize];



%   for (i = 0; i < vsize; ++i)
%   {
%     accept_cntr1[i] = accept_cntr2[i] = 0;
%   }
% 
accept_cntr1 = zeros(vsize,1);
accept_cntr2 = zeros(vsize,1);
%   for (i = 0; i < vsize; ++i) /* for each reference vector */
%   {
%     for (j = (i + 1); j < vsize; ++j) /* for each other vector */
%     {
%       /* acceptable difference ? */
%       for (k = 0; k < pattern; ++k)
%       {
%         if (fabs(vecData[i + k] - vecData[j + k]) > r)
%         {
%           break;
%         }
%       }
%       if (k == pattern)
%       {
%         ++accept_cntr1[i];
%         ++accept_cntr1[j];
%         if (fabs(vecData[i + k] - vecData[j + k]) <= r)
%         {
%           ++accept_cntr2[i];
%           ++accept_cntr2[j];
%         }
%       }
%     }
%   }


for i=1:vsize
    for j=i+1:vsize
        for k=1:pattern
            if abs(vecData(i+k,1)-vecData(j+k)) > r
                break;
            end
        end
        if k == pattern

         accept_cntr1(i) = accept_cntr1(i)+1;
         accept_cntr1(j) = accept_cntr1(j)+1;
         

         if abs(vecData(i + k,1) - vecData(j + k,1)) <= r

            accept_cntr2(i) = accept_cntr2(i)+1;
            accept_cntr2(j) = accept_cntr2(j)+1;
         end
        end


    end
end

% 
%   approx_entropy = 0.0;
approx_entropy = 0.0;
% 
%   for (i = 0; i < vsize; ++i)
%   {
%     if (accept_cntr1[i] > 0)
%     {
%       cond_prob = (float) accept_cntr2[i] / (float) accept_cntr1[i];
%     }
%     else
%     {
%       cond_prob = (float) 0.0;
%     }
%     if (cond_prob > (float) 0.0)
%     {
%       approx_entropy += (-1.0) * log((double) cond_prob);
%     }
%   }

  for i = 1:vsize
  
    cond_prob = 0.0;
    if (accept_cntr1(i) > 0)
    
        cond_prob =  accept_cntr2(i) /  accept_cntr1(i);
    end
    
    if (cond_prob > 0.0)
    
      approx_entropy =approx_entropy +  (-1.0) * log(cond_prob);
    end
  end
  




% 
%   approx_entropy /= vsize;
approx_entropy = approx_entropy/vsize;
%   if (verbose)
%   {
%     cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Approx entropy " << approx_entropy << endl;
%   }
%   else
%   {
%     cout << scale << " " << pattern << " " << tolerance << " " << approx_entropy << endl;
%   }
%   Result temp("appen", scale, pattern, approx_entropy);
%   results.push_back(temp);


%   
%   delete accept_cntr1;
%   delete accept_cntr2;
clear accept_cntr1 accept_cntr2
% }

% 
% 
end
