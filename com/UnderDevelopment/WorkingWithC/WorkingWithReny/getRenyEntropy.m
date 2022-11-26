function [renyi] = getRenyEntropy(vecData,pattern)


% //-----------------------------------------------------------------------------
% // calculate Renyi entropy using the density method
% //
% void Analyse::RenyiEntropy(char* command)
% {
%   //cout << "RenyiEntropy: verbose = " << verbose << " dataReps " << dataReps << endl;
%   if (vecData.size() == 0)
%   {
%     cerr << "\nNo data: please load a file.";
%     return;
%   }
   if size(vecData,1)==0
        return;
   end
    
  run('Analysis_Const')
  run('Analysis_Init.m')
 
   
   

   


%
%   int pattern = DEFAULT_PATTERN;
%   double tolerance = DEFAULT_TOLERANCE;
%   double exponent = DEFAULT_EXPONENT;
%
%   pattern = DEFAULT_PATTERN;
    tolerance = DEFAULT_TOLERANCE;
    exponent = DEFAULT_EXPONENT;

%   // Read value from input and set pattern length
%   char* pch = strtok(command, " \t");   // first token will be "pattern"
%
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     pattern = atoi(pch);
%   }
%   if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX || pattern > dataWind)
%   {
%     pattern = DEFAULT_PATTERN;
%   }
    
    if pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX || pattern > dataWind
        pattern = DEFAULT_PATTERN;
    end

   
%
%   long words = dataWind - pattern + 1;
%   long maxlength = dataWind + ((dataReps - 1) * dataSkip);
%   long maxlimit = dataStrt + maxlength;

    words = dataWind - pattern + 1;
    maxlength = dataWind + ((dataReps - 1) * dataSkip);
    maxlimit = dataStrt + maxlength-1;


%
%   if (verbose > 1)
%   {
%     printf("Renyi Entropy with repeats %d, pattern %d from %d to %d: %d values, %d words, up to %d.\n", dataReps, pattern, dataStrt, dataStrt+dataWind, dataWind, words, maxlimit);
%   }
%
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     tolerance = atof(pch);
%   }
%
%   // stdev is based on the data subset including repeats
%   if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
%   {
%     // Silvermans' rule
%     //tolerance = stdev * pow(4.0 / (2.0 + pattern) / words, 1.0 / (4.0 + pattern));
%     // my rule of thumb
%     tolerance = 0.006 * exp(0.1722 * pattern);
   
%     if (verbose > 1)
%     {
%       //cout << "Silvermans' rule: " << stdev << " " << pattern << " " << words << " " << tolerance << ".\n";
%       cout << "Rule of thumb: " << pattern << " " << tolerance << endl;
%     }
%   }

    if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
        tolerance = 0.006 * exp(0.1722 * pattern);    
    end



    


%
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     exponent = atof(pch);
%   }
%   if (exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX)
%   {
%     exponent = DEFAULT_EXPONENT;
%   }

    if (exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX)
        exponent = DEFAULT_EXPONENT;
    end
%   if (probability == NULL || pattern != last_pattern || tolerance != last_tolerance)
%   {
%     // calc Renyi probs over the whole data segment being used, including repeats
%     if (verbose > 1)
%     {
%       cout << "Calculate probabilities\n";
%     }
%     int maxwords = maxlength - pattern + 1;
%     RenyiProbs(maxwords, pattern, tolerance);
%   }

    
    if (pattern ~= last_pattern || tolerance ~= last_tolerance)
        maxwords = maxlength - pattern + 1;
        
    end
    probability = getRenyiProbs(vecData,maxwords, pattern, tolerance);





%
%   // calc Renyi Entropy over the number of repeats chosen
%   // ***** add option to display only means +- std err?
%   double sum_x = 0.0;
%   double sum_xx = 0.0;

    sum_x = 0.0;
    sum_xx = 0.0;


%   for (int rep=0; rep<dataReps; rep++)
    for rep=1:dataReps
    %   {
    %     int word_beg = rep * dataSkip;
    %     int word_end = word_beg + words;
    
        word_beg = rep * dataSkip;
        word_end = word_beg + words-1;
    
    %
    %     // normalise probs to add up to 1.0
    %     double sum_prob = 0.0;
    
    %     for (int pos=word_beg; pos<word_end; pos++)
    %     {
    
    try
         sum_prob = sum(probability(word_beg:word_end));
    catch
        x=1;
    end
    %       sum_prob += probability[pos];
    %     }
    %     if (verbose > 1)
    %     {
    %       printf("sum_prob from %d to %d: %f\n", word_beg, word_end, sum_prob);
    %     }
    %     // calc Renyi entropy using the probabilities
    %     double sum_renyi = 0.0;
        sum_renyi = 0.0
    %   for (int pos=word_beg; pos<word_end; pos++)
    %   {
        for pos=word_beg:word_end-1
        %       double prob = probability[pos] / sum_prob;   // normalise here
                prob = probability(pos)/sum_prob;
        %       if (prob > 0.0)   // if zero, this calculation goes inf
        %       {
        %         if (exponent == 1.0)   // special case is Shannon Entropy
        %         {
        %           sum_renyi += prob * log(prob) / log((double)2.0);
        %         }
        %         else
        %         {
        %           sum_renyi += pow(prob, exponent);
        %         }
        %       }
        
        
                if prob >0
                    if exponent ==1
                        sum_renyi = sum_renyi+(prob + log(prob))/log(2);
                    else
                        sum_renyi = sum_renyi+prob^exponent
                    end
                end
        %     }
        end
        
        %
        %     // adjust scale factors
        %     double renyi = 0.0;
              renyi = 0.0;
        %     if (exponent == 1.0)   // special case is Shannon Entropy
        %     {
        %       renyi = -sum_renyi;
        %     }
        %     else
        %     {
        %       renyi = log(sum_renyi) / log((double)2.0) / (1 - exponent);
        %     }
        
        if exponent ==1
            renyi = -sum_renyi
        else
            renyi = log(sum_renyi) / log(2) / (1 - exponent)
        end
        %
        %     renyi /= (log((double)dataWind) / log((double)2.0));   // adjust for the length of the data set
        renyi = renyi / (log(dataWind) / log(2));
        %     // calc mean and stdev
        %     sum_x += renyi;
        sum_x = sum_x + renyi
        %     sum_xx += (renyi * renyi);
        sum_xx = sum_xx + (renyi * renyi)
        %
        %     if (verbose > 1)
        %     {
        %       cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Exponent " << exponent << ", Renyi entropy " << renyi << endl;
        %     }
        %     else if (verbose == 1)
        %     {
        %       cout << scale << " " << pattern << " " << tolerance << " " << exponent << " " << renyi << endl;
        %     }
        %     else if (dataReps == 1)   // must be consistet with the form for dataReps > 1 below
        %     {
        %       cout << renyi << " " << tolerance << " " << pattern << " " << endl;
        %     }
        %   }
    end
    %
    %   if (dataReps > 1)
    %   {
    %     double renyi_mean = sum_x / dataReps;
    %     double renyi_stdev = sqrt(sum_xx / (dataReps - 1) - renyi_mean * renyi_mean);
    %     cout << renyi_mean << " " << renyi_stdev << " " << dataReps << endl;
    %   }
    %
    %   last_pattern = pattern;
    last_pattern = pattern
    %   last_tolerance = tolerance;
    last_tolerance = tolerance
    % }
end
