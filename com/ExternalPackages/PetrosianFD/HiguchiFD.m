%import numpy


%def hfd(X, Kmax):

function[ans]= HiguchiFD(X,Kmax)
     if size(X,1)<size(X,2)
         X=X';
     end
%    """ Compute Higuchi Fractal Dimension of a time series X. kmax
%      is an HFD parameter
%     """
      fprintf("\nI am here")
      
%     L = []
      L=[];
%     x = []
      x=[]
%     N = len(X)
      N = size(X,1)
%     for k in range(1, Kmax):  %% range will start from 1 and end to Kmax-1
      for k=1:Kmax-1
          fprintf("\nk = %d",k)
%         Lk = []
          Lk=[];
%         for m in range(0, k):
          for m =0:k-1
              fprintf("\nm = %d",m)
%             Lmk = 0
              Lmk = 0.0;
              fprintf("\nchk Value ::%d",uint8(floor((N - m) / k)))
%             for i in range(1, int(numpy.floor((N - m) / k))):
              uLimit = uint8(floor((N - m) / k))
              for i =1:uLimit-1
                  fprintf("\ni : %d",i)
%                 Lmk += abs(X[m + i * k] - X[m + i * k - k])
                  Lmk = Lmk+ abs(X((m + i * k) +1 ) - X((m + i * k - k)+1))
                  if Lmk > 0
                      kkk=1
                  end
                  fprintf("\nLmk %d",Lmk)
              end
%             Lmk = Lmk * (N - 1) / numpy.floor((N - m) / float(k)) / k
              Lmk = Lmk * (N - 1.0) / floor((N - m) / k) / k
              fprintf("\nLmK ::: %d",Lmk)
%            
%             Lk.append(Lmk)
              Lk=[Lk;Lmk];
              fprintf("\nLk :: %d",Lk)
          end
%         L.append(numpy.log(numpy.mean(Lk)))
          L= [L;log(mean(Lk))];
%         x.append([numpy.log(float(1) / k), 1])
          x = [x;([log(1/ k), 1])];
      end
% 
%     (p, _, _, _) = numpy.linalg.lstsq(x, L)
      p=x\L
%     return p[0]
      ans = p(0+1);
end



      