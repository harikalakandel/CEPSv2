
%%------------------------------------------------------------------------
%% Choose best of 2 values, do not use NaNs
%%
function[answer]= choose2(val1, val2)
    answer = 0;  %% // default if both are NaNs
	
	%% case 1: both values OK
	if ~isnan(val1) && ~isnan(val2)
	
		answer = (val1 + val2) / 2.0;
	
    elseif ~isnan(val1) && isnan(val2)
	
		answer = val1;
	
    elseif (isnan(val1) && ~isnan(val2))
	
		answer = val2;
    end
	

end
