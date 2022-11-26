%Sub FD_M(dataarray, NData, D) 
function [D]=FD_M(dataarray,NData)
dataarray=dataarray(:);
%NData = size(dataarray,1);
% 'Evaluation of FDm on a time series of length Ndata 
% 'input: dataarray(1:NData) array containing the time series 
% ' NData length of the time series 
% 'output: D Fractal Dimension 
%Dim DataMax As Single, DataMin As Single, Length As Single 
%'Estimation of the Length of the curve 
%Length = 0 
Length = 0 ;
%For i = 2 To NData 
for i = 2:NData 
    %Length = Length + Abs(dataarray(i) - dataarray(i - 1)) 
    Length = Length + abs(dataarray(i) - dataarray(i - 1)) ;
%Next i 
end
%If Length = 0 Then 
if Length == 0  
    D = 0 ;
    %Exit Sub 
    return
%End If 
end
%'Estimation of the Planar extension of the curve 
%DataMin = dataarray(1) 
DataMin = dataarray(1); 
%DataMax = dataarray(1) 
DataMax = dataarray(1) ;
%For i = 2 To NData 
for i = 2 : NData 
    %If DataMin > dataarray(i) Then DataMin = dataarray(i) 
    if DataMin > dataarray(i) 
        DataMin = dataarray(i) ;
    end
    %If DataMax < dataarray(i) Then DataMax = dataarray(i) 
    if DataMax < dataarray(i) 
        DataMax = dataarray(i) ;
    end
%Next i 
end
%D_planar_extent = DataMax - DataMin 
D_planar_extent = DataMax - DataMin ;
%'Fractal Dimension 
%D = Log(NData - 1) / (Log(NData - 1) + Log(D_planar_extent / Length)) 
D = log(NData - 1) / (log(NData - 1) + log(D_planar_extent / Length)); 
%End Sub 
end

