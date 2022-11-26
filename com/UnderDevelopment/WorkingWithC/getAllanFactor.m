%//-----------------------------------------------------------------------------
%// Calculate Allen factor
%//
%//void Analyse::AllanFactor(char* command)
%//{
%% parameters-> data, window(if available)
function [allan] = getAllanFactor(vecData,varargin)

% //if (vecData.size() == 0)
%  // {
% //    cerr << "\nNo data: please load a file.";
% //    return;
% //  }

allan=nan;
if size(vecData,1) <=0
    return
end

run('Analysis_Const.m');
run('Analysis_Init.m');

% %  double window = 0;
window = 0;
% 
%   char* pch = strtok(command, " \t"); // first token will be "window"
%   pch = strtok(NULL, " \t");
%   if (pch != NULL)
%   {
%     window = atof(pch);
%   }
if nargin >=2
    window = varargin{1};
end

%   if (window < DEFAULT_WINDOW_MIN || window > DEFAULT_WINDOW_MAX)
%   {
%     window = DEFAULT_WINDOW;
%   }

 if (window < DEFAULT_WINDOW_MIN || window > DEFAULT_WINDOW_MAX)
     window = DEFAULT_WINDOW;
 end


% move to parameter
%  //double thisRR = 0.0;   // the RR interval just read from file
%   double time = 0.0;   // the cumulative RR interval = current time since start of file
%   double sum_diff_sq = 0;   // top line of Allan factor = sum (N_i+1 - N_i)^2
%   double boundary = window;   // next window boundary
%   int this_count = 0;   // number of R waves in this window = N_i+1
%   int last_count = 0;   // number of R waves in last window = N_i
%   double sum_count = 0;   // bottom line of Allan factor = sum (N_i+1)
%   int windows = 0;

   time = 0.0;   %// the cumulative RR interval = current time since start of file
   sum_diff_sq = 0;   %// top line of Allan factor = sum (N_i+1 - N_i)^2
   boundary = window; %  // next window boundary
   this_count = 0;   %// number of R waves in this window = N_i+1
   last_count = 0;  % // number of R waves in last window = N_i
   sum_count = 0;   %// bottom line of Allan factor = sum (N_i+1)
   windows = 0;




    %  for (int ndx=0; ndx<vecData.size(); ndx++)
    %  {
    for ndx=1:size(vecData,1)
    %    time += vecData[ndx];
        time = time+vecData(ndx,1);
        %// if the interval is set small, may be several windows containing no R waves
    %    while (time > boundary)
    %    {
        while time > boundary
          %// calculate averages of diff and number of R waves
          %double diff = this_count - last_count;
          diff = this_count - last_count;
          %sum_diff_sq += (diff * diff);
          sum_diff_sq =sum_diff_sq+ (diff * diff);
          %sum_count += this_count;
          sum_count = sum_count + this_count;
          %boundary += window; // increment window position
          boundary = boundary+window; 
          %windows++;
          windows=windows+1;

          last_count = this_count;
          this_count = 0;
       % }
        end
        %this_count++;
        this_count=this_count+1;
    %  }
    end
  
  %double allan = sum_diff_sq / 2.0 / sum_count;
  allan = sum_diff_sq / 2.0 / sum_count;
%   cout << sum_diff_sq << " " << sum_count << endl;
%   if (verbose)
%   {
%     cout << "Scale " << scale << ", Window size " << window << ", Allan factor: " << allan << endl;
%   }
%   else
%   {
%     cout << scale << " " << window << " " << allan << endl;
%   }
%  Result temp("allan", scale, window, allan);
%  results.push_back(temp);
%??    results=[results; temp];

% }

end

