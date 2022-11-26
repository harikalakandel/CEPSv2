function [ c ] = split(data,k )
%SPLIT function splits the series of N-data point to k series 
%   split(data,k) is the function that splits the series of N-data point to
%   k series and returns in the form of cell. 
%   To have proper calculation in further steps prefer
%   k=floor(length(data/2)


data=data(:)';% data is converted to a row vector
L=length(data);
if(k>L)
    error('k should be less than length of data')
end
c=cell(1,k);
for i=1:k
    l=floor((L-i)/k)+1;
    t=zeros(1,l);    
    for j=1:l
        t(j)=data(i+(j-1)*k);
    end
    c{i}=t;
end      
    
end

