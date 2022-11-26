function [rcoef,maxmatss] = getGppAsym(fnam,dsrpo,minOrder, step, maxOrder,fig2)







%gppasym.m - generalized Poincare Plot analysis

%asymmetrical (j=1:jmax; k=1:kmax)
%Pearson coefficients (r) for each index combination (matrix element)
%r matrix asymmetry index
%



%fnam=input('enter filename with R peak positions:','s');
%eval(['load ' fnam])
%eval(['dsrpo=' fnam ';'])
%dsrpo=load('ECG_BC_c_25_8_hrv.txt');
[nrpo nch]=size(dsrpo);

%transpose a horizontal vector into vertical
if nch>1
    dsrpo=dsrpo';
    [nrpo nch]=size(dsrpo);
end

%kord=input('maximal GPP order:');
kord=maxOrder;

rcoef=nan(kord,kord);

%kpl=input('plotting of GPP for some index combinations (y/n):','s');
kpl='n';

pCol = nan(kord,kord);
rCol = nan(kord,kord);

 if kpl=='y'
    % plord=input('enter minimal, step and maximal order for GPP plotting:');
    % plvect=plord(1):plord(2):plord(3);
    plvect=minOrder:step:kord;
    
     nplord=length(plvect);
     figure
     hold on
 end
isubpl=0;
for iord=1:kord
    %disp(['orderi:' int2str(iord)])
    for jord=1:kord
        %disp(['orderj:' int2str(jord)])
        clear dsint1
        clear dsint2
        for i=iord+1:nrpo-jord
            %% dsint1(i-iord)=dsrpo(i)-dsrpo(i-iord);
            %% dsint2(i-iord)=dsrpo(i+jord)-dsrpo(i);

            dsint1(i-iord)=(dsrpo(i)-dsrpo(i-iord))/iord;
            dsint2(i-iord)=(dsrpo(i+jord)-dsrpo(i))/iord;


            %[i i-iord]
            %[i+jord i]
            %if i==nrpo-jord
            %pause
            %end
        end
           if kpl=='y'
            for iplord=1:nplord
             for jplord=1:nplord
              if (iord==plvect(iplord))&&(jord==plvect(jplord))
              isubpl=isubpl+1;
              %subplot(nplord,nplord,isubpl),plot(dsint1/iord,dsint2/jord,'.')
              subplot(nplord,nplord,isubpl),plot(dsint1,dsint2,'.')
              title([int2str(iord) ';' int2str(jord)])
              %plot(dsint1,dsint2,'.')
              end
             end
            end
           end
        %pausefnam
        if (iord==kord)&&(jord==kord)
            %figure
            %plot(dsrpo(i,1)-dsrpo(i-ired,1),dsrpo(i+jred,1)-dsrpo(i,1),'*')
            plot(fig2{1},dsint1,dsint2,'*');
        end
        [cc p]=corrcoef(dsint1,dsint2);
       
       

        rcoef(iord,jord)=cc(1,2);
        if (iord==kord)&&(jord==kord)
            text(fig2{1},0.1,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized');
            
            title(fig2{1},[fnam '; Poincare Plot order:' int2str(iord)]);
            xlabel(fig2{1},'GRRI(n-j:n) (sec)');
            ylabel(fig2{1},'GRRI(n:n+k) (sec)');
           %hold off
           hold(fig2{1},'off');
            %pause
        end
    end
end
%figure
mesh(fig2{2},rcoef);
%title([fnam])
xlabel(fig2{2},'k');
ylabel(fig2{2},'j');
%figure
contour(fig2{3},rcoef,30);
hold(fig2{3},'on');
%title([fnam])
xlabel(fig2{3},'k');
ylabel(fig2{3},'j');

%search for local maxima
iord=0;
%initial local maximum first i=1; j=1
if (rcoef(1,2)<rcoef(1,1))&&(rcoef(2,1)<rcoef(1,1))&&(rcoef(2,2)<rcoef(1,1))
    iord=iord+1;
    imax(iord)=1;
    jmax(iord)=1;
end
%search for other local maxima
for i=2:kord-1
    for j=2:kord-1
        if (rcoef(i-1,j)<rcoef(i,j))&&(rcoef(i+1,j)<rcoef(i,j))&&(rcoef(i,j-1)...
                <rcoef(i,j))&&(rcoef(i,j+1)<rcoef(i,j))&&(rcoef(i-1,j-1)<rcoef(i,j))...
                &&(rcoef(i+1,j+1)<rcoef(i,j))&&(rcoef(i-1,j+1)<rcoef(i,j))&&...
                (rcoef(i+1,j-1)<rcoef(i,j))
            iord=iord+1;
            imax(iord)=i;
            jmax(iord)=j;
        end
    end
end

%NAI
sabsa=0;
for j=1:kord
    for k=1:kord
        sabsa=sabsa+abs(rcoef(j,k));
    end
end
mabsa=sabsa/(kord*kord);
sai=0;
ssai=0;
for j=1:kord-1
    for k=j+1:kord
        sai=sai+rcoef(k,j)-rcoef(j,k);
        %pause
    end
end

NAI=sai/((kord*kord)*mabsa);

% disp(['      r max positions'])
% disp([' '])
% disp('      j         k          r')
% disp([' '])
for jord=1:iord
    %disp([imax(jred) jmax(jred) rcoef(imax(jred),jmax(jred))])
    maxmat(jord,:)=[imax(jord) jmax(jord) rcoef(imax(jord),jmax(jord))];
end
maxmats=sortrows(maxmat,3);
maxmatss=zeros(iord,3);
for jord=1:iord
    maxmatss(jord,:)=maxmats(iord-jord+1,:);
end


for jord=1:iord
    plot(fig2{4},jmax(jord),imax(jord),'+');
end
%ksav=input('save the Pearson matrix, local maxima and NAI (y/n):','s');
%  if ksav=='y'
%  fnamout=[fnam 'rmat' int2str(kord)];
%  eval(['save ' fnamout ' rcoef maxmatss nai'])
%  disp(['file saved:' fnamout '.mat'])
%  end

 
end






