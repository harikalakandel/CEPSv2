%What is wrong in katz's method? Comments on "A Note on fractal dimensions of biomedical waveforms"

%% for experiment we take some random data points
data = load('file_1.txt');

%% Now we add a time series in the data...
%% for now we consider each data points are recored in equal time interval let say 1 unit interval.
%% therefore time-series run from 1 to N
data=[[1:size(data,1)]' data];

%% number of pairs is n-1 (distance between points..)
%% ???? do we consider size(data) or size(data)-1 ?????
n=size(data,1)-1;

%%l_i_i+1
%% euclidean distance between two consusitive  points..
l_iplus = (sum((data(2:end,:)-data(1:end-1,:)).^2,2)).^(.5);
%% L 
%% is the sum of distance of all consusitive points
L=sum(l_iplus);


%% normalize 
%% ?? not sure if we need this
%data(:,2)=(data(:,2)-mean(data(:,1)))./(max(data(:,1))-min(data(:,1)))


%%get maximimum distance betwee two points ie max(max(l_ij)))
l_ij = pdist(data);
d = max(max(l_ij));
% d=-1;
% for i=1:size(data,1)-1
%     for j=i+1:size(data,1)
%        currDist = sum((data(i,:)-data(j,:)).^2)^(0.5);
%        if d < currDist
%            d=currDist;
%        end
%     end
% end
%% Katz's fractal dimension   --- considering the time series as one of the dimension..
%% equation 5
FDk =( log(n))/(log(n)+log(d/L))


%% Now we remove the time series
%% And consider the monodimensional space of yk (data)
%% ie not on the bi-dimensional sequence by associating tk to yk
%% removing the time value from data
%% mono-dimensional data
data = data(:,2);

%% equation 6
d = max(data(:,1))-min(data(:,1));
%% equaltion 7
L = sum(abs(data(2:end,1)-data(1:end-1,1)));
%% applying new d and L in equation 5
%% Mandelbrot's fractal dimension
FDm = ( log(n))/(log(n)+log(d/L))


%%% corrected...

%%% first,the extension d is calculated from the whole dataset of n points as in Eq.(6);second,  
%%  the dataset is scanned to identify the size nW of sequences of points with extension at least equal to d/2 
%% (in any case nW should not be lower than 8 samples for a minimal statistical consistency);
%% third,the dataset is split in to consecutive, overlapped windows of nW points, 
%% and the fractal dimension evaluated separately in each window by Eqs.(5)–(7);
%% and finally, the corrected FDm is obtained by averaging the fractal dimensions estimated in each window.
%% Let us call FDc this corrected estimate.

%% window size   
%% ---------------------- input from user
nw=21;
%% number of overlapping datapoint in each window 
%%% set it to 0 if no overlapping is required
%% --------------------    input from user
overLap = 5;

startNw=1;
nLoop = ceil(size(data,1)/(nw-overLap));
allFDm=[];

%%calculating FDm in each loop
for i=1:nLoop


    endNw=min(startNw+nw-1,size(data,1));
    currData = data(startNw:endNw,1);
    %% ??? not sure do we consier n or n-1 ???
    n=size(currData,1)-1;
    %% avoid the segment if the number of data points are less than 8 
    if n < 7
        break;
    end
    
    d = max(currData(:,1))-min(currData(:,1));
    L = sum(abs(currData(2:end,1)-currData(1:end-1,1)));
    
    
    
    
    FDm = ( log(n))/(log(n)+log(d/L));
    
    allFDm = [allFDm;FDm];
    
    %%for next round
    startNw=endNw-overLap+1;
end

% the corrected FDm is obtained by averaging the fractal dimensions estimated in each window
FDc = mean(allFDm)

