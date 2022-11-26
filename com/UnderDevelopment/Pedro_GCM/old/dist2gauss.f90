    
  implicit none
  
  integer*4      i,n
  real*8         x(1000000),p
  integer*4      ind(1000000)
  real*8        ,allocatable::y(:),prob(:)
  real*8         sqrt2
  character*100  s
  
  call getarg(1,s)
  
  
  
  sqrt2=dsqrt(2.0d0)
  
  if (index(s,'-h')/=0.or.index(s,'-H')/=0) then
   write(0,*) 
   write(0,*) ' Reads 1-column data from stdin and converts'
   write(0,*) ' its distribution into a N(0,1) '
   write(0,*) 
   write(0,*) ' Writes output to stdout'
   write(0,*) ' The number of data is sent to stderror'
   write(0,*) 
   stop
 endif  
   
  i=1 
  do 
    read(*,*,end=666,err=666) x(i)
    ind(i)=i
    i=i+1
  enddo 
  666 n=i-1
  
  write(0,*) n
  allocate(y(n))
  allocate(prob(n))
  
  
  !call sort(n,x(1:n))
  call risort2(n,x(1:n),ind(1:n)) 
   
    
  do i=1,n
    prob(ind(i))=1.d0*(i-0.5d0)/n
    p=1.d0*(i-0.5d0)/n
    y(ind(i))=inv_Norm(p)
    !write(*,'(i,2f14.8,i)') i,prob(ind(i)),y(ind(i)),ind(i)
  enddo 
  
  do i=1,n
    write(*,'(2f14.8,i)') y(i)
  enddo
   
  


contains

 
!******************************
 function inv_Norm(p)
   real*8     inv_Norm,x,p,x1,x2,eps,y1,y
   integer*4  n
 
   x1=-500
   x2=500
   eps=1.d-9  
     
   do while (abs(x1-x2)>eps)
     x=(x1+x2)/2
     y1=Norm(x1)-p
     y=Norm(x)-p
     if ((y1>=0.and.y<0).or.(y1<=0.and.y>0)) then
       x2=x
     else
       x1=x
     endif    
   enddo  
   inv_Norm=x
 
 end function inv_Norm
!****************************** 


!***********************
 function Norm(x)
   real*8  Norm,x,y
   y=x/sqrt2
   Norm=(1+erf(y))/2.d0
 end function Norm
!***********************

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SUBROUTINE risort2(n,cad1,cad2)

 integer*4  n,m,nstack
 parameter  (M=7,nstack=10000)
 real*8    ,dimension(:)::cad1
 integer*4 ,dimension(:)::cad2
 
 integer*4  i,ir,j,jstack,k,l,istack(nstack)
 real*8     a,b,temp
 integer*4  a2,b2,temp2
 
 jstack=0
 l=1
 ir=n
 
 1 if (ir-l<m) then
   do j=l+1,ir
     a=cad1(j)
	 a2=cad2(j)
     do i=j-1,1,-1
       if (cad1(i) <= a) goto 2
       cad1(i+1)=cad1(i)
	   cad2(i+1)=cad2(i)
     enddo 
     i=0
 2   cad1(i+1)=a

     cad2(i+1)=a2
   enddo
   if (jstack==0) then
     return               !************ salida del programa
   endif  
   ir=istack(jstack)
   l=istack(jstack-1)
   jstack=jstack-2
 else 
   k=(l+ir)/2
   temp=cad1(k)
   temp2=cad2(k)
   cad1(k)=cad1(l+1)
   cad1(l+1)=temp
   cad2(k)=cad2(l+1)
   cad2(l+1)=temp2
   
   if (cad1(l+1)>cad1(ir)) then
     temp=cad1(l+1)
     cad1(l+1)=cad1(ir)
     cad1(ir)=temp

	 temp2=cad2(l+1)
     cad2(l+1)=cad2(ir)
     cad2(ir)=temp2
   endif

   if (cad1(l)>cad1(ir)) then
     temp=cad1(l)
     cad1(l)=cad1(ir)
     cad1(ir)=temp

	 temp2=cad2(l)
     cad2(l)=cad2(ir)
     cad2(ir)=temp2
   endif
   if (cad1(l+1)>cad1(l)) then
     temp=cad1(l+1)
     cad1(l+1)=cad1(l)
     cad1(l)=temp

	 temp2=cad2(l+1)
     cad2(l+1)=cad2(l)
     cad2(l)=temp2
   endif   
   i=l+1
   j=ir
   a=cad1(l)
   a2=cad2(l)
3  continue
     i=i+1
   if (cad1(i)<a) goto 3
4  continue
     j=j-1
   if (cad1(j)>a) goto 4
   if (j<i)      goto 5
   
   temp=cad1(i)
   cad1(i)=cad1(j)
   cad1(j)=temp

   temp2=cad2(i)
   cad2(i)=cad2(j)
   cad2(j)=temp2

   goto 3
5  cad1(l)=cad1(j)          
   cad1(j)=a
   cad2(l)=cad2(j)          
   cad2(j)=a2
   jstack=jstack+2
   
   if (jstack>nstack) pause 'nstack too small in sort2'
   if (ir-i+1>=j-1) then
     istack(jstack)=ir
     istack(jstack-1)=i
     ir=j-1
   else
     istack(jstack)=j-1
     istack(jstack-1)=l
     l=i  
   endif
 endif  
 goto 1
 end subroutine risort2

!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
