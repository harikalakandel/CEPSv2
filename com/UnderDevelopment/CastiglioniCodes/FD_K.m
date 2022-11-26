function [FDk] = FD_K(data)
%What is wrong in katz's method? Comments on "A Note on fractal dimensions of biomedical waveforms"

%% for experiment we take some random data points
%data = load('file_1.txt');

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
end

