function FRP = frp(x,dim,tau,cluster,T)
%------------------------------------------------------------------------
% Reference: T.D. Pham, Fuzzy recurrence plots, EPL (Europhysics Letters) 116 (2016) 50008.
% Acknowledgement: with programming assistance of Taishi Abe
%------------------------------------------------------------------------
% Input:
%       x: time series
%       dim: embedding dimension of a reconstructed phase space (default value: 3)
%       tau: time delay to reconstruct phase space (default value: 1)
%       cluster: number of clusters for fuzzy c-means clustering (default value: 2)
%       T: cuttoff fuzzy membership threshold to change grayscale to black and white.  If threshold
%       is not given, FRP takes grayscale values in [0 1].  (default value: NaN)
%
% Output:
%       FRP: Fuzzy recurrence plot 
% Test:
%       x1 = randi([0 5],1,500); dim=3; tau=1; cluster=3; T=0.5; 
%       FRP=frp(x1,dim,tau,cluster,T);
%       x2 = randi([0 255],1,500);
%       FRP=frp(x2);
%--------------------------------------------------------------
switch nargin
    case 1
        dim=3;
        tau=1;
        cluster=2;
        T=NaN;
    case 2
        tau=1;
        cluster=2;
        T=NaN;
    case 3
        cluster=2;
        T=NaN;
    case 4
        T=NaN;
end
    
[nRow,~] = size(x);

if (nRow==1)
    x = x';
    [nRow,~] = size(x);
end

M=nRow-(dim-1)*tau;
PS=zeros(M,dim);

for i=1:M
    for j=1:dim
        PS(i,j)=x(i+(j-1)*tau);
    end
end

[~, FR, ~] = fcm(PS, cluster); % use fuzzy c-means from Matlab toolbox

cRP=zeros(length(FR),length(FR),cluster);

for c=1:cluster
    for i=1:length(FR)
        for j=1:length(FR)
            if norm(PS(i,:) - PS(j,:)) == 0
                cRP(i,j,c)= 1; % reflexibility
            elseif FR(c,i)>=FR(c,j)    
                cRP(i,j,c)=FR(c,j);
            else
                cRP(i,j,c)=FR(c,i);
            end
        end
    end
end

FRP=zeros(length(cRP),length(cRP));
for c=1:cluster
    for i=1:length(cRP)
        for j=1:length(cRP)
            if c==1
                FRP(i,j)=cRP(i,j,c);
            else
                if cRP(i,j,c)>=FRP(i,j)
                    FRP(i,j)=cRP(i,j,c);
                end
            end
        end
    end
end

if ~isnan(T)
    FRP(FRP>=T)=1;
    FRP(FRP<T)=0;
end

FRP=imcomplement(FRP); % making dark pixels for recurrences

%%{
figure
imshow(FRP)
%print('frp', '-deps', '-r600');
%}


end




