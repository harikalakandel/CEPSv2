function [ Df,x,y,LARE ] = HFD_LCALC( data,varargin)
%HFD_LCALC calculates the Curve Lengths for various series of curves
%obtained from the input data
%   Based on Higuchi Fractal Dimension Algorithm, Df (fractal dimension)
%   can be calculated from L(k)~k^(-Df).
%   This program calculated L(k) for various k=1 to kmax
%INPUT ARGUMENTS:
%   data: Mandatory argument and should be row vector. If not, it will be
%         converted to row vector
%   kmax: If not specfied takes floor(length(data)/2) by default. If
%         specified it should be less or equal to floor(length(data)/2).
%         Else it takes the default value. (It should be an integer).


%Error check and Intialize the variables, arrays
nVar=length(varargin);
if(nVar>1)
    error('Too many Inputs::Expects only input data and optional kmax');
end
[r c]=size(data);
if (r>1)
    fprintf('Converting input data to a row vector\n');
    data=data(:)';% data needs to be a vector
end
L=length(data);
kmax=[];
if (nVar==1)
    kmax=varargin{1};
end
[r c]=size(kmax);
if((r~=1) || (c~=1) || (isnumeric(kmax)==0) || (kmax>floor(L/2)) || (kmax<1))
    kmax=floor(L/2);
    fprintf('kmax is not chosen a proper value. Changing kmax= %d\n',kmax);
end
LARE=zeros(1,kmax);%LARE stores the length of curves L(k) for k=1:kmax
y=zeros(1,kmax);%this is to store y=log(LARE)
x=zeros(1,kmax);%this is to store x=log(1/k)

for k=1:kmax
    LAk=0;
    for i=1:k
        LAi=0;
        for j=1:floor((L-i)/k)        
            LAi=LAi+abs(data(i+j*k)-data(i+(j-1)*k));
        end
        a=(L-1)/(floor((L-i)/k)*k);
        LAk=LAk+LAi*a/k;
    end
    LARE(k)=LAk/k;
    y(k)=log(LARE(k));
    x(k)=log(1/k);
    %%%% Important:: Uncomment the step i.e disp(k) while running for huge
    %%%% loops. As ctrl+c can work good to break the loop if uncommented .
    %%%% If it is commented, there is hard chance to break. Uncommenting
    %%%% will produce lot of output k=1:kmax.
    %disp(k)
end
% Create figure
figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');
plot(x,y)
title('Plot Log(1/k) vs Log(L(k))')
xlabel('Log(1/k)')
ylabel('Log(L(k))')
Df=(kmax*sum(x.*y)-sum(x)*sum(y))/(kmax*sum(x.*x)-sum(x)*sum(x));
str=['Df=',num2str(Df)];
annotation(figure1,'textbox',...
    [0.8375 0.9262 0.1518 0.0667],...
    'String',{str},...
    'FitBoxToText','on');

%using polyfit 
%coef=polyfit(x,y,1);
%Df=coef(1);
end