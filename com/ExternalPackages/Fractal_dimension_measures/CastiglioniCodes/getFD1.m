%DECLARE SUB DataInput (x!, y!, N%)
%function DataInput(x,y,N)

function[D]= getFD1(x,y)
%DIM x!(300), y!(300)
%CLS
%PRINT "Fractal Dimension of Waveforms": PRINT
fprint('Fractal Dimension of Waveforms');
% PRINT "Steps (N)", " x", " y", " D": PRINT
fprint('Steps (%d) %d  %d  ',N,x,y);
% ' ******** Get Initial Values **************
% N% = 1
N=1;
% Length! = 0
Length=0
% CALL DataInput(x!(N%), y!(N%), N%)
%DataInput(x,y,N);
% PRINT, " -,
% ymax! = y!(1)
ymax = y(1)
% ymin! = y!(1)
ymin=y(1)
% ' *** Loop to Calculate Fractal Dimension ****
% DO
while True
% N% = N% + 1
N=N+1
% CALL DataInput(x!(N%), y!(N%), N%) ' ***** Data enter here *****
DataInput(x,y,N)
% IF (y!(N%) >= ymax!) THEN ymax! = y!(N%)
if y(N)>ymax 
    ymax = y(N)
end
% IF (y!(N%) <= ymin!) THEN ymin! = y!(N%)
if y(N)<=ymin
    ymin=y(N)
end
% CALL LenCalc(y!(), ymin!, ymax!, N%, Length!)
Length=LenCalc(y,ymin,ymax,N,Length)
% D! = 1 + (LOG(Length!)-LOG(2)) / LOG(2*(N% - 1))
D = 1+(log(Length)-log(2))/log(2*(N-1))

% PRINT, D!
% LOOP WHILE (N% <= 300)
if ~(N<=300)
    break
end
end



% END ' ***** End of Main Program *****
% SUB DataInput (x!, y!, N%) ' ***** Subroutine for Data Input *****
function DataInput(x,y,N)
% PRINT N%;
% PRINT , ;
% INPUT ; x!
% PRINT , ;
% INPUT ; y!
% END SUB ' ***** End of Data Input *****
end



% ' ****** LenCalc; Subroutine that Calculates the Normalized Length of the Waveform
% SUB LenCalc (y!(), ymin!, ymax!, N%, Length!)
    function[Length]= LenCalc(y,ymin,ymax,N)
% IF N% = 1 THEN
if N == 1 
% PRINT, " -"
    disp(" - ");
% ELSE
    else
% Length! = 0
    Length=0;
% FOR i% = 1 TO N%
    for i=1:N
% y! = (y!(i%) - ymin!) / (ymax! - ymin!)
        y = (y(i)-ymin)/(ymax-ymin)
% IF (i% > 1) THEN Length! = Length! + SQR((y! - yant!) ˆ 2 + (1! / (N% - 1)) ˆ 2)
        if i > 1
            Length = Length + ((y-yant)^2+(1/(N-1))^2)^0.5;
        end
        
% yant! = y!
        yant = y;
   
% NEXT i%
    end
% END IF
end
% END SUB ' ***** End of LenCalc *****
end


