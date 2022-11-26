
%%------------------------------------------------------------------------
%% Choose best of 2 values, do not use NaNs
%%
function[answer]= choose2(val1, val2)
    answer = 0;  %% // default if both are NaNs
	
	  %% case 1: both values OK
	  if isreal(val1) && isreal(val2)
		    answer = (val1 + val2) / 2.0;
    elseif (isreal(val1))
		    answer = val1;
    elseif (isreal(val2))
		    answer = val2;
    end
end
