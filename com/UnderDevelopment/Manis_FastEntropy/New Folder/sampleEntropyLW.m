% Sample_entropy_lightweight.cpp
% ------------------------------
% 
% 
% // g++ -Wall -O2 -shared -fPIC sample_entropy_lightweight.cpp -o sample_entropy_lightweight_lib.so 
% 
% #include <stdlib.h>
% #include <math.h>


% typedef struct {
% 	double Dato;
% 	unsigned int p_ini;
% } d_o;


% int sort_function( const void *a, const void *b );


% extern "C" double light(double *x, int N, int m, double r)
% {

function[ans]= sampleEntropyLW(x,N,m,r)
	%int Nm = N-m;
    Nm = N-m;
    %int i,j,k,ii,jj;
    %int A=0,B=0;
    %% ??? Q6 I think A and B are used as count not index..
    A=0;
    B=0;
    
    d_o = struct('Dato',{},'p_ini',{});
    
	%int r_sup, i_inf, i_sup, i_mez;
	%double *X;
% 	double D_piu_r;
% 	d_o  *_D_ordinati;
    D_ordinati=d_o();
% 	int *originalPositions;


    %double sum=0.0;
    sum=0.0;
%     for(i=0; i<N; i++)
%         sum += x[i];
    for i=1:N
        sum=sum+x(i);
    end
    %double mean = sum/N;        
    %double standardDeviation=0.0;
    mean = sum/N;
    standardDeviation=0.0;
%     for (i=0; i<N; i++)
%         standardDeviation += (x[i]-mean)*(x[i]-mean);
        
     for i=1:N
         standardDeviation = standardDeviation+ (x(i)-mean)*(x(i)-mean);
     end
    standardDeviation = sqrt(standardDeviation/N);
    r=r*standardDeviation;
    
	
	%X = (double *)malloc(Nm*sizeof(double));
% 	for (i=0;i<Nm;i++) 
% 	{
% 		X[i]=x[i];
% 		for (j=1;j<m;j++)
% 			X[i]+=x[i+j];
% 	}
% 	
    for i=1:Nm
        X(i)=x(i);
        for j=2:m    %% ??? Q1 j index start  from 1 in c means j should start from 2 in matlab
            X(i)=X(i)+x(i+j);
        end
    end
	%_D_ordinati = (d_o *)malloc(Nm*sizeof(d_o));
% 	for(i=0; i<Nm; i++)
% 	{
% 		_D_ordinati[i].Dato=X[i];
% 		_D_ordinati[i].p_ini=i;
% 	}
	for i=1:Nm
        D_ordinati(i).Dato=X(i);
 		D_ordinati(i).p_ini=i;
    end
	%qsort((void *)_D_ordinati, (size_t)Nm, sizeof(d_o), sort_function);
    %https://uk.mathworks.com/matlabcentral/answers/397385-how-to-sort-a-structure-array-based-on-a-specific-field
    %% ??? Q2 using sorting from matlab instead of qsort used in the c++ file...
    [~,idx]=sort([D_ordinati.Dato]);
    D_ordinati=D_ordinati(idx);
	%originalPositions = (int *)malloc(Nm*sizeof(int));
	
% 	for(i=0; i<Nm; i++)
% 	{
% 		X[i]=_D_ordinati[i].Dato;
% 		originalPositions[i]=_D_ordinati[i].p_ini;
% 	}

    for i=1:Nm
        X(i)=D_ordinati(i).Dato;
 		originalPositions(i)=D_ordinati(i).p_ini;
    end

	%free(_D_ordinati);
	D_ordinati={};
    
% 	for(i=0; i<Nm; i++)
% 	{
    for i=1:Nm
%		D_piu_r=X[i]+m*r;
        D_piu_r=X(i)+m*r;
% 		if(D_piu_r >= X[Nm-1])
% 			r_sup=Nm-1;
% 		else 
% 		{
        if D_piu_r >= X(Nm) %% ??? Q3 Nm-1 index in c is Nm im matlab
            r_sup=Nm-1;
 		else 
% 			i_inf=i;
% 			i_sup=Nm-1;
 			i_inf=i;
            i_sup=Nm; %% ??? Q4 not sure is Nm-1 is used as index or value 
% 			while(i_sup-i_inf>1) 
% 			{
% 				i_mez=(i_inf+i_sup)>>1;
% 				if( X[i_mez] > D_piu_r )
% 					i_sup=i_mez;
% 				else
% 					i_inf=i_mez;
% 			}
% 			r_sup=i_inf;
            while i_sup-i_inf>1   
                %% i_mez=(i_inf+i_sup)>>1???
               
                %%??? Q5 I am using bitshift from matlab ..I have check with c++ compiler both gives same result
                i_mez = bitshift(i_inf+i_sup, -1);
 				if X(i_mez) > D_piu_r 
 					i_sup=i_mez;
 				else
 					i_inf=i_mez;
                end
            end
            r_sup=i_inf;
%		}
        end
%		ii=originalPositions[i];
        ii=originalPositions(i);
% 		for(j=i+1; j<=r_sup; j++) 
% 		{
% 			jj=originalPositions[j];
        for j=i+1:j<=r_sup
			
% 			for (k=0;k<m;k++)
% 				if (fabs(x[ii+k]-x[jj+k])>r)
% 					break;
% 			if (k==m)
% 			{
% 				B++;
% 				if (fabs(x[ii+m]-x[jj+m])<=r)
% 					A++;
% 			}
            for k=1:m
                if abs(x(ii+k)-x(ii+k))>r
                    break
                end
            end
            if k==m
                B=B+1;
                if  abs(x(ii+k)-x(ii+k))<=r
                    A=A+1;
                end
            end
            
%		}    
        end
%	}
    end

%     if (A*B==0)
%          return log((N-m)*(N-m-1));
%     else
%         return -log(1.0*A/B);    
    if A*B ==0
        
        %% ??? Q7 hope this is natural log.... 
        ans= log((N-m)*(N-m-1));
        return;
    else
        ans= -log(1.0*A/B); 
        return;
    end
%}
end


% int sort_function( const void *a, const void *b)
% {
% 	return ( ((d_o *)a)->Dato > ((d_o *)b)->Dato ) ? 1 : -1;
% }




