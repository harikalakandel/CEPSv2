function PSSP=PhaseSpaceSymPlot(x1,x2,type,epsilon1,epsilon2);

% x1=[0 1 2 1 0 -1 -2 -1 0 1 2];epsilon1=0.01;
% x2=[2 1 0 -1 -2 -1 0 1 2 1 0];epsilon2=0.01;
% plot(x1);hold on;plot(x2,'r')
% type='V';
% PSSP=PhaseSpaceSymPlot(x1,x2,type,epsilon1,epsilon2);

N=length(x1);

switch type
            case 'S';X=[x1' x2'];
            case 'O';X=[x1' -x2'];
            case 'H';X=[-x1' -x2'];
            case 'V';X=[-x1' x2'];
end
        
PSSP=zeros(N,N);
for i=1:N;
    
Y=[repmat(x1(i),1,N)' repmat(x2(i),1,N)'];
D=abs(X-Y);
Ind=find( D(:,1) < epsilon1 & D(:,2) < epsilon2);
PSSP(i,Ind)=1;
end


%figure;spy(PSSP)