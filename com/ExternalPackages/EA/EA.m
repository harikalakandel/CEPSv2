function [EoE, AE] = EA(data,scale,bins,min,Max)
%Inputs:
%data : 1*n time series
%scale : a one given scale for multi-scale process
%bins : the amount of states for Shannon entropy. These states will range between the "min" to "Max" defined below.
%min : self-setting min value of state definition for Shannon entropy
%Max : self-setting max value of state definition for Shannon entropy
%Outputs:
%buf : 1*n shannon entropy series of the given scale, it's the 1st stage results of EoE 
%        note : buf are composed by many shannon entropys of every short pieces of data, from which the piece length is decided by the given scale
%        note : the states of Shannon entropy here is defined by the parameters of bins,min and Max
%E : 1*1 (sShannon) entropy of  (Shannon) entropy, it's the 2nd stage results of EoE 
%     note : Shannon entropy of the outcome buf under the given scale
%     note : the states of Shannon entropy here is defined by the property of buf automatically 

% Explination :
% If data is the RR intervals from heart beats, the reasonable state min value  is 0.3 sec and Max value is 1.6 sec.
% Then I would like to have 55 states between the min value and Max value.
% This means : bins=55, min=0.3, Max=1.6
% So the code for EoE analysis (scale 5) of RR interval (data) series will be like : [buf, E]=EoE(data,5,55,0.3,1.6)
% this analysis is valid for both short (~500 data points) and long (~10,000)  series

% Example :
% Just as the explnation above, I want to calculate the EoE from scale 1 to 20. The code will be like:
% eoe=[];
% for i=1:20
%    [buf, E]=EoE(data,i,55,0.3,1.6);
%   eoe=[eoe, E];
% end

buf = array(data,scale,bins,min,Max); % coarse-grained data, it's the 1st stage results of EoE
EoE = ShannonEn_2nd(buf); % the output EoE value, it's the 2nd stage results of EoE
AE = mean(buf);


function buf = array(data,scale,bins,min,Max)
N = length(data);
for i = 1:fix(N/scale)
    buf(i)=ShannonEn_1st(data((i-1)*scale+1:i*scale),bins,min,Max);
end

function SE1 = ShannonEn_1st(data,bins,min,Max)
edges = [min:(Max-min)/bins:Max];
c=[];
for i=1:length(edges)-1
    pos=find((data>=edges(i))&(data<edges(i+1)));
    c=[c,length(pos)];
end
for i = 1:length(c)
	if c(i) ~= 0
        j(i)=-c(i)/length(data)*log(c(i)/length(data));        
    else
        j(i)=0;
    end     
end
SE1 = sum(j);

function SE2 = ShannonEn_2nd(buf)
% Since the coars-grained series (buf) is already quantized by the ShannonEn_1st, we don't set "bins" for ShannonEn_2nd.
% the states of Shannon entropy (ShannonEn_2nd) here is defined by the property of buf automatically
buf2=[sort(buf),-1];
pos2=0; 
for i=1:length(buf2)-1
    if buf2(i)~=buf2(i+1);
        pos2=[pos2,i];
    else
        pos2=pos2;
    end
end
c2=diff(pos2); 
% note : c2 is used to defined the states automatically
% note : length(c2)=how many kinds of Shannon entropy values in buf.
% note : c2(1)=the amount of element with one certain Shannon entropy values in buf.
% note : c2(2)=the amount of element with another certain Shannon entropy values in buf.
for i = 1:length(c2)
	if c2(i) ~= 0
        j(i)=-c2(i)/length(buf)*log(c2(i)/length(buf)); 
    else
        j(i)=0;
    end     
end
SE2 = sum(j);