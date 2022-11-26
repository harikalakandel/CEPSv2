%Sub FD_C(dataarray, NData, D) 
function[D]= FD_C(dataarray,NData)
% 'Evaluate FDc on dataarray(1:Ndata); 
% 'output is D 
% 'FDc is obtained by calculating FDm on a running window and by averaging the estimates 
% 'The size of the running window, SizeRunningW, corresponds to a planar extension 
% ' half the planar extension of the whole curve 
%Dim TotalWindowsNumber As Long 'total number of overlapped windows 
%Dim Step As Long 'Distance between contiguous overlapped windows 
%Dim CurrentArray() As Single 'segment of data in the current window 
%Dim CurrentWindow As Integer 'index of the current window 
%Dim FDCur As Single 'FD of the current window 
%D = 0 
D = 0;
%'Find the size of the running window: SizeRunningW 
%Call D50_ottima(dataarray, NData, SizeRunningW) 
SizeRunningW=D50_ottima(dataarray, NData);
%If SizeRunningW < 8 Then SizeRunningW = 8 'minimum is 8 
if SizeRunningW < 8 
    %SizeRunningW = 8 'minimum is 8 
    SizeRunningW = 8 ;
end
%ReDim CurrentArray(1 To SizeRunningW) 
CurrentArray=[];
CurrentArray=reDim(CurrentArray,SizeRunningW);
%TotalWindowsNumber = 1 
TotalWindowsNumber = 1;
%'Calculate the increment (=Step) in the position of consecutive windows 
%Step = 0 
Step = 0 ;
%If NData > SizeRunningW Then 
if NData > SizeRunningW  
    %TotalWindowsNumber = Fix(NData / SizeRunningW) + 1 
    TotalWindowsNumber = fix(NData / SizeRunningW) + 1 ;
    %Step = (NData - SizeRunningW) / (TotalWindowsNumber - 1) 
    %% ???? Deepak I am getting step in decimal eg 7.6667 
    %% so used fix ????
    Step = fix((NData - SizeRunningW) / (TotalWindowsNumber - 1)) ;
%End If 
end


%FDCur = 0 
FDCur = 0 ;
%For CurrentWindow = 1 To TotalWindowsNumber - 1 'for all the windows but the last one 
for CurrentWindow = 1 : TotalWindowsNumber - 1 
    %'Load the data covered by the running window into the current array 
    %Offset = (CurrentWindow - 1) * Step 
    %% Deepak or fix can used here instead of line 38
    Offset = (CurrentWindow - 1) * Step ;
    %For ii = 1 To SizeRunningW 
    for ii = 1 : SizeRunningW 
        %CurrentArray(ii) = dataarray(ii + Offset) 
        %% Deepak will have error here if fix is not use in calculation of Step in line 38
        CurrentArray(ii) = dataarray(ii + Offset) ;
       
    %%Next ii 
    end
    %'Calculate FDm of the current array 
    %Call FD_M(CurrentArray, SizeRunningW, FDCur) 
    FDCur = FD_M(CurrentArray, SizeRunningW) ;
    %D = D + FDCur 
    D = D + FDCur ;
%Next CurrentWindow 
end
%'The last window ends exactly at the end of the dataarray 
%Offset = NData - SizeRunningW 
Offset = NData - SizeRunningW ;
%For ii = 1 To SizeRunningW 
for ii = 1 : SizeRunningW 
    %CurrentArray(ii) = dataarray(ii + Offset) 
    CurrentArray(ii) = dataarray(ii + Offset); 
%Next ii 
end
%'Calculate FDm of the current array 
%Call FD_M(CurrentArray, SizeRunningW, FDCur) 
FDCur = FD_M(CurrentArray, SizeRunningW) ;
%D = D + FDCur 
D = D + FDCur ;

%'Calculate the average of all the estimates 
%D = D / TotalWindowsNumber 
D = D / TotalWindowsNumber ;
%End Sub 
end

