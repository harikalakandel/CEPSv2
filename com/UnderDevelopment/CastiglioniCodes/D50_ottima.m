%Sub D50_ottima(dataarray, NData, NRunningWindow) 
function [NRunningWindow] = D50_ottima(dataarray, NData) 
% 'This routine calculates the size of the running window 
% 'with planar extension half the planar extension of the whole time series 
% 'input: dataarray(1:NData) = array with the whole time series 
% ' NData = length of the time series 
% 'output: NRunningWindow = length of the running window 
%Dim DataMax As Single, DataMin As Single, D_planar_extent As Single 
%Dim d50 As Single 
%Dim NStart As Long, Indice As Long, N1 As Long 
%Dim WindowLengthArray() As Long, NumberOfWindows As Integer 
%'Find the planar extension of the whole curve 
%DataMin = dataarray(1) 
DataMin = dataarray(1) ;
%DataMax = dataarray(1) 
DataMax = dataarray(1) ;
%For i = 2 To NData 
WindowLengthArray=[];
for i = 2 : NData 
    %If DataMin > dataarray(i) Then DataMin = dataarray(i) 
    %If DataMax < dataarray(i) Then DataMax = dataarray(i) 
    if DataMin > dataarray(i) 
        DataMin = dataarray(i) ;
    end
    if DataMax < dataarray(i) 
        DataMax = dataarray(i) ;
    end
%Next i 
end
%D_planar_extent = DataMax - DataMin 
D_planar_extent = DataMax - DataMin ;
%'desired planar extension in the running window 
%d50 = D_planar_extent * 0.5 
d50 = D_planar_extent * 0.5 ;
%'Search for all the consecutive segments of data with planar extension equal to d50 
%'the search starts from the first sample (Nstart=1) 
%NumberOfWindows = 0 
NumberOfWindows = 0 ;
%NStart = 1 
NStart = 1 ;
%Do While NStart < NData 
while true
    %DataMin = dataarray(NStart) 
    DataMin = dataarray(NStart) ;
    %DataMax = dataarray(NStart) 
    DataMax = dataarray(NStart) ;
    %Dcur = 0 
    Dcur = 0 ;
    %NFinestra = NStart 
    NFinestra = NStart ;
    %Do While (Dcur < d50 And NFinestra < NData) 
    while true
        %NFinestra = NFinestra + 1 
        NFinestra = NFinestra + 1;
        %If DataMin > dataarray(NFinestra) Then DataMin = dataarray(NFinestra) 
        
            if DataMin > dataarray(NFinestra) 
                DataMin = dataarray(NFinestra) ;
            end
       
        
        %If DataMax < dataarray(NFinestra) Then DataMax = dataarray(NFinestra) 
        if DataMax < dataarray(NFinestra) 
            DataMax = dataarray(NFinestra) ;
        end
        %Dcur = DataMax - DataMin 
        Dcur = DataMax - DataMin;
        if ~(Dcur < d50 && NFinestra < NData)
            break
        end
    %Loop 
    end
    %If Dcur > d50 Then 
    if Dcur > d50 
        %NumberOfWindows = NumberOfWindows + 1 
        NumberOfWindows = NumberOfWindows + 1 ;
        
        %ReDim Preserve WindowLengthArray(1 To NumberOfWindows) 
        %WindowLengthArray(NumberOfWindows) = NFinestra - NStart + 1 
        WindowLengthArray = reDimPreserve(WindowLengthArray, NFinestra - NStart + 1,NumberOfWindows);
        
    %End If 
    end
    %'Increment NStart to point to the starting sample of the next window 
    %NStart = NStart + (NFinestra - NStart)
    NStart = NStart + (NFinestra - NStart) ;
    if ~(NStart < NData)
        break
    end
%Loop 
end
%'Backward Search in case of a residual segment at the end of the array 
%If (Dcur < d50) Then 'Dcur <d50 means that there is a residual segment 
if (Dcur < d50) 
    %DataMin = dataarray(NData) 
    DataMin = dataarray(NData) ;
    %DataMax = dataarray(NData) 
    DataMax = dataarray(NData) ;
    %Dcur = 0 
    Dcur = 0 ;
    %NFinestra = NData 
    NFinestra = NData ;
    %Do While (Dcur < d50 And NFinestra > 1) 
    while true
        %NFinestra = NFinestra - 1 'Running Backward 
        NFinestra = NFinestra - 1 ;
        %If DataMin > dataarray(NFinestra) Then DataMin = dataarray(NFinestra) 
        
        if DataMin > dataarray(NFinestra)
            DataMin = dataarray(NFinestra) ;
        end
    
        %If DataMax < dataarray(NFinestra) Then DataMax = dataarray(NFinestra) 
        if DataMax < dataarray(NFinestra) 
            DataMax = dataarray(NFinestra) ;
        end
        %Dcur = DataMax - DataMin 
        Dcur = DataMax - DataMin ;
        
        if ~(Dcur < d50 && NFinestra > 1)
            break;
        end
    %Loop 
    end
    %If Dcur > d50 Then 
    if Dcur > d50 
        %NumberOfWindows = NumberOfWindows + 1 
        NumberOfWindows = NumberOfWindows + 1 ;
        %ReDim Preserve WindowLengthArray(1 To NumberOfWindows) 
        %WindowLengthArray(NumberOfWindows) = NData - NFinestra + 1 
        WindowLengthArray = reDimPreserve(WindowLengthArray,NData - NFinestra + 1,NumberOfWindows);
    %End If 
    end
%End If 
end
%'Average of all the identified windows with planar extension equal to d50 
%N1 = 0 
N1 = 0 ;
%For i = 1 To NumberOfWindows 
for i=1:NumberOfWindows
    %N1 = N1 + WindowLengthArray(i) 
    N1 = N1 + WindowLengthArray(i) ;
%Next i 
end
%NRunningWindow = Fix(N1 / NumberOfWindows) 
NRunningWindow = fix(N1 / NumberOfWindows) ;
%End Sub 
end

