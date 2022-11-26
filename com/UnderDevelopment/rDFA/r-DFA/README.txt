        ===================================
        +++++++++++++++++++++++++++++++++++
        ===================================
                                       
                   ____   _____  _____ 
         ___  ___ |    \ |   __||  _  |
        |  _||___||  |  ||   __||     |
        |_|       |____/ |__|   |__|__|
                                       
        
        ===================================
        +++++++++++++++++++++++++++++++++++
        ===================================
        
               Version 1.0 31/10/2016


________________________________________________________________________________
Citation:


When using this package, or any of its functions, cite using the following 
information:

r-DFA MATLAB Package, Version 1.0, MATLAB File Exchange, Abrar Habib, 
October 2016.

________________________________________________________________________________
What is this?


This MATLAB package is used to perform Robust Detrended Fluctuation Analysis 
(herein referred to as r-DFA). r-DFA is a procedure that feeds the results of the 
regular DFA (as explained in [1]) to a series of statistical models in order to 
determine a robust estimate of the global scaling exponent using Robust Regression, 
and to determine crossovers that produce statistically significant scaling 
exponents using Piecewise Linear Regression (a modification of Guido Albertin’s – 
2013 PLR.m), ANCOVA and Multiple Comparison Procedure.

In addition to that, r-DFA implements the method proposed by Kantelhardt in [2] 
in order to provide a systematic way of assessing crossovers by selecting those 
that persist across higher order DFA. The method in [2] also involves modifying 
the DFA results with the aid of surrogate versions of the original dataset in 
order to correct for the bias introduced at smaller scales when studying higher 
order DFA.

The code can perform up to a DFA order of 6 (DFA orders higher than 6 are not 
recommended [2]). Furthermore, it can be used to study higher order moments of the 
fluctuation of the series (i.e. to perform MF-DFA). 

Piecewise linear regression (PLR) is used to optimise the location of crossovers, 
the number of which is predefined. ANCOVA and multiple comparison procedure, built 
in the PLR function, determine the statistical significance of the slopes produced 
by the placement of crossovers. This is performed by collectively testing the 
statistical difference of the slopes. This in turn helps determine whether or not 
the chosen number of crossovers is the best choice. 

Finally, in case of a mono-fractal series (i.e. when there are no crossovers), 
robust regression [3] (as opposed to the regular least squares method) is used to 
determine a 'global scaling exponent'. This helps reduce the influence of outliers 
on the regression that fits the dominantly co-linear DFA points.

________________________________________________________________________________
Zip Folder includes:


1 - r_DFA.m which is the main code used to illustrate how to import data, specify 
required inputs and call required functions in order to perform r-DFA. r-DFA 
results will be in the form of figures as well as variables stored in the workspace 
that contain the exact values of the scaling exponents and crossovers. Unmodified 
DFA results are produced as well. 

2 – ‘Sample Data’ folder contains fft_signal_synthesized.mat which is a synthesized 
multi-fractal signal of length 2^19 (=524,288) units and with one crossover at 500 
units. The signal was simulated as explained in [2]. This will be used as a sample 
dataset for illustrating the r-DFA procedure. 

3 – ‘Functions’ folder contains:

           a - DFA_calc.m which is used to process all inputs and performs 
           either only unmodified DFA or both unmodified DFA and r-DFA. The 
           results are passed back to r-DFA.m.

           b - DFA_computation.m is a function that performs the regular DFA as 
           explained in [1]. This function is called by DFA_calc.m.

           c - PLR.m is a function that performs piecewise linear regression with 
           ANCOVA and Multiple Comparison Procedure to determine the statistical 
           significance of crossovers. It also performs robust regression for the 
           DFA results. It is a modification of Copyright (c) 2013, Guido Albertin.

________________________________________________________________________________
Functions Map


Following is a detailed, yet simple, explanation of the workflow of the r-DFA package:

