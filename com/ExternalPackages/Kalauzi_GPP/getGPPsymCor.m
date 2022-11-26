function [sd1,sd2,c1,c2,pCol,rCol] = getGPPsym(fnam,dsrpo,maxOrder,fig2)


pCol=[];
rCol=[];

%gppsym.m - generalized Poincare Plot analysis

%symmetrical (j=k)
%Pearson coefficient
%Guzik's paramters (DOI 10.1515/BMT.2006.054)
%SD1, SD2, Cup, Cdown
%time dependence of the generalized RRI(GRRI=summ of sequential RRIs)
%corrected version - averaging instead of summing
%%
%clear

%fnam=input('enter filename with R peak positions (sec):','s');
%eval(['load ' fnam])
%eval(['dsrpo=' fnam ';'])
%dsrpo=load('ECG_BC_c_25_8_hrv.txt')
[nrpo nch]=size(dsrpo);

%transpose a horizontal vector into vertical
if nch>1
    dsrpo=dsrpo';
    [nrpo nch]=size(dsrpo);
end

%kord=input('maximal GPP order:');
kord = maxOrder;
%kpl=input('plotting of GPP for each order (y/n):','s');
kpl='y';
dsqup=0;
dsqdown=0;
for iord=1:kord

    
    clear dsint1
    clear dsint2
    for i=iord+1:nrpo-iord
        %%replaced code for corrected version
        %% dsint1(i-iord)=dsrpo(i)-dsrpo(i-iord);
        %% dsint2(i-iord)=dsrpo(i+iord)-dsrpo(i);

        dsint1(i-iord)=(dsrpo(i)-dsrpo(i-iord))/iord;
        dsint2(i-iord)=(dsrpo(i+iord)-dsrpo(i))/iord;



        %if iord==kord
        %[i i-iord]
        %dsint1(i-iord)
        %[i+iord i]
        %dsint2(i-iord)
        %pause
        %end
    end

    
    [cc p]=corrcoef(dsint1,dsint2);
    %pCol=[pCol;p(1,2)];
    %rCol =[rCol;cc(1,2)];
    rcoef(iord)=cc(1,2);
    

    %Cup and Cdown
    ndsint=length(dsint1);
    clear dsqup
    clear dsqdown
    clear projdir
    clear projper
    iup=0;
    idown=0;

    for idsint=1:ndsint
        if dsint1(idsint)<=dsint2(idsint)
            iup=iup+1;
            dsqup(iup)=(dsint1(idsint)-dsint2(idsint))^2/2;
        elseif dsint1(idsint)>dsint2(idsint)
            idown=idown+1;
            dsqdown(idown)=(dsint1(idsint)-dsint2(idsint))^2/2;
        end
        projdir(idsint)=(dsint1(idsint)+dsint2(idsint))/2;
        projper(idsint)=(dsint1(idsint)-dsint2(idsint))/2;
        %pause
    end
    if exist('dsqup')&&exist('dsqdown')
        sumdsqup=sum(dsqup);
        varup(iord)=sumdsqup/ndsint;
        sumdsqdown=sum(dsqdown);
        vardown(iord)=sumdsqdown/ndsint;
        c1(iord)=varup(iord)/(varup(iord)+vardown(iord));
        c2(iord)=vardown(iord)/(varup(iord)+vardown(iord));
    end
    sd1(iord)=std(projdir);
    sd2(iord)=std(projper);
end

%figure
plot(fig2{1},dsint1,dsint2,'*')
hold(fig2{1},'on')
plot(fig2{1},projdir-mean(projdir)+mean(dsint1),projdir-mean(projdir)+mean(dsint2),'ro')
plot(fig2{1},projper-mean(projper)+mean(dsint1),mean(dsint2)-(projper-mean(projper)),'ro')
plot(fig2{1},[mean(dsint1)-sd1(kord) mean(dsint1)+sd1(kord)],...
    [mean(dsint2)-sd1(kord) mean(dsint2)+sd1(kord)],'k','LineWidth',3)
plot(fig2{1},[mean(dsint1)-sd2(kord) mean(dsint1)+sd2(kord)]...
    ,[mean(dsint2)+sd2(kord) mean(dsint2)-sd2(kord)],'k','LineWidth',3)

text(fig2{1},0.1,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized')
text(fig2{1},0.1,0.85,['SD1=' num2str(sd1(kord)) '; SD2=' num2str(sd2(kord))],'units','normalized')
title(fig2{1},[fnam '; Poincare Plot order:' int2str(iord)])
%title(['Poincare Plot order:' int2str(iord)])
xlabel(fig2{1},'GRRI(n-k:n) (sec)')
ylabel(fig2{1},'GRRI(n:n+k) (sec)')

%figure
plot(fig2{2},1:kord,rcoef,'-')
xlabel(fig2{2},'Poincare Plot order')
ylabel(fig2{2},'Pearson coefficient')
title(fig2{2},fnam)

%figure
plot(fig2{3},1:kord,sd1,'-')
hold(fig2{3},'on')
plot(fig2{3},1:kord,sd2,'r-')
xlabel(fig2{3},'Poincare Plot order')
ylabel(fig2{3},'SD1 (blue); SD2 (red)')
title(fig2{3},fnam)

%figure
plot(fig2{4},1:length(c1),c1,'-')
hold(fig2{4},'on')
plot(fig2{4},1:length(c2),c2,'r-')
xlabel(fig2{4},'Poincare plot order')
ylabel(fig2{4},'C up (blue); C down (red)')
title(fig2{4},fnam)




end

