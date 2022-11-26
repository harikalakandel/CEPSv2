%gppsym.m - generalized Poincare Plot analysis

%symmetrical (j=k)
%Pearson coefficient
%Guzik's paramters (DOI 10.1515/BMT.2006.054)
%SD1, SD2, Cup, Cdown
%time dependence of the generalized RRI(GRRI=summ of sequential RRIs)
%
clear
%fnam=input('enter filename with R peak positions (sec):','s');

fnam='testGPPSym';


% eval(['load ' fnam])
% eval(['dsrpo=' fnam ';'])
dsrpo = load('file_1.txt');
[nrpo nch]=size(dsrpo);

%transpose a horizontal vector into vertical
 if nch>1
 dsrpo=dsrpo';
 [nrpo nch]=size(dsrpo);
 end
 
%kord=input('maximal GPP order:');
kord = 3;
%kpl=input('plotting of GPP for each order (y/n):','s');
kpl = 'y';
dsqup=0;
dsqdown=0;
 for iord=1:kord
 
  if kpl==('y')
  figure(1)
  hold on
  end
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
  
  if kpl=='y'
  plot(dsint1,dsint2,'*')
  end
 [cc p]=corrcoef(dsint1,dsint2);
 rcoef(iord)=cc(1,2);
  if kpl=='y'
  text(0.2,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized')
  title([fnam '; Poincare Plot order:' int2str(iord)])
  xlabel('GRRI(n-k:n) (sec)')
  ylabel('GRRI(n:n+k) (sec)')
  hold off
  pause
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
 
figure(2)
plot(dsint1,dsint2,'*')
hold on
plot(projdir-mean(projdir)+mean(dsint1),projdir-mean(projdir)+mean(dsint2),'ro')
plot(projper-mean(projper)+mean(dsint1),mean(dsint2)-(projper-mean(projper)),'ro')
plot([mean(dsint1)-sd1(kord) mean(dsint1)+sd1(kord)],...
    [mean(dsint2)-sd1(kord) mean(dsint2)+sd1(kord)],'k','LineWidth',3)
plot([mean(dsint1)-sd2(kord) mean(dsint1)+sd2(kord)]...
    ,[mean(dsint2)+sd2(kord) mean(dsint2)-sd2(kord)],'k','LineWidth',3)
text(0.1,0.9,['r=' num2str(cc(1,2)) '; p=' num2str(p(1,2))],'units','normalized')
text(0.1,0.85,['SD1=' num2str(sd1(kord)) '; SD2=' num2str(sd2(kord))],'units','normalized')
title([fnam '; Poincare Plot order:' int2str(iord)])
xlabel('GRRI(n-k:n) (sec)')
ylabel('GRRI(n:n+k) (sec)')

figure(3)
plot(1:kord,rcoef,'-')
xlabel('Poincare Plot order')
ylabel('Pearson coefficient')
title(fnam)

figure(4)
plot(1:kord,sd1,'-')
hold on
plot(1:kord,sd2,'r-')
xlabel('Poincare Plot order')
ylabel('SD1 (blue); SD2 (red)')
title(fnam)

figure(5)
plot(1:length(c1),c1,'-')
hold on
plot(1:length(c2),c2,'r-')
xlabel('Poincare plot order')
ylabel('C up (blue); C down (red)')
title(fnam)
