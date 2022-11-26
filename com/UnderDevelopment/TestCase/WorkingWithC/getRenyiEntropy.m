%% cannot set value of probability

function [renyiSum,exponent,tolerance] = getRenyiEntropy(vecData)
MyDefaultParams
%% ?????????????
probability=[];
%DEFAULT_PATTERN = 2;
%DEFAULT_TOLERANCE = 0.15
%//-----------------------------------------------------------------------------
%// calculate Renyi entropy using the density method
%//
%void Analyse::RenyiEntropy(char* command)

%   //cout << "RenyiEntropy: verbose = " << verbose << " dataReps " << dataReps << endl;
%     if (vecData.size() == 0)
%     {
%         cerr << "\nNo data: please load a file.";
%         return;
%     }

     pattern = DEFAULT_PATTERN;
     tolerance = DEFAULT_TOLERANCE;
     exponent = DEFAULT_EXPONENT;
%
%     // Read value from input and set pattern length
%     char* pch = strtok(command, " \t");   // first token will be "pattern"
%
%     pch = strtok(NULL, " \t");
%     if (pch != NULL)
%     {
%         pattern = atoi(pch);
%     }
%     if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX || pattern > dataWind)
%     {
%         pattern = DEFAULT_PATTERN;
%     }

%%// set default values
dataStrt = 1;
dataWind = size(vecData,1);
dataSkip = 1;
dataReps = 1;
M_PI = 22/7;


words = dataWind - pattern + 1;
maxlength = dataWind + ((dataReps - 1) * dataSkip);
maxlimit = dataStrt + maxlength;

%     if (verbose > 1)
%     {
%         printf("Renyi Entropy with repeats %d, pattern %d from %d to %d: %d values, %d words, up to %d.\n", dataReps, pattern, dataStrt, dataStrt+dataWind, dataWind, words, maxlimit);
%     }
%
%     pch = strtok(NULL, " \t");
%     if (pch != NULL)
%     {
%         tolerance = atof(pch);
%     }
%
%    // stdev is based on the data subset including repeats
%if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
if tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX
    
    %         // Silvermans' rule
    %         //tolerance = stdev * pow(4.0 / (2.0 + pattern) / words, 1.0 / (4.0 + pattern));
    %         // my rule of thumb
    tolerance = 0.006 * exp(0.1722 * pattern);
    %         if (verbose > 1)
    %         {
    %             //cout << "Silvermans' rule: " << stdev << " " << pattern << " " << words << " " << tolerance << ".\n";
    %             cout << "Rule of thumb: " << pattern << " " << tolerance << endl;
    %         }
end
% input from user...
%     pch = strtok(NULL, " \t");
%     if (pch != NULL)
%     {
%         exponent = atof(pch);
%     }

%if (exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX)
if exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX
    
    exponent = DEFAULT_EXPONENT;
end

%if (probability == NULL || pattern != last_pattern || tolerance != last_tolerance)
if isempty(probability) || pattern ~= last_pattern || tolerance ~= last_tolerance
    
    %         // calc Renyi probs over the whole data segment being used, including repeats
    %         if (verbose > 1)
    %         {
    %             cout << "Calculate probabilities\n";
    %         }
    %int maxwords = maxlength - pattern + 1;
    %%??? change
    maxwords = maxlength - 2*pattern ;
    probability=RenyiProbs(vecData,maxwords, pattern, tolerance);
    %}
end

%     // calc Renyi Entropy over the number of repeats chosen
%     // ***** add option to display only means +- std err?
%     double sum_x = 0.0;
%     double sum_xx = 0.0;
sum_x = 0.0;
sum_xx = 0.0;


%for (int rep=0; rep<dataReps; rep++)
for rep=1:dataReps
    
    %int word_beg = rep * dataSkip;
    %int word_end = word_beg + words;
    
    word_beg = rep * dataSkip;
    word_end = word_beg + words;
    
    %// normalise probs to add up to 1.0
    %double sum_prob = 0.0;
    sum_prob = 0.0;
    %for (int pos=word_beg; pos<word_end; pos++)
    for pos=word_beg:word_end
        
        %sum_prob += probability[pos];
        sum_prob =sum_prob+ probability(pos,1);
        %}
        %         if (verbose > 1)
        %         {
        %             printf("sum_prob from %d to %d: %f\n", word_beg, word_end, sum_prob);
        %         }
        %        // calc Renyi entropy using the probabilities
        %double sum_renyi = 0.0;
        sum_renyi = 0.0;
        %for (int pos=word_beg; pos<word_end; pos++)
        for pos=word_beg: word_end
            %double prob = probability[pos] / sum_prob;   // normalise here
            prob = probability(pos,1) / sum_prob;
            %if (prob > 0.0)   // if zero, this calculation goes inf
            if prob > 0.0
                if (exponent == 1.0) %  // special case is Shannon Entropy
                    
                    %sum_renyi += prob * log(prob) / log((double)2.0);
                    sum_renyi =sum_renyi+ prob * log(prob) / log(2)
                    
                else
                    
                    sum_renyi =sum_renyi+ prob^exponent;
                end
            end
        end
        
        %// adjust scale factors
        renyi = 0.0;
        if (exponent == 1.0)  % // special case is Shannon Entropy
            
            renyi =renyi -sum_renyi;
            
        else
            
            renyi = log(sum_renyi) / log(2.0) / (1 - exponent);
        end
        
        renyi = renyi/(log(dataWind) / log(2.0)); %  // adjust for the length of the data set
        %// calc mean and stdev
        sum_x =sum_x+ renyi;
        sum_xx =sum_xx+ (renyi * renyi);
        
        %         if (verbose > 1)
        %
        %             cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Exponent " << exponent << ", Renyi entropy " << renyi << endl;
        %         }
        %         else if (verbose == 1)
        %         {
        %             cout << scale << " " << pattern << " " << tolerance << " " << exponent << " " << renyi << endl;
        %         }
        %         else if (dataReps == 1)   // must be consistet with the form for dataReps > 1 below
        %         {
        %             cout << renyi << " " << tolerance << " " << pattern << " " << endl;
        %         }
    end
    
    if (dataReps > 1)
        
        renyi_mean = sum_x / dataReps;
        renyi_stdev = sqrt(sum_xx / (dataReps - 1) - renyi_mean * renyi_mean);
        % cout << renyi_mean << " " << renyi_stdev << " " << dataReps << endl;
    end
    
    last_pattern = pattern;
    last_tolerance = tolerance;
end