1 – First, use r-DFA.m to define all input arguments:

           - data. This is the fractal data signal. This should be a column matrix 
           containing only the signal’s data.

           - order. This is the highest DFA order you want computed. It is 
           recommended to study the fractal behaviour up to the 6th order with 
           r-DFA in order to ascertain any change in the fractal behaviour, if 
           crossovers exist. This is because the persistence of occurrence of 
           crossovers across higher order DFAs shows that a change in the fractal 
           behaviour exists near that scale [2]. However, for regular DFA, 3rd 
           order is the recommended limit.

           - config_num. The configuration number. This is the number of surrogate 
           realisations that will be used to perform modified DFA. [2] used 100 
           surrogate realisations, however the higher the number, the more the 
           computation time. If config_num = 1, regular DFA will be performed.

           - dt. This is the interval at which the signal is monitored. dt can be 
           the time resolution if the signal is a time series, or spatial 
           resolution if the signal is spatial.

           - q. This is the moment used for studying the fluctuation structure of 
           the signal. If q = 2, regular DFA is computed.

           - SL. This is the significance level which is used by PLR.m in 
           computing confidence intervals for the slopes determined and for 
           performing Multiple Comparison Procedure. 

2- r-DFA uses the inputs specified and calls the function DFA_calc.m.

3- DFA_calc.m calculates the scales at which DFA is computed. The range of scales 
is from [order +2] to [data length]/10. If config_num = 1, regular DFA by calling 
the DFA_computation.m function. If config_num > 1, DFA_computation.m is called 
twice, the first time is to perform regular DFA, and the second time is to perform 
DFA on the surrogate realisations of the data and compute the modified DFA. 

4- The results passed back to r-DFA.m are then visualised and PLR.m is used to 
compute a global scaling exponent using Robust Regression. After the results of 
each DFA order are plotted, the user is prompted to type in the command line the 
number of ‘sticks’ for PLR.m to fit to the data. If ‘1’ is typed, no crossovers 
will be fitted to the results. Error bar plots for the slopes determined from 
PLR.m will be presented to aid the user in deciding what number of crossovers to 
fit from the error bars plotted. The visualization may be repeated by re-running 
the visualization section.

________________________________________________________________________________
Computation Times:


The following table is intended to present expected computation times and these 
obviously depend on a computer’s computation power, nevertheless, are included for 
solely indicative purposes.

   data length   |   order   |   config_num   |   compute time  
     87,381      |     6     |        1       |      15 min
     87,381      |     6     |        5       |     170 min
    131,072      |     3     |        1       |       9 min
    524,288      |     1     |        1       |      10 min
    524,288      |     6     |        1       |      70 min
    524,288      |     6     |        5       |     490 min

________________________________________________________________________________
Copyrights Notes:


PLR.m is a modification of Copyright (c) 2013, Guido Albertin 
All rights reserved

________________________________________________________________________________
Contact info:


Email: abr.habib@gmail.com
linkedIn: http://bh.linkedin.com/pub/abrar-habib/42/18/71
Twitter: @abrarhabib99

________________________________________________________________________________
References:


[1] PENG, C.K., BULDYREV, S.V., HAVLIN, S., SIMONS, M., STANLEY, H.E. and GOLDBERGER, A.L., 1994. Mosaic organization of DNA nucleotides. Physical review.E, Statistical physics, plasmas, fluids, and related interdisciplinary topics, 49(2), pp. 1685.

[2] KANTELHARDT, J.W., KOSCIELNY-BUNDE, E., REGO, H., HAVLIN, S. and BUNDE, A., 2001. Detecting long-range correlations with detrended fluctuation analysis. PHYSICA A, 295(3-4), pp. 441-454.

[3] LITTLE, M.A. and BLOOMFIELD, J.P., 2010. Robust evidence for random fractal scaling of groundwater levels in unconfined aquifers. Journal of Hydrology, 393(3), pp. 362-369.



