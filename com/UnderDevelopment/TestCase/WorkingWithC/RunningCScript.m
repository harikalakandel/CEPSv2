setenv('MW_MINGW64_LOC','C:\TDM-GCC-64')
mex -setup
mex -setup cpp
%mex Analyse.cpp
mex TestMe.cpp