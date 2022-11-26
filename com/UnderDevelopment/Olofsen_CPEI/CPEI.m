% (1) Composite PE Index [Olofsen 2008]: Can user set not just m and r parameters, but also theshold as % of IQR?
%% no need of m or r
%% epz threshold is required

function [epei,pe1,pe2,p1tie,p2tie,pk12] = CPEI(y,epz)

%permutation Entroy - order set at 3
%% Input time series (y) and noise threshold epz
% Output all combinations of entropies for tau 1 vs tau 2 (including Kullback-Leibler )
% set epz to zero for no ties
% check data and initialize variables
ord=3;
sd=std(y);
pe1 =0;
pe2=0;
epei=0;
pk12=0;

if sd==0 % returns if nonsense data
    return;
end
% check and turn y vector to correct direction
csize = size(y,1);
if csize==1
    y=y';
end

ly = length(y);
% calculate pe for tau 1 and 2 -- and threshold = epz ------
e1=[];
e2=[];
p1=[];
p2=[];

permlist = perms(1:ord);
ctie1=0;
ctie2=0; % initial ties bin
ct1(1:length(permlist))=0;% init tau1 =1 bins
ct2(1:length(permlist))=0;% init tau1 =2 bins

for j=3:ly-2           %% j = ord : ly-(ord-1)
    seg = y(j-2:j+2); %% total segment j=4     j-3 : j+ 3    1 to 7
    seg1=[seg(2), seg(3), seg(4)];% seg for tau 1
    seg2=[seg(1), seg(3), seg(5)];% seg for tau 2   tau 3  seg(1)   seg(4)   seg(7)
    
    %% ???
    %% why a and iv is calculated 
    [a,iv]=sort(seg); % sort ordsize section of seg

    [a1,iv1]=sort(seg1); % sort ordsize section of seg1
    [a2,iv2]=sort(seg2); % sort ordsize section of seg2

    % get bins-epz and 6 other motifs for PE tau =1-------------------
    da1 = abs(diff(a1));% find differenence between points in the motif
    if (min(da1))<epz  % if < threshold add to 7th bin
        ctie1 = ctie1 +1;
    else
        for jj=1:length(permlist)
            if permlist(jj,:)-iv1==0
                ct1(jj)=ct1(jj)+1; % accumulates into the correct bin
            end
        end
    end % if min da1
    % repeats for tau = 2---------------------------------------
    da2 = abs(diff(a2));% find differenence between points in the motif
    if (min(da2))<epz  % if < threshold add to 7th bin
        ctie2 = ctie2 +1;
    else
        for jj=1:length(permlist)
            if permlist(jj,:)-iv2==0
                ct2(jj)=ct2(jj)+1; % accumulates into the correct bin
            end
        end
    end % if min da2
end






lenn = ly-5; %%effective length  %% ly - (ord +2)  ?????



p1=ct1/lenn;  %% normalizes to total area
p2=ct2/lenn;


ptie1 = ctie1/lenn;
ptie2 = ctie2/lenn;

ziz = find(p1>0); % handle p*log(p)=0
e1 = - sum(p1(ziz).*log(p1(ziz)));
ziz = find(p2>0); % handle p*log(p)=0
e2 = - sum(p2(ziz).*log(p2(ziz)));



if ptie1 >0
    etie1 = -ptie1 .* log(ptie1);
else
    etie1=0;
end
if ptie2 >0
    etie2 = -ptie2 .* log(ptie2);
else
    etie2=0;
end
p1tie = etie1;
p2tie = etie2;
pe1 = (e1+etie1)/log(7);  %% 2*ord +1
pe2 = (e2+etie2)/log(7);

epei = (e1+e2+etie1+etie2)/log(49);  %% (2*ord +1)^2
pk12 = - sum(pe2.*log(pe2./pe1));

end










