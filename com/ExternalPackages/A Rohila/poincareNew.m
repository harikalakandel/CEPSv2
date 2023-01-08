function [ SD1up,SD1dn,SD2up,SD2dn,SDNNup,SDNNdn,C1a,C1d,C2a,C2d ] = poincareNew( data )
%

%%
[xrow xcol] = size(data);
if ~isvector(data)
    disp('data should be a vector');
end

if xrow > xcol                          % converting data into column vector
    data = data';
end

%%
    data1 = data(1:end-1);
    data2 = data(2:end);   
    
x1 = (data1 - data2)/sqrt(2);
x2 = (data1 + data2)/sqrt(2);

%     temp = atan(x2./x1);
%     temp1 = (temp-pi/4);
    temp2 = 1:length(x1);
    ALI = temp2(x1>0);
    BLI = temp2(x1<0);

SD1 = sqrt(var(x1));
SD2 = sqrt(var(x2));

SD1up = sqrt(var(x1(ALI)));
SD1dn = sqrt(var(x1(BLI)));

SD2up = sqrt(var(x2(ALI)));
SD2dn = sqrt(var(x2(BLI)));

SDNNup = sqrt(SD1up^2 + SD2up^2);
SDNNdn = sqrt(SD1dn^2 + SD2dn^2);

C1a = (SD1up^2)/(SD1^2);
C1d = (SD1dn^2)/(SD1^2);

C2a = (SD2up^2)/(SD2^2);
C2d = (SD2dn^2)/(SD2^2);
end
