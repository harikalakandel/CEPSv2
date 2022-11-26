%gppsym.m - generalized Poincare Plot analysis

%symmetrical (j=k)
%Pearson coefficient
%Guzik's paramters (DOI 10.1515/BMT.2006.054)
%SD1, SD2, Cup, Cdown
%time dependence of the generalized RRI(GRRI=summ of sequential RRIs)
%
clear
fig1=figure()
fig2 = figure()

%ax0=fig2.CurrentAxes;

ax1=subplot(221,'Parent',fig1)
ax2=subplot(222,'Parent',fig1)

ax3=subplot(223,'Parent',fig1)
ax4=subplot(224,'Parent',fig1)


ax0=axes('Parent',fig2)


fig={ax1,ax2,ax3,ax4};
fnam='ECG_BC_c_25_8_hrv';
%fnam=input('enter filename with R peak positions (sec):','s');
%eval(['load ' fnam])
%eval(['dsrpo=' fnam ';'])
dsrpo=load('ECG_BC_c_25_8_hrv.txt')
[nrpo nch]=size(dsrpo);

%transpose a horizontal vector into vertical
if nch>1
    dsrpo=dsrpo';
    [nrpo nch]=size(dsrpo);
end

%kord=input('maximal GPP order:');
kord = 100;
%kpl=input('plotting of GPP for each order (y/n):','s');
kpl='y'
dsqup=0;
dsqdown=0;
for iord=1:kord

%     %if kpl==('y')
%     if ~isobject(fig2)
%         %figure
%         %hold on
%         hold(fig2,'on')
%         %hold(fig0,'on')
%     end
    clear dsint1
    clear dsint2
    for i=iord+1:nrpo-iord
        dsint1(i-iord)=dsrpo(i)-dsrpo(i-iord);
        dsint2(i-iord)=dsrpo(i+iord)-dsrpo(i);
        %if iord==kord
        %[i i-iord]
        %dsint1(i-iord)
        %[i+iord i]
        %dsint2(i-iord)
        %pause
        %end
    end

    %if kpl=='y'
    if isobject(fig2)

        plot(ax0,dsint1,dsint2,'*')
    end
    [cc p]=corrcoef(dsint1,dsint2);
    rcoef(iord)=cc(1,2);
    %if kpl=='y'
    if isobject(fig2)
        text(ax0,0.2,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized')
        title(ax0,[fnam '; Poincare Plot order:' int2str(iord)])
        xlabel(ax0,'GRRI(n-k:n) (sec)')
        ylabel(ax0,'GRRI(n:n+k) (sec)')
        hold(ax0,'off')
        %hold off
        %pause
    end

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
plot(fig{1},dsint1,dsint2,'*')
hold on
hold(fig{1},'on')
plot(fig{1},projdir-mean(projdir)+mean(dsint1),projdir-mean(projdir)+mean(dsint2),'ro')
plot(fig{1},projper-mean(projper)+mean(dsint1),mean(dsint2)-(projper-mean(projper)),'ro')
plot(fig{1},[mean(dsint1)-sd1(kord) mean(dsint1)+sd1(kord)],...
    [mean(dsint2)-sd1(kord) mean(dsint2)+sd1(kord)],'k','LineWidth',3)
plot(fig{1},[mean(dsint1)-sd2(kord) mean(dsint1)+sd2(kord)]...
    ,[mean(dsint2)+sd2(kord) mean(dsint2)-sd2(kord)],'k','LineWidth',3)
text(fig{1},0.1,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized')
text(fig{1},0.1,0.85,['SD1=' num2str(sd1(kord)) '; SD2=' num2str(sd2(kord))],'units','normalized')
title(fig{1},[fnam '; Poincare Plot order:' int2str(iord)])
%title(['Poincare Plot order:' int2str(iord)])
xlabel(fig{1},'GRRI(n-k:n) (sec)')
ylabel(fig{1},'GRRI(n:n+k) (sec)')

%figure
plot(fig{2},1:kord,rcoef,'-')
xlabel(fig{2},'Poincare Plot order')
ylabel(fig{2},'Pearson coefficient')
title(fig{2},fnam)

%figure
plot(fig{3},1:kord,sd1,'-')
hold(fig{3},'on')
plot(fig{3},1:kord,sd2,'r-')
xlabel(fig{3},'Poincare Plot order')
ylabel(fig{3},'SD1 (blue); SD2 (red)')
title(fig{3},fnam)

%figure
plot(fig{4},1:length(c1),c1,'-')
hold(fig{4},'on')
plot(fig{4},1:length(c2),c2,'r-')
xlabel(fig{4},'Poincare plot order')
ylabel(fig{4},'C up (blue); C down (red)')
title(fig{4},fnam)
