function [CurrentArray] = reDim(CurrentArray,SizeRunningW)
    if size(CurrentArray,2) > SizeRunningW
        CurrentArray=CurrentArray(1,SizeRunningW);
    end
    CurrentArray(1,SizeRunningW)=NaN;
end

