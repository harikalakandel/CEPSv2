% inline void Fractals::lencalcE(double y[], int numero, double& largo,
function [largo]=lencalcE(y, numero,largo)

%         double& var_dely) {
%     int i;
%     double yant = 0, ymin, ymax, ytm;
      yant=0;

%     double& s_dely = largo; // sdely is the sum of the delta y,
      s_dely = largo;
%     // sdely is equivalent to the length
%     using namespace std;
%     double *dely = new double[numero - 1];
      dely = nan(numero-1,1);
% 
%     ymax = ymin = y[0];
      ymax=y(1);
      ymin=y(1);
%     for (i = 1; i < numero; i++) {
%         ymax = max(y[i], ymax);
%         ymin = min(y[i], ymin);
%     }
      for i=1:numero-1
          ymax=max(y(i+1),ymax);
          ymin=min(y(i+1),ymin);
      end
% 
%     /* The way to calculate mean dely and var_dely was choosen to avoid
%      * subtractive cancellation and related errors when squaring and adding
%      * small numbetrs
%      */
% 
%     double delx2 = sqr(1.0 / double (numero));
      delx2=(1/numero)^(0.5);
%     double dif_maxmin = ymax - ymin;
      dif_maxmin=ymax-ymin;
%     int k = 0;
      k=0;
%     if (ymin != ymax) {
      if ymin ~=ymax
%         s_dely = largo = 0;
          s_dely = 0;
          largo = 0;
%         for (i = 0; i < numero; i++) {
          for i=0:i<numero
%             if (i > 0) {
                if i>0
%                 ytm = (y[i] - ymin) / dif_maxmin;
                    ytm = (y(i+1)-ymin)/dif_maxmin;
%                 dely[k] = sqrt(sqr(ytm - yant) + delx2);
                    dely(k+1)=((ytm-yant)^(0.5)+delx2)^(0.5);
%                 largo += dely[k++];
                  largo=largo+dely(k+1);
                  k=k+1;
%                 yant = ytm;
                  yant = ytm;
%             } else {
                else
%                 yant = (y[i] - ymin) / dif_maxmin;
                    yant = ( y(i+1)-ymin)/dif_maxmin;
%             }
                end
%         }
          end
%         double media = 0;
          media = 0;
% 
%         media = Media(dely, k);  
          
          media = median(dely,k);
% 
%         var_dely = 0;
          var_dely = 0;
%         for (i = 0; i < k; i++)
          for i=0:i<k
          
%             var_dely += sqr(dely[i] - media);
              var_dely = var_dely + (dely(i+1)-media)^(0.5);
          end
%         var_dely /= k - 1;
          var_dely = var_dely/(k-1);  
% 
%         // The number of segments is
%         // the number of points minus 1
%     } else {
      else
                
%         largo = 1;
        largo =1;
%         var_dely = 0;
        var_dely = 0;
%     }
      end
%     delete [] dely;
      clear dely
%     
% } // ***** End of lencalc *****
end
% 
% // ******************* Start of variance *************************************
% // Routine to calculate de ariance of D
% 
% inline double Fractals::variance_D(double var_dely, double length, int num) {
%     return (var_dely * (num - 1) / sqr(log(double(2 * (num - 1))) * length));
% }
function [ans]=variance_D(var_dely,length,num)
     ans =(var_dely * (num - 1) / (log(double(2 * (num - 1))) * length)^(0.5));
end
% 
% // *********** End of variance **********************************************
% 
% // *********** Start of D **************************************************
% 
% // which calculates CS fract dimension from the "contortenes" Q
% 
% /* Here "contortedness is used as indicated in:
% 
%       @Article{DSuze2010a,
% 	author = {G. D{\textquoteright}Suze and C. Sevcik},
% 	title = {Scorpion Venom Complexity Fractal Analysis. {I}ts Relevance for Comparing Venoms},
% 	journal = {J. Theoret. Biol.},
% 	year = {2010},
% 	volume = {267},
% 	pages = {405--416},
% 	note = {doi:10.1016/j.jtbi.2010.09.009},
%       }
% */
% 
% inline double Fractals::D(double largo, int num) {
%     // *** Calculates the Fractal Dimension
%     return 1 + Q(largo, num);
% } // *** End of D
% 
function [ret]=D(largo, num)
    ret = 1+Q(largo,num);
end
% // *********** End of D ******************************************************
% 
% 
% // ************** Starts Q *************************************************
% 
% /* Here "contortedness is used as indicated in:
% 
%       @Article{DSuze2010a,
% 	author = {G. D{\textquoteright}Suze and C. Sevcik},
% 	title = {Scorpion Venom Complexity Fractal Analysis. {I}ts Relevance for Comparing Venoms},
% 	journal = {J. Theoret. Biol.},
% 	year = {2010},
% 	volume = {267},
% 	pages = {405--416},
% 	note = {doi:10.1016/j.jtbi.2010.09.009},
%       }
% */
%  
% inline double Fractals::Q(double largo, int num) {
%     // *** Calculates the Contortedness
% #ifdef ECU6A
%     return (log(largo / 2.0) / log(double (2.0 * (num - 1))));
% #endif
% #ifdef ECU6
%     return log(largo) / log(double (2.0 * (num - 1)));
% #endif
% } 
% 
function [ans]=Q(largo,num)
    if EUC6A
        ans = (log(largo / 2.0) / log(double (2.0 * (num - 1))));
    end
    
    if ECU6
        ans = log(largo) / log(double (2.0 * (num - 1)));
    end
end
% // ****************** End of Q *****************************************
% 
% 
% 
% end
% 
