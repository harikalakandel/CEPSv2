/******************************************************************************
 *
 * Program does various types of analysis on ECG recordings
 *
 * Author: D. Cornforth
 *
 * To do:
 * check if some int should be long - e.g. index to data array could be > 32000
 * propagate changes to Choose() to all methods
 * calc Renyi divergence
 * calc Renyi for infinite alpha special case
 *
 * Done:
 * dfa options: output should not be log, add sliding window mode - June 2016
 * DFA has glitches - several mse values are way out - June 2016
 * make Renyi more efficient by calculating probabilities once then
 * using this info for all alpha used - done Sept 2015
 * Renyi kernel size affects the bias and the variance in opposite ways, so the
 * best kernel size is a compromise between bias and variance of the estimator.
 * Implemented Silvermans' rule - done Sept 2015
 * removed attribute "final" (reserved word) now using dataStrt, dataWind, dataSkip, dataReps
 * use zero indexes - done June 2016
 * Choose() does not change the data array, it just defines these values - done June 2016
 * Normalise looks at dataStrt etc. but changes all data - done June 2016
 * Moments calculated separately from Statistics() - done June 2016
 * Altered RenyiEntropy() to use only data indicated by dataStrt etc. - done June 2016
 * Calc Renyi entropy inside a loop so calc multiple times for different windows - done June 2016
 * Calc means and stdev for multple Renyi runs - done June 2016
 *
 ******************************************************************************/

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <fstream>
#define _USE_MATH_DEFINES
#include <math.h>
#include <float.h>
#include <algorithm>    // std::sort
#include <vector>       // std::vector
using namespace std;
#include "Analyse.h"
//#include "dfa_utils.cpp"

static const int LINE_LEN = 200;
static const char* VERSION = "9 June 2016";

//-----------------------------------------------------------------------------
// Calculate Allen factor
//
void Analyse::AllanFactor(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    double window = 0;
    char* pch = strtok(command, " \t"); // first token will be "window"
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        window = atof(pch);
    }
    if (window < DEFAULT_WINDOW_MIN || window > DEFAULT_WINDOW_MAX)
    {
        window = DEFAULT_WINDOW;
    }
    
    //double thisRR = 0.0;   // the RR interval just read from file
    double time = 0.0;   // the cumulative RR interval = current time since start of file
    double sum_diff_sq = 0;   // top line of Allan factor = sum (N_i+1 - N_i)^2
    double boundary = window;   // next window boundary
    int this_count = 0;   // number of R waves in this window = N_i+1
    int last_count = 0;   // number of R waves in last window = N_i
    double sum_count = 0;   // bottom line of Allan factor = sum (N_i+1)
    int windows = 0;
    
    for (int ndx=0; ndx<vecData.size(); ndx++)
    {
        time += vecData[ndx];
        // if the interval is set small, may be several windows containing no R waves
        while (time > boundary)
        {
            // calculate averages of diff and number of R waves
            double diff = this_count - last_count;
            sum_diff_sq += (diff * diff);
            sum_count += this_count;
            boundary += window; // increment window position
            windows++;
            last_count = this_count;
            this_count = 0;
        }
        this_count++;
    }
    
    double allan = sum_diff_sq / 2.0 / sum_count;
    cout << sum_diff_sq << " " << sum_count << endl;
    if (verbose)
    {
        cout << "Scale " << scale << ", Window size " << window << ", Allan factor: " << allan << endl;
    }
    else
    {
        cout << scale << " " << window << " " << allan << endl;
    }
    Result temp("allan", scale, window, allan);
    results.push_back(temp);
}

//-----------------------------------------------------------------------------
// constructor
//
Analyse::Analyse(void)
{
    probability = NULL;
    dataStrt = 0;
    dataWind = 1;
    dataSkip = 1;
    dataReps = 1;
    scale = 1;   // scale to use for downsampling
    dataMax = 0.0;
    dataMin = 0.0;
    mean = 0.0;
    variance = 0.0;
    stdev = 0.0;
    skew = 0.0;
    kurt = 0.0;
    verbose = 0;
    last_pattern = 0;
    last_tolerance = 0.0;
    outSize = DEFAULT_OUTSIZE;
    outType = 0;   // do nothing
}

//-----------------------------------------------------------------------------
// destructor
//
Analyse::~Analyse(void)
{
    if (probability != NULL)
    {
        delete probability;
    }
}

// //-----------------------------------------------------------------------------
// // calculate approximate entropy
// //
// void Analyse::ApproxEntropy(char* command)
// {
//     if (vecData.size() == 0)
//     {
//         cerr << "\nNo data: please load a file.";
//         return;
//     }
//     
//     int pattern = DEFAULT_PATTERN;
//     double tolerance = DEFAULT_TOLERANCE;
//     
//     // Read value from input and set pattern length
//     char* pch = strtok(command, " \t");   // first token will be "pattern"
//     
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         pattern = atoi(pch);
//     }
//     if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX)
//     {
//         pattern = DEFAULT_PATTERN;
//     }
//     
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         tolerance = atof(pch);
//     }
//     if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
//     {
//         tolerance = DEFAULT_TOLERANCE;
//     }
//     
//     //float estimate_approximate_entropy(float *data, int size, int embedded_dim, float r_coeff)
//     
//     int i, j, k, vsize, r;
//     float approx_entropy;
//     float cond_prob;
//     
//     r = (int) (tolerance * stdev + 0.5); /* tolerance value */
//     
//     vsize = vecData.size() - pattern;
//     
//     int* accept_cntr1 = new int[vsize];
//     int* accept_cntr2 = new int[vsize];
//     for (i = 0; i < vsize; ++i)
//     {
//         accept_cntr1[i] = accept_cntr2[i] = 0;
//     }
//     
//     for (i = 0; i < vsize; ++i) /* for each reference vector */
//     {
//         for (j = (i + 1); j < vsize; ++j) /* for each other vector */
//         {
//             /* acceptable difference ? */
//             for (k = 0; k < pattern; ++k)
//             {
//                 if (fabs(vecData[i + k] - vecData[j + k]) > r)
//                 {
//                     break;
//                 }
//             }
//             if (k == pattern)
//             {
//                 ++accept_cntr1[i];
//                 ++accept_cntr1[j];
//                 if (fabs(vecData[i + k] - vecData[j + k]) <= r)
//                 {
//                     ++accept_cntr2[i];
//                     ++accept_cntr2[j];
//                 }
//             }
//         }
//     }
//     
//     approx_entropy = 0.0;
//     
//     for (i = 0; i < vsize; ++i)
//     {
//         if (accept_cntr1[i] > 0)
//         {
//             cond_prob = (float) accept_cntr2[i] / (float) accept_cntr1[i];
//         }
//         else
//         {
//             cond_prob = (float) 0.0;
//         }
//         if (cond_prob > (float) 0.0)
//         {
//             approx_entropy += (-1.0) * log((double) cond_prob);
//         }
//     }
//     
//     approx_entropy /= vsize;
//     if (verbose)
//     {
//         cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Approx entropy " << approx_entropy << endl;
//     }
//     else
//     {
//         cout << scale << " " << pattern << " " << tolerance << " " << approx_entropy << endl;
//     }
//     Result temp("appen", scale, pattern, approx_entropy);
//     results.push_back(temp);
//     
//     delete accept_cntr1;
//     delete accept_cntr2;
// }

//-----------------------------------------------------------------------------
// read from a file with commands
//
void Analyse::BatchMode(char* filename)
{
    cerr << "Analyse version: " << VERSION << endl;
    char in_string[LINE_LEN];
    ifstream infile;
    infile.open(filename, ifstream::in);
    if (infile.fail())
    {
        cerr << "Error: could not open batch file " << filename;
    }
    else
    {
        while (infile.good())
        {
            infile.getline(in_string, LINE_LEN);
            if (*in_string != '/')   // comment line
            {
                if (!Menu(in_string))
                {
                    break; // an error has occurred
                }
            }
        }
        infile.close();
    }
}

//------------------------------------------------------------------------
// Complex Correlation Measure after Karmaker, 2009
void Analyse::CCM(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    int lag = 1;
    
    // get parameters
    char* pch = strtok(command, " \t"); // first token will be "window"
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        lag = atoi(pch);
    }
    if (lag < 1)
    {
        lag = 1;
    }
    
    long maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;
    long maxlimit = dataStrt + maxlength;
    
    // calculate SD1 and SD2 of the Poincare plot using the stdev method
    double varidiff = 0.0;   // variance of successive difference of RR intervals
    double meandiff = 0.0;
    double varisum = 0.0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        double diff = vecData[index+lag] - vecData[index];
        meandiff += diff;
        varidiff += pow(diff, 2.0);
        varisum += pow(vecData[index+lag] + vecData[index] - mean - mean, 2.0);
    }
    meandiff /= maxlength;
    varidiff /= (maxlength - 1);
    varisum /= (maxlength - 1);
    
    double SD1a = sqrt(0.5 * varidiff);
    
    double SD2a = sqrt(2 * variance - 0.5 * varidiff);
    double SD2x = sqrt(0.5 * varisum);
    
    // calculate SD1 and SD2 of the Poincare plot using the autocorrelation method
    double autocorr_zero = 0.0;
    double autocorr_lag = 0.0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        autocorr_zero += pow(vecData[index] - mean, 2.0);
        autocorr_lag += (vecData[index] - mean) * (vecData[index+lag] - mean);
    }
    autocorr_zero /= maxlength;
    autocorr_lag /= maxlength;
    double SD1b = sqrt(autocorr_zero - autocorr_lag);
    double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    
    double SD1 = choose2(SD1a, SD1b);
    double SD2 = choose2(SD2a, SD2b);
    
    double dSumArea = 0.0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        double dAreaTriangle = 0.0;
        dAreaTriangle += vecData[index]   * vecData[index+1+lag];   // u_1 * u_2+m
        dAreaTriangle -= vecData[index]   * vecData[index+2+lag];   // u_1 * u_3+m
        dAreaTriangle += vecData[index+2] * vecData[index+lag];     // u_3 * u_1+m
        dAreaTriangle -= vecData[index+1] * vecData[index+lag];     // u_2 * u_1+m
        dAreaTriangle += vecData[index+1] * vecData[index+2+lag];   // u_2 * u_3+m
        dAreaTriangle -= vecData[index+2] * vecData[index+1+lag];   // u_3 * u_2+m
        dAreaTriangle = 0.5 * dAreaTriangle;
        
        dSumArea += fabs(dAreaTriangle);
    }
    double dNormConst = M_PI * SD1 * SD2;
    double dCCM = dSumArea / dNormConst / (maxlength - 2);
    
    if (verbose >= 3)
    {
        printf("Poincare: %d %f\n", lag, dSumArea);
        printf("Variance method: %f %f %f %f %f %f\n", variance, varidiff, meandiff, SD1a, SD2a, SD2x);
        printf("Correlation: %f %f %f %f\n", autocorr_zero, autocorr_lag, SD1b, SD2b);
    }
    printf("%f %f %f\n", SD1, SD2, dCCM);
}

//------------------------------------------------------------------------
// choose a subset of samples from the file
// if numbers entered are >= 1 then interpret them as sample numbers
// if numbers are <1 then interpret them as a proportion.
// if first entry is "m" then take sample from the middle
//
void Analyse::Choose(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    // set default values
    dataStrt = 0;
    dataWind = vecData.size();
    dataSkip = 1;
    dataReps = 1;
    double tempStart = 0.0;
    double tempLength = 0.0;
    
    // Read values from input and set parameters
    char* pch = strtok(command, " \t");   // first token will be "choose"
    
    // get start and window length
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        if (*pch == 'm')   // take sample from the middle
        {
            tempStart = -1.0;   // take sample from the middle
        }
        else
        {
            tempStart = atof(pch);
        }
    }
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        tempLength = atof(pch);
    }
    
    if (tempLength < 0.0)   // invalid, use default
    {
        dataWind = 1;
    }
    else if (tempLength < 1.0)   // use proportion
    {
        dataWind = (long)(tempLength * vecData.size());
    }
    else
    {
        dataWind = (long)tempLength;
    }
    
    if (tempStart < 0.0)   // take sample from middle
    {
        dataStrt = (long)((vecData.size() - dataWind) / 2) - 1;
    }
    else if (tempStart < 1.0)   // use proportion
    {
        dataStrt = (long)(tempStart * vecData.size()) - 1;
    }
    else
    {
        dataStrt = (long)tempStart - 1;
    }
    
    // get window skip size and number of repeats
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        dataSkip = atoi(pch);
    }
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        dataReps = atoi(pch);
    }
    
    // do some sanity checks
    if (dataStrt < 0 || dataStrt > vecData.size()-1)
    {
        dataStrt = 0;
    }
    if (dataSkip < 1)
    {
        dataSkip = 1;
    }
    if (dataReps < 1)
    {
        dataReps = 1;
    }
    long maxlimit = dataStrt + dataWind + ((dataReps - 1) * dataSkip);
    if (maxlimit > vecData.size())
    {
        // change repeats to allow maximum use of the data
        dataReps = (vecData.size() - dataStrt - dataWind) / dataSkip + 1;
        maxlimit = dataStrt + dataWind + ((dataReps - 1) * dataSkip);
    }
    if (verbose >= 1)
    {
        printf("Start %d, window %d, skip %d, repeats %d, last pattern %d, last_tol %f (prob null)\n", dataStrt, dataWind, dataSkip, dataReps, last_pattern, last_tolerance);
    }
    
    Statistics();   // update the summary statistics
    
    // reset convenience variables for Renyi because the selection has changed
    last_pattern = 0;
    last_tolerance = 0;
    probability = NULL;
}


//-----------------------------------------------------------------------------
// Detrended Fluctuation Analysis
//
// the time series to be analyzed (with N samples) is first integrated.
// the integrated time series is divided into boxes of equal length, n.
// In each box of length n, a least squares line is fit to the data (representing the trend in that box). The y coordinate of the straight line segments is denoted by yn(k).
// detrend the integrated time series, y(k), by subtracting the local trend, yn(k), in each box.
// The root-mean-square fluctuation of this integrated and detrended time series is calculated by:
// F(n) = ((1/N)(Sum (from k=1 to N) of ((y(k) - yn(k))**2)))**.5
// repeat over all time scales (box sizes) to characterize the relationship between F(n), the average fluctuation, and the box size, n.
// Typically, F(n) will increase with box size.
// A linear relationship on a log-log plot indicates the presence of power law (fractal) scaling.
// Under such conditions, the fluctuations can be characterized by a scaling exponent, the slope of the line relating log F(n) to log n.
// void Analyse::Dfa(char* command)
// {
//     if (vecData.size() == 0)
//     {
//         cerr << "\nNo data: please load a file.";
//         return;
//     }
//     
//     long minbox = 0L;
//     long maxbox = 0L;
//     bool slide = false;   // sliding window mode
//     
//     // Read values from input and set parameters
//     char* pch = strtok(command, " \t");   // first token will be "dfa"
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         nfit = atoi(pch);
//     }
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         minbox = atol(pch);
//     }
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         maxbox = atol(pch);
//     }
//     pch = strtok(NULL, " \t");
//     if (pch != NULL && strncmp(pch, "slide", 5) == 0)
//     {
//         slide = true;   // enable sliding window mode
//     }
//     
//     long npts = vecData.size();
//     
//     /* Set minimum and maximum box sizes. */
//     if (minbox < 2 * nfit)
//     {
//         minbox = 2 * nfit;
//     }
//     if (maxbox == 0 || maxbox > npts/4)
//     {
//         maxbox = npts / 4;
//     }
//     if (minbox > maxbox)
//     {
//         SWAP(minbox, maxbox);
//     }
//     if (minbox < 2*nfit)
//     {
//         minbox = 2*nfit;
//     }
//     
//     // Allocate and fill the box size array rs[]. rscale's third argument
//     // specifies that the ratio between successive box sizes is 2^(1/8).
//     nBoxSizes = rscale(minbox, maxbox, pow(2.0, 1.0/8.0));
//     
//     // Allocate memory for dfa() and the functions it calls.
//     setup();
//     
//     // Measure fluctuations of detrended input data at each box size
//     // using the DFA algorithm; fill mse[] with these results.
//     // dfa(seq, npts, nfit, rs, nr, sw)
//     //  npts:	number of input points
//     //  nfit:	order of detrending (2: linear, 3: quadratic, etc.)
//     // rBoxSizes (was rs) array of box sizes (uniformly distr. on log scale)
//     // nBoxSizes (was nr) number of entries in rs[] and mse[]
//     // sw:		mode (0: non-overlapping windows, 1: sliding window)
//     
//     long boxsize, inc, j;
//     double stat;
//     
//     // make seq, which is array of integrals
//     double *seq = new double[vecData.size()+1];
//     double integral = 0.0;
//     seq[0] = 0.0;
//     for (long samp=0; samp<vecData.size(); samp++)
//     {
//         integral += vecData[samp];
//         seq[samp+1] = integral;
//     }
//     
//     for (long iSize=1; iSize<=nBoxSizes; iSize++)
//     {
//         boxsize = rBoxSizes[iSize];
//         if (slide)
//         {
//             inc = 1;
//             stat = (long)(npts - boxsize + 1) * boxsize;
//         }
//         else
//         {
//             inc = boxsize;
//             stat = (long)(npts / boxsize) * boxsize;
//         }
//         
//         //printf("dfa: %d %d %d\n", iSize, boxsize, nfit);   // ***
//         mse[iSize] = 0.0;
//         for (j=0; j<=npts - boxsize; j += inc)
//         {
//             mse[iSize] += polyfit(dfa_ptx, seq + j, boxsize, nfit);
//         }
//         mse[iSize] /= stat;
//         
//         
//         if (verbose)
//         {
//             printf("size %d %d %g\n", iSize, boxsize, mse[iSize]);
//         }
//         
//         //printf("%g %g\n", log10((double)rs[ndxScale]), log10(mse[ndxScale])/2.0);
//         printf("%d %g\n", rBoxSizes[iSize], mse[iSize]);
//         //printf("%d %d %g %g\n", iSize, rBoxSizes[iSize], log10((double)rBoxSizes[iSize]), log10(mse[iSize])/2.0);
//     }
//     
//     delete seq;
//     
//     cleanup();   // Release allocated memory
// }

//-----------------------------------------------------------------------------
// take difference x(t) - x(t-1) and return diff, abs of diff, or sign of diff
// this operation is always done on the entire dataset
//
void Analyse::Diff(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    // make a deep copy
    vector <double> sampled;
    sampled.swap(vecData);
    
    // Read values from input and set parameters
    char* pch = strtok(command, " \t");   // first token will be "norm..."
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        if (strncmp(pch, "diff", 4) == 0)
        {
            for (long index=1; index<sampled.size(); index++)
            {
                vecData.push_back(sampled[index] - sampled[index-1]);
            }
        }
        else if (strncmp(pch, "abs", 3) == 0)
        {
            for (long index=1; index<sampled.size(); index++)
            {
                vecData.push_back(fabs(sampled[index] - sampled[index-1]));
            }
        }
        else if (strncmp(pch, "sign", 4) == 0)
        {
            for (long index=1; index<sampled.size(); index++)
            {
                if (sampled[index] > sampled[index-1])
                {
                    vecData.push_back(1.0);
                }
                else
                {
                    vecData.push_back(-1.0);
                }
            }
        }
        
        // convert difference to a true differential
        pch = strtok(NULL, " \t");
        if (pch != NULL && strncmp(pch, "dx", 2) == 0)
        {
            for (long ndx=0; ndx<vecData.size(); ndx++)
            {
                double dx = (sampled[ndx] + sampled[ndx+1]) / 2.0;   // average RR interval
                vecData[ndx] /= dx;
            }
        }
    }
    
    if (verbose)
    {
        cout << "Diff " << command << " " << vecData.size() << endl;
        for (long ndx=0; ndx<vecData.size(); ndx++)
        {
            cout << vecData[ndx] << endl;
        }
    }
    
    Statistics();
}

//-----------------------------------------------------------------------------
// read from a file with single column of numbers equally spaced samples
//
void Analyse::FileRead(char* command)
{
    //char* temp = strtok(command, " \t");   // get first token (should be "load")
    //char* filename = strtok(NULL, " \t");   // get second token (should be file name)
    char* filename = command + 5;
    if (filename == NULL || strlen(filename) == 0)
    {
        cerr << "Please specify a file name.";
        return;
    }
    
    ifstream infile;
    infile.open(filename, ifstream::in);
    if (infile.fail())
    {
        cerr << "Could not open file:\n\t";
        cerr << filename << endl;
    }
    else
    {
        cout << "Reading from file " << filename << endl;
        
        vecData.clear(); // clear current data array
        
        // get length of file:
        infile.seekg(0, ios::end);
        long length = infile.tellg();
        infile.seekg(0, ios::beg);
        
        char line[LINE_LEN];
        while (infile.good())
        {
            infile.getline(line, LINE_LEN);
            if (strlen(line) > 0)
            {
                double point = atof(line);
                vecData.push_back(point);   // add a point to the vector
            }
        }
        infile.close();
        cout << "File is " << length << " bytes long and contains " << vecData.size() << " values.\n";
    }
    
    dataStrt = 0;
    dataWind = vecData.size();
    dataSkip = 1;
    dataReps = 1;
    
    Statistics();
    
    // reset convenience variables for Renyi because the selection has changed
    last_pattern = 0;
    last_tolerance = 0;
    probability = NULL;
}

//-----------------------------------------------------------------------------
// calculate fractal dimension using the ruler method
// place a ruler of length r against the signal and measure the total length of the signal
// as ruler decreases in size it will fit into smaller pieces so total length is greater
// plot log(length) against log(r) and take the slope
// find biggest instanataneous slope
// if < 1, can't calculate - give up
// find longest contiguous part of curve within 10% of max gradient
// use these points to calc gradient.
//
void Analyse::FractalDimension(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    // Read value from input and set pattern length
    double min_rsq = DEFAULT_RSQ;
    char* pch = strtok(command, " \t"); // first token will be discarded
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        min_rsq = atof(pch);
    }
    if (min_rsq < DEFAULT_RSQ_MIN || min_rsq > DEFAULT_RSQ_MAX)
    {
        min_rsq = DEFAULT_RSQ;
    }
    
    const int POINTS = 200; // number of points to generate for the graph
    int size = vecData.size();
    int size2 = size / 2;
    double logx[POINTS];
    double logy[POINTS];
    double gradient[POINTS];
    
    double log_step = log((double)size2) / POINTS;
    int last_ruler = 0;
    int res = 0; // index into array of log x,y values
    for (int point = 0; point < POINTS; point++)
    {
        int ruler = (int) exp(log_step * point); // ruler size to use for fractal dimension
        if (ruler > last_ruler)
        {
            double sum = 0.0;
            int count = 0;
            for (int ndx = 0; ndx < size - ruler; ndx++)
            {
                double distance_y = vecData[ndx] - vecData[ndx + ruler];
                sum += sqrt(distance_y * distance_y + ruler * ruler);
                count++;
            }
            double length = sum / ruler / count;
            logx[res] = log((double) ruler);
            logy[res] = log(length);
            if (res > 0)
            {
                gradient[res] = (logy[res] - logy[res - 1]) / (logx[res] - logx[res - 1]);
            }
            res++;
            last_ruler = ruler;
        }
    }
    int max_points = res;
    gradient[0] = gradient[1];
    
    // assuming non-normal distribution, find gradient below which 10% of data lies
    //vector<double> distribution (gradient, gradient + max_points);
    //sort (distribution.begin (), distribution.end ());
    //double hi_grad = distribution[max_points / 10];
    if (verbose)
    {
        //printf ("sorted: %f %f %f\n", distribution[0], hi_grad, distribution[max_points-2]);
        for (int point = 0; point < max_points; point++)
        {
            printf("%d %f %f %f\n", point, logx[point], logy[point],
                    gradient[point]);
        }
    }
    
    // method that depends on maximising the r squared
    int grad_start = -1;
    int grad_finish = max_points - 1;
    Result temp = Slope(logx, logy, 0, grad_finish);
    while (grad_start < grad_finish)
    {
        grad_start++;
        temp = Slope(logx, logy, grad_start, grad_finish);
        if (fabs(temp.x[1]) > min_rsq)
        {
            break;
        }
        grad_finish--;
        temp = Slope(logx, logy, grad_start, grad_finish);
        if (fabs(temp.x[1]) > min_rsq)
        {
            break;
        }
    }
    
    if (verbose)
    {
        cout << "gradient for sizes " << grad_start << " to " << grad_finish << ": FD = " << temp.x[0] << " r.sq. = " << temp.x[1] << endl;
    }
    else
    {
        cout << temp.x[0] << " " << temp.x[1] << endl;
    }
}

//-----------------------------------------------------------------------------
// Interactive mode user interface
//
void Analyse::Interactive()
{
    ShowOptions();
    //char choice;
    char in_string[LINE_LEN];
    bool loop = true;
    verbose = 1;
    while (loop)
    {
        cerr << "\nEnter your choice (\"options\" to display options): ";
        cin.getline(in_string, LINE_LEN);
        loop = Menu(in_string);
    }
}

//-----------------------------------------------------------------------------
// Entry point
//
// int main(int argc, char * argv[])
// {
//     Analyse analyse;
//     
//     if (argc < 2)
//     {
//         cerr << "Analyse version: " << VERSION << endl;
//         cerr << "You have selected interactive mode.\n";
//         cerr << "To select batch mode (commands are stored in a text file), do this:\n";
//         cerr << "Analyse <file name>\n";
//         analyse.Interactive();
//     }
//     else
//     {
//         analyse.BatchMode(argv[1]);
//     }
//     return 0;
// }










/* mexFunction is the gateway routine for the MEX-file. */ 
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
   

}












//-----------------------------------------------------------------------------
// Calculate moments for the selected portion of the dataset only
//
void Analyse::Moments(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    long maxlength = dataWind + ((dataReps - 1) * dataSkip);
    long maxlimit = dataStrt + maxlength;
    int moments = DEFAULT_MOMENTS;
    char* pch = strtok(command, " \t"); // first token will be discarded
    
    // Read value from input and set number of moments
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        moments = atoi(pch);
    }
    if (moments < 1 || moments > DEFAULT_MOMENTS_MAX)   // if a silly value given
    {
        moments = DEFAULT_MOMENTS;
    }
    
    double* moment = new double[moments];
    for (int ndx=0; ndx<moments; ndx++)
    {
        moment[ndx] = 0.0;
    }
    
    for (int index=dataStrt; index<maxlimit; index++)
    {
        double diff = vecData[index] - mean;
        for (int ndx=0; ndx<moments; ndx++)
        {
            moment[ndx] += pow(diff, (double)ndx);
        }
    }
    
    for (int ndx=1; ndx<moments; ndx++)
    {
        moment[ndx] = moment[ndx] / dataWind / pow(stdev, (double)ndx);
        cout << " " << moment[ndx];
    }
    cout << endl;
    
    delete moment;
}

//-----------------------------------------------------------------------------
// Interactive mode user interface
//
bool Analyse::Menu(char* command)
{
    bool correct = true;
    if (strlen(command) == 0)
    {
        return correct;
    }
    lower(command);
    if (strncmp(command, "allan", 5) == 0) // Allan factor
    {
        AllanFactor(command);
    }
    else if (strncmp(command, "app", 3) == 0) // approximate entropy
    {
       // ApproxEntropy(command);
    }
    else if (strncmp(command, "ccm", 3) == 0) // choose which samples
    {
        CCM(command);
    }
    else if (strncmp(command, "choose", 6) == 0) // choose which samples
    {
        Choose(command);
    }
    else if (strncmp(command, "dfa", 3) == 0)   // Detrended Fluctuation Analysis
    {
       // Dfa(command);
    }
    else if (strncmp(command, "diff", 4) == 0) // calc difference between samples
    {
        Diff(command);
    }
    else if (strncmp(command, "echo", 4) == 0) // echo text to output (used in batch processing)
    {
        cout << (command + 5) << endl;
    }
    else if (strncmp(command, "exit", 4) == 0)
    {
        cout << "\nThank you for using Analyse\n";
        correct = false;
    }
    else if (strncmp(command, "fract", 5) == 0) // Fractal Dimension
    {
        FractalDimension(command);
    }
    else if (strncmp(command, "help", 4) == 0)
    {
        ShowOptions();
    }
    else if (strncmp(command, "load", 4) == 0) // load file
    {
        FileRead(command);
    }
    else if (strncmp(command, "mom", 3) == 0)   // calculate moments
    {
        Moments(command);
    }
    else if (strncmp(command, "norm", 4) == 0)   // Normalise the data using range (max-min), mean or stdev
    {
        Normalise(command);
    }
    else if (strncmp(command, "options", 7) == 0)
    {
        ShowOptions();
    }
    else if (strncmp(command, "outlier", 7) == 0)
    {
        OutlierParams(command);
    }
    else if (strncmp(command, "quit", 4) == 0)
    {
        cout << "\nThank you for using Analyse\n";
        correct = false;
    }
    else if (strncmp(command, "reg", 3) == 0)
    {
        Regression(command);
    }
    else if (strncmp(command, "rdiv", 5) == 0) // Renyi divergence
    {
        RenyiDivergence(command);
    }
    else if (strncmp(command, "renyi", 5) == 0) // Renyi entropy
    {
        RenyiEntropy(command);
    }
    else if (strncmp(command, "renhist", 5) == 0) // Renyi using the Histogram method
    {
        RenyiHistogram(command);
    }
    else if (strncmp(command, "samp", 4) == 0) // sample entropy
    {
        MultiScaleEntropy(command);
    }
    else if (strncmp(command, "scale", 5) == 0) // down sample
    {
        Scale(command);
    }
    else if (strncmp(command, "sdwt", 4) == 0) // Standard Deviation of Wavelet Transform
    {
        //StdevWavelet(command);
    }
    else if (strncmp(command, "verbose", 7) == 0) // toggle verbose mode
    {
        char* pch = strtok(command, " \t"); // first token will be discarded
        pch = strtok(NULL, " \t");
        if (pch != NULL)
        {
            verbose = atoi(pch);
        }
        if (verbose < 0)
        {
            verbose = 0;
        }
        cout << "Verbose level is " << verbose << endl;
    }
    else
    {
        cout << "Invalid choice: \"" << command << "\": try again\n";
    }
    return correct;
}

//-----------------------------------------------------------------------------
// Multi scale entropy: perform the sample entropy at various down sample scales
//
void Analyse::MultiScaleEntropy(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    int pattern = DEFAULT_PATTERN;
    double tolerance = DEFAULT_TOLERANCE;
    
    // Read value from input and set pattern length
    char* pch = strtok(command, " \t"); // first token will be "pattern"
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        pattern = atoi(pch);
    }
    if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX)
    {
        pattern = DEFAULT_PATTERN;
    }
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        tolerance = atof(pch);
    }
    if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
    {
        tolerance = DEFAULT_TOLERANCE;
    }
    
    double samp_ent = SampleEntropy(pattern, tolerance);
    if (verbose)
    {
        cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Sample entropy " << samp_ent << endl;
    }
    else
    {
        cout << scale << " " << pattern << " " << tolerance << " " << samp_ent << endl;
    }
    Result temp("sampen", scale, pattern, samp_ent);
    results.push_back(temp);
}

//-----------------------------------------------------------------------------
// Normalise the data using range (max-min) or stdev
// normalise all the data, but base it on only the window being used
// this means dataset is always consistent, so you can re-normalise at any time
//
void Analyse::Normalise(char* command)
{
    // Read values from input and set parameters
    char* pch = strtok(command, " \t");   // first token will be "norm..."
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        // find index to last data sample + 1, taking account of any repeats
        long maxlimit = dataStrt + dataWind + ((dataReps - 1) * dataSkip);
        if (strncmp(pch, "range", 5) == 0)
        {
            double range = dataMax - dataMin;
            if (range != 0.0)
            {
                for (long index=0; index<vecData.size(); index++)
                {
                    vecData[index] = (vecData[index] - dataMin) / range;
                }
            }
            Statistics();
        }
        else if (strncmp(pch, "mean", 4) == 0)
        {
            for (long index=0; index<vecData.size(); index++)
            {
                vecData[index] = vecData[index] - mean;
            }
            Statistics();
        }
        else if (strncmp(pch, "stdev", 6) == 0)
        {
            for (long index=0; index<vecData.size(); index++)
            {
                vecData[index] = (vecData[index] - mean) / stdev;
            }
            Statistics();
        }
        else
        {
            cout << "you must specify range, mean or stdev\n";
            return;
        }
    }
    else
    {
        cout << "you must specify range, mean or stdev\n";
        return;
    }
}

//-----------------------------------------------------------------------------
// set parameters for outlier detection and treatment
//
void Analyse::OutlierParams(char* command)
{
    // Read value from input and set outlier detection range
    char* pch = strtok(command, " \t"); // first token will be "pattern"
    
    pch = strtok(NULL, " \t");   // get outlier detection range
    
    if (pch != NULL)
    {
        outSize = atof(pch);
    }
    if (outSize < DEFAULT_OUTSIZE_MIN)
    {
        outSize = DEFAULT_OUTSIZE_MIN;
    }
    
    pch = strtok(NULL, " \t");   // get outlier treatment type
    if (pch != NULL)
    {
        if (strncmp(pch, "none", 4) == 0)
        {
            outType = 0;
        }
        else if (strncmp(pch, "median", 6) == 0)
        {
            outType = 1;
        }
        else if (strncmp(pch, "mean", 4) == 0)
        {
            outType = 2;
        }
        else if (strncmp(pch, "inter", 5) == 0)
        {
            outType = 3;
        }
        else
        {
            cout << "incorrect option for outlier treatment\n";
            outType = 0;
        }
    }
    
    if (verbose > 1)
    {
        printf("outlier: %f %d\n", outSize, outType);
    }
}

//-----------------------------------------------------------------------------
// regression for something??
//
void Analyse::Regression(char* command)
{
    if (results.size() < 2)
    {
        cout << "\nNot enough results: perform analysis first.";
        return;
    }
    
    int x_index = -1;
    int points = 0;
    bool logx = false;
    bool logy = false;
    
    if (strstr(command, "logx") != NULL)
    {
        logx = true;
    }
    if (strstr(command, "logy") != NULL)
    {
        logy = true;
    }
    
    // Read values from input and set parameters
    char* pch = strtok(command, " \t");   // first token will be "regress"
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        if (strncmp(pch, "scale", 5) == 0)
        {
            x_index = 0;
        }
        else if (strncmp(pch, "length", 6) == 0)
        {
            x_index = 1;
        }
        else
        {
            cout << "you must specify either scale or length\n";
            return;
        }
    }
    
    pch = strtok(NULL, " \t");   // get the number of points to use
    if (pch != NULL)
    {
        points = atoi(pch);
    }
    if (points < 2 || points > results.size())
    {
        points = results.size();
    }
    
    // regression
    double sum_x = 0.0;
    double sum_y = 0.0;
    double sum_xy = 0.0;
    double sum_xx = 0.0;
    int rstart = results.size() - points;
    int finish = results.size();
    for (int ndx = rstart; ndx < finish; ndx++)
    {
        double x = results[ndx].x[x_index];
        double y = results[ndx].y;
        if (logx)
        {
            x = log10(x);
        }
        if (logy)
        {
            y = log10(y);
        }
        sum_x += x;
        sum_y += y;
        sum_xy += (x * y);
        sum_xx += (x * x);
    }
    
    double slope = ((points * sum_xy) - (sum_x * sum_y)) / ((points * sum_xx) - (sum_x * sum_x));
    cout << "Slope = " << slope << endl;
}


//-----------------------------------------------------------------------------
// calculate Renyi Divergence
//
void Analyse::RenyiDivergence(char* command)
{
    
}

//-----------------------------------------------------------------------------
// calculate Renyi entropy using the density method
//
void Analyse::RenyiEntropy(char* command)
{
    //cout << "RenyiEntropy: verbose = " << verbose << " dataReps " << dataReps << endl;
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    int pattern = DEFAULT_PATTERN;
    double tolerance = DEFAULT_TOLERANCE;
    double exponent = DEFAULT_EXPONENT;
    
    // Read value from input and set pattern length
    char* pch = strtok(command, " \t");   // first token will be "pattern"
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        pattern = atoi(pch);
    }
    if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX || pattern > dataWind)
    {
        pattern = DEFAULT_PATTERN;
    }
    
    long words = dataWind - pattern + 1;
    long maxlength = dataWind + ((dataReps - 1) * dataSkip);
    long maxlimit = dataStrt + maxlength;
    
    if (verbose > 1)
    {
        printf("Renyi Entropy with repeats %d, pattern %d from %d to %d: %d values, %d words, up to %d.\n", dataReps, pattern, dataStrt, dataStrt+dataWind, dataWind, words, maxlimit);
    }
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        tolerance = atof(pch);
    }
    
    // stdev is based on the data subset including repeats
    if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
    {
        // Silvermans' rule
        //tolerance = stdev * pow(4.0 / (2.0 + pattern) / words, 1.0 / (4.0 + pattern));
        // my rule of thumb
        tolerance = 0.006 * exp(0.1722 * pattern);
        if (verbose > 1)
        {
            //cout << "Silvermans' rule: " << stdev << " " << pattern << " " << words << " " << tolerance << ".\n";
            cout << "Rule of thumb: " << pattern << " " << tolerance << endl;
        }
    }
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        exponent = atof(pch);
    }
    if (exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX)
    {
        exponent = DEFAULT_EXPONENT;
    }
    
    if (probability == NULL || pattern != last_pattern || tolerance != last_tolerance)
    {
        // calc Renyi probs over the whole data segment being used, including repeats
        if (verbose > 1)
        {
            cout << "Calculate probabilities\n";
        }
        int maxwords = maxlength - pattern + 1;
        RenyiProbs(maxwords, pattern, tolerance);
    }
    
    // calc Renyi Entropy over the number of repeats chosen
    // ***** add option to display only means +- std err?
    double sum_x = 0.0;
    double sum_xx = 0.0;
    for (int rep=0; rep<dataReps; rep++)
    {
        int word_beg = rep * dataSkip;
        int word_end = word_beg + words;
        
        // normalise probs to add up to 1.0
        double sum_prob = 0.0;
        for (int pos=word_beg; pos<word_end; pos++)
        {
            sum_prob += probability[pos];
        }
        if (verbose > 1)
        {
            printf("sum_prob from %d to %d: %f\n", word_beg, word_end, sum_prob);
        }
        // calc Renyi entropy using the probabilities
        double sum_renyi = 0.0;
        for (int pos=word_beg; pos<word_end; pos++)
        {
            double prob = probability[pos] / sum_prob;   // normalise here
            if (prob > 0.0)   // if zero, this calculation goes inf
            {
                if (exponent == 1.0)   // special case is Shannon Entropy
                {
                    sum_renyi += prob * log(prob) / log((double)2.0);
                }
                else
                {
                    sum_renyi += pow(prob, exponent);
                }
            }
        }
        
        // adjust scale factors
        double renyi = 0.0;
        if (exponent == 1.0)   // special case is Shannon Entropy
        {
            renyi = -sum_renyi;
        }
        else
        {
            renyi = log(sum_renyi) / log((double)2.0) / (1 - exponent);
        }
        
        renyi /= (log((double)dataWind) / log((double)2.0));   // adjust for the length of the data set
        // calc mean and stdev
        sum_x += renyi;
        sum_xx += (renyi * renyi);
        
        if (verbose > 1)
        {
            cout << "Scale " << scale << ", Pattern length " << pattern << ", Tolerance " << tolerance << ", Exponent " << exponent << ", Renyi entropy " << renyi << endl;
        }
        else if (verbose == 1)
        {
            cout << scale << " " << pattern << " " << tolerance << " " << exponent << " " << renyi << endl;
        }
        else if (dataReps == 1)   // must be consistet with the form for dataReps > 1 below
        {
            cout << renyi << " " << tolerance << " " << pattern << " " << endl;
        }
    }
    
    if (dataReps > 1)
    {
        double renyi_mean = sum_x / dataReps;
        double renyi_stdev = sqrt(sum_xx / (dataReps - 1) - renyi_mean * renyi_mean);
        cout << renyi_mean << " " << renyi_stdev << " " << dataReps << endl;
    }
    
    last_pattern = pattern;
    last_tolerance = tolerance;
}

//-----------------------------------------------------------------------------
// calculate Renyi entropy using the histogram method
//
void Analyse::RenyiHistogram(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    // Read value from input and set pattern length
    char* pch = strtok(command, " \t");   // first token will be "pattern"
    
    double exponent = DEFAULT_EXPONENT;
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        exponent = atof(pch);
    }
    if (exponent < DEFAULT_EXPONENT_MIN || exponent > DEFAULT_EXPONENT_MAX)
    {
        exponent = DEFAULT_EXPONENT;
    }
    
    int binCount = 20;
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        binCount = atoi(pch);
    }
    if (binCount < DEFAULT_BINS_MIN || binCount > DEFAULT_BINS_MAX)
    {
        binCount = DEFAULT_BINS;
    }
    
    double tolerance = DEFAULT_TOLERANCE;
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        tolerance = atof(pch);
    }
    if (tolerance < DEFAULT_TOLERANCE_MIN || tolerance > DEFAULT_TOLERANCE_MAX)
    {
        tolerance = DEFAULT_TOLERANCE;
    }
    
    double min = dataMin;   // default
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        min = atof(pch);
    }
    
    double max = dataMax;
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        max = atof(pch);
    }
    
    double sum_samples = 0.0;
    // make bin width slightly larger to avoid ghost bin
    double bin_width = 1.01 * (max - min) / binCount;
    //double histogram[binCount];
    double *histogram = new double[binCount];
    for (int bin=0; bin<binCount; bin++)
    {
        histogram[bin] = 0;
    }
    
    // assign each sample into a bin of the histogram
    for (int ndx=0; ndx<vecData.size(); ndx++)
    {
        int bin = (vecData[ndx] - min) / bin_width;
        histogram[bin]++;
        //cout << "sample " << ndx << " into bin " << bin << endl;
    }
    
    // apply filter if requested
    if (tolerance > 0.0)
    {
        // calc filter coefficients
        double coeff[FILTER_LENGTH];
        int middle = FILTER_LENGTH / 2.0;   // only works if FILTER_LENGTH is odd!
        for (int ndx=0; ndx<FILTER_LENGTH; ndx++)
        {
            // use Gaussian kernel to calculate filter, using tolerance as standard deviation
            double dist = middle - ndx;
            coeff[ndx] = exp(-dist * dist / 2.0 / tolerance / tolerance);
            //cout << ndx << " " << dist << " " << coeff[ndx] << endl;
        }
        //cout << endl;
        
        // apply filter
        //double hist_filt[binCount];
        double *hist_filt = new double[binCount];
        for (int bin=0; bin<binCount; bin++)
        {
            hist_filt[bin] = 0.0;
            for (int ndx=0; ndx<FILTER_LENGTH; ndx++)
            {
                int bin_ndx = bin + ndx - middle;
                if (bin_ndx >= 0 && bin_ndx < binCount)
                {
                    hist_filt[bin] += histogram[bin_ndx] * coeff[ndx];
                }
            }
        }
        // copy filtered values back into original
        for (int bin=0; bin<binCount; bin++)
        {
            histogram[bin] = hist_filt[bin];
        }
        delete hist_filt;
    }
    
    // get total of bins so can normalise all probs to sum to 1
    double sum_hist = 0.0;
    for (int bin=0; bin<binCount; bin++)
    {
        sum_hist += histogram[bin];
    }
    
    double renyiSum = 0.0;
    for (int bin=0; bin<binCount; bin++)
    {
        double prob = histogram[bin] / sum_hist;   // normalise
        if (verbose)
        {
            cout << bin << " " << histogram[bin] << " " << prob << endl;
        }
        if (prob > 0.0)   // if its zero, this calculation goes inf
        {
            if (exponent == 1)   // special case: Shannon entropy
            {
                renyiSum += prob * log(prob);
            }
            else
            {
                renyiSum += pow(prob, exponent);
            }
        }
    }
    //cout << endl;
    
    if (exponent == 1)   // special case: Shannon entropy
    {
        renyiSum /= -log((double)2.0);
    }
    else
    {
        renyiSum = log(renyiSum) / log((double)2.0) / (1.0 - exponent);
    }
    
    renyiSum /= (log((double)binCount) / log((double)2.0));   // adjust for the length of the data set
    
    if (verbose)
    {
        cout << "exponent " << exponent << ", bin count " << binCount << ", tolerance " << tolerance << ", minimum " << min << ", maximum " << max << ", renyi " << renyiSum << endl;
    }
    else
    {
        cout << exponent << " " << binCount << " " << tolerance << " " << min << " " << max << " " << renyiSum << endl;
    }
    
    delete histogram;
}

//-----------------------------------------------------------------------------
// calculate probabilities for Renyi entropy
// these probs are not normalised, so must be normalised when running RenyiEntropy()
// if Choose() specifies data samples to skip, this calculates all including the gaps
// RenyiEntropy() just misses those extra ones out
//
void Analyse::RenyiProbs(int words, int pattern, double tolerance)
{
    if (verbose >= 2)
    {
        cout << "Calculating probs...\n";
    }
    
    probability = new double[words];
    
    // calculate covariance matrix
    if (verbose >= 3)
    {
        // create blank arrays
        double *dMean = new double[pattern];
        double **covar = new double*[pattern];
        for (int ndx1=0; ndx1<pattern; ndx1++)
        {
            dMean[ndx1] = 0.0;
            covar[ndx1] = new double[pattern];
            for (int ndx2=0; ndx2<pattern; ndx2++)
            {
                covar[ndx1][ndx2] = 0.0;
            }
        }
        
        // estimate means
        for (int pos=0; pos<words; pos++)
        {
            for (int ndx=0; ndx<pattern; ndx++)
            {
                dMean[ndx] += vecData[dataStrt + pos + ndx];   // dataStrt begins at 0
            }
        }
        for (int ndx=0; ndx<pattern; ndx++)
        {
            dMean[ndx] /= words;
        }
        
        for (int pos=0; pos<words; pos++)
        {
            for (int ndx1=0; ndx1<pattern; ndx1++)
            {
                for (int ndx2=0; ndx2<pattern; ndx2++)
                {
                    double dev1 = vecData[dataStrt + pos + ndx1] - dMean[ndx1];
                    double dev2 = vecData[dataStrt + pos + ndx2] - dMean[ndx2];
                    covar[ndx1][ndx2] += dev1 * dev2;
                }
            }
        }
        for (int ndx1=0; ndx1<pattern; ndx1++)
        {
            for (int ndx2=0; ndx2<pattern; ndx2++)
            {
                covar[ndx1][ndx2] /= (words-1);
                printf ("covar %d %d %f\n", ndx1, ndx2, covar[ndx1][ndx2]);
            }
        }
        double det = covar[0][0];
        if (pattern > 1)
        {
            det = (covar[0][0] * covar[1][1]) - (covar[0][1] * covar[1][0]);
        }
        printf ("det %f\n", det);
        
        for (int ndx1=0; ndx1<pattern; ndx1++)
        {
            for (int ndx2=0; ndx2<pattern; ndx2++)
            {
                covar[ndx1][ndx2] /= sqrt(det);
                printf ("covar %d %d %f\n", ndx1, ndx2, covar[ndx1][ndx2]);
            }
        }
        //det = (covar[0][0] * covar[1][1]) - (covar[0][1] * covar[1][0]);
        //printf ("det %f\n", det);
        
        for (int ndx=0; ndx<pattern; ndx++)
        {
            delete [] covar[ndx];
        }
        delete covar;
        delete dMean;
    }
    
    //double gaussC = 2 * tolerance * tolerance;
    double gaussC = 2 * tolerance * tolerance * stdev * stdev;
    //double prob_total = 0.0;
    for (int pos1=0; pos1<words; pos1++)
    {
        probability[pos1] = 0.0;
        for (int pos2=0; pos2<words; pos2++)
        {
            double dist_sq = 0.0;
            for (int ndx=0; ndx<pattern; ndx++)
            {
                dist_sq += pow(vecData[dataStrt + pos1 + ndx] - vecData[dataStrt + pos2 + ndx], 2.0);
            }
            //cout << " " << dist_sq << " " << exp(-dist_sq / gaussC) << endl;
            probability[pos1] += exp(-dist_sq / gaussC);
        }
        //cout << "total " << probability[pos1] << endl;
        //prob_total += probability[pos1];
    }
    
    //probability[pos1] /= prob_total;   // normalise probs to sum to 1
    if (verbose >= 2)
    {
        for (int pos1=0; pos1<words; pos1++)
        {
            cout << pos1 << " " << probability[pos1] << endl;
        }
    }
}

//-----------------------------------------------------------------------------
// calculate sample entropy - the code I wrote myself
//
double Analyse::SampleEntropy(int patternLength, double tolerance)
{
    int checks = vecData.size() - patternLength - 1;
    double r_new = tolerance * stdev;
    int match_count = 0;   // number of patterns of length (patternLength) that match
    int extra_count = 0;   // number of patterns of length (patternLength + 1) that match
    double samp_ent = 0.0;
    
    // starting point for first sequence
    for (int point1=0; point1<checks; point1++)
    {
        // starting point for second sequence
        for (int point2 = point1 + 1; point2 <= checks; point2++) // self-matches are not counted
        {
            bool sequence_match = true;
            // compare each element of the 2 sequences
            for (int increment=0; increment<patternLength; increment++)
            {
                if (fabs(vecData[point1 + increment] - vecData[point2 + increment]) > r_new)
                {
                    sequence_match = false;
                    break;
                }
            }
            if (sequence_match)
            {
                match_count++;
                if (fabs(vecData[point1 + patternLength] - vecData[point2 + patternLength]) <= r_new)
                {
                    extra_count++;
                }
            }
        }
    }
    
    if (extra_count == 0 || match_count == 0)
    {
        cerr << "zeros\n";
    }
    else
    {
        samp_ent = -log((double) extra_count / match_count);
    }
    return samp_ent;
}

//-----------------------------------------------------------------------------
// down sampling - applies to entire dataset
//
void Analyse::Scale(char* command)
{
    if (vecData.size() == 0)
    {
        cerr << "\nNo data: please load a file.";
        return;
    }
    
    scale = DEFAULT_SCALE;
    
    // Read values from input and set parameters
    char* pch = strtok(command, " \t"); // first token will be "sample"
    
    pch = strtok(NULL, " \t");
    if (pch != NULL)
    {
        scale = atof(pch);
    }
    if (scale < DEFAULT_SCALE_MIN || scale > DEFAULT_SCALE_MAX)
    {
        scale = DEFAULT_SCALE;
    }
    
    // make a deep copy
    vector <double> sampled;
    sampled.swap(vecData);
    //cout << "Vectors: " << sampled.size() << ", " << vecData.size() << endl;
    
    // do the down sampling or coarse graining
    long samples = vecData.size() / scale;   // how many samples afterwards
    long index = 0;
    for (long samp=0; samp<samples; samp++)
    {
        double sample = 0.0;
        for (int point=0; point<scale; point++)
        {
            sample += sampled[index++];
        }
        vecData.push_back(sample / scale);   // put mean value back into data
    }
    
    Statistics();
}

//-----------------------------------------------------------------------------
// calculate the slope of a fitted straight line
//
Result Analyse::Slope(double* data_x, double* data_y, int grad_start, int grad_finish)
{
    double sum_x = 0.0;
    double sum_y = 0.0;
    int res = 0;
    for (res = grad_start; res <= grad_finish; res++)
    {
        sum_x += data_x[res];
        sum_y += data_y[res];
    }
    int count = grad_finish - grad_start + 1;
    double mean_x = sum_x / count;
    double mean_y = sum_y / count;
    
    double sum_xy = 0.0;
    double sum_xx = 0.0;
    double sum_yy = 0.0;
    for (res = grad_start; res <= grad_finish; res++)
    {
        sum_xy += (data_x[res] - mean_x) * (data_y[res] - mean_y);
        sum_xx += (data_x[res] - mean_x) * (data_x[res] - mean_x);
        sum_yy += (data_y[res] - mean_y) * (data_y[res] - mean_y);
    }
    
    double slope = 1.0 - (sum_xy / sum_xx);
    double correlation = sum_xy / sqrt(sum_xx * sum_yy);
    Result temp("slope", slope, correlation, 0.0);
    return temp;
}

// //-----------------------------------------------------------------------------
// // Standard Deviation of the Wavelet Transform
// //
// void Analyse::StdevWavelet(char* command)
// {
//     if (vecData.size() == 0)
//     {
//         cerr << "\nNo data: please load a file.";
//         return;
//     }
//     
//     int pattern = DEFAULT_PATTERN;
//     
//     // Read value from input and set pattern length
//     char* pch = strtok(command, " \t"); // first token will be discarded
//     pch = strtok(NULL, " \t");
//     if (pch != NULL)
//     {
//         pattern = atoi(pch);
//     }
//     if (pattern < DEFAULT_PATTERN_MIN || pattern > DEFAULT_PATTERN_MAX)
//     {
//         pattern = DEFAULT_PATTERN;
//     }
//     
//     double* wavelet = new double[pattern];
//     
//     // do the Haar wavelet
//     int half = pattern / 2;
//     for (int samp = 0; samp < pattern; samp++)
//     {
//         if (samp < half)
//         {
//             wavelet[samp] = 1.0;
//         }
//         else
//         {
//             wavelet[samp] = -1.0;
//         }
//     }
//     if (2 * half != pattern) // if odd number
//     {
//         wavelet[half] = 0;
//     }
//     
//     int last = vecData.size() - pattern;
//     double sum = 0.0;
//     double sum2 = 0.0;
//     int count = 0;
//     double pattern2sq = sqrt((double) pattern / 2.0);
//     for (int pos = 0; pos < last; pos++)
//     {
//         double convolve = 0.0;
//         for (int samp = 0; samp < pattern; samp++)
//         {
//             convolve += (wavelet[samp] * vecData[pos + samp]);
//         }
//         convolve /= pattern2sq;
//         sum += convolve;
//         sum2 += (convolve * convolve);
//         count++;
//     }
//     double wMean = sum / count;
//     double wStdev = sqrt((sum2 - sum * sum / count) / (count - 1));
//     if (verbose)
//     {
//         cout << count << " " << sum << " " << sum2 << " " << wMean << endl;
//         cout << "Scale " << scale << ", Pattern length " << pattern
//                 << ", stdev. Wavelet Transform " << wStdev << endl;
//     }
//     else
//     {
//         cout << scale << " " << pattern << " " << wStdev << endl;
//     }
//     Result temp("sdwt", scale, pattern, wStdev);
//     results.push_back(temp);
//     delete wavelet;
// }
// 
//-----------------------------------------------------------------------------
// display a list of options
//
void Analyse::ShowOptions()
{
    cout << "\n\nANALYSE INTERACTIVE MENU.\n";
    cout << "------------------------------\n\n";
    cout << "Choose an option:\n\n";
    cout << "Load <filename> - load a file\n";
    cout << "Allan <window size> - run Allan factor analysis for the window size\n";
    cout << "AppEnt <pattern length> <tolerance> - run Approximate Entropy analysis\n";
    cout << "CCM (Complex Correlation Measure after Karmaker, 2009)\n";
    cout << "Choose <start> <length> <Skip size> <Repeats>\n";
    cout << "     - take a sub sample: absolute numbers or proportion\n";
    cout << "     - any subsequent analysis is done on the sample only\n";
    cout << "Dfa <nfit> <minbox> <maxbox> <slide>\n";
    cout << "     - run Detrended Fluctuation Analysis with:\n";
    cout << "     - nfit: order of the regression fit\n";
    cout << "     - minbox, maxbox: range of box sizes\n";
    cout << "     - slide: sliding windows mode (default is non-overlapping windows)\n";
    cout << "Diff <diff | abs | sign> <dx>\n";
    cout << "     - signed diff, abs diff or sign of difference (dx)\n";
    cout << "     - dx means differential (dy/dx) instead of difference\n";
    cout << "Exit - exit program\n";
    cout << "Fract <r sq.> - Fractal Dimension using ruler method\n";
    cout << "Help - show options\n";
    cout << "Moments <max> - calculate moments up to max\n";
    cout << "Normalise <range | mean | stdev>\n";
    cout << "     - Either make range 0 to 1, or make mean 0, or make mean 0 and stdev 1\n";
    cout << "Options - show options\n";
    cout << "Outlier <units> <none | median | mean | inter> - set params for detecting and treating outliers.\n";
    cout << "     - First parameter - detect if more than <units> IQR units above/below quartile\n";
    cout << "     - Second parameter (optional) - replace outlier, or interpolate previous & next\n";
    cout << "Regress <scale | length> <points> <logx> <logy>\n";
    cout << "RenHist <exponent> <bin count> <tolerance> <min> <max>\n";
    cout << "     - calc Renyi Entropy using histogram method\n";
    cout << "Renyi <pattern length> <tolerance> <exponent> - run Renyi Entropy\n";
    cout << "SampEnt <pattern length> <tolerance> - run Sample Entropy analysis\n";
    cout << "Scale <factor> - down-sample / coarse-grain by factor between 1 and 1000\n";
    cout << "SDWT <pattern length> - Standard Deviation of the Wavelet Transform\n";
    cout << "verbose <level> -  set verbose mode to given level\n";
    cout << endl;
}

//-----------------------------------------------------------------------------
// summary statistics for the selected portion of the dataset only
//
void Analyse::Statistics()
{
    long maxlength = dataWind + ((dataReps - 1) * dataSkip);
    long maxlimit = dataStrt + maxlength;
    
    double sum = 0.0;
    dataMax = DBL_MIN;
    dataMin = DBL_MAX;
    double last = 0.0;
    double rmssd = 0.0;
    
    for (long index=dataStrt; index<maxlimit; index++)
    {
        if (vecData[index] > dataMax)
        {
            dataMax = vecData[index];
        }
        if (vecData[index] < dataMin)
        {
            dataMin = vecData[index];
        }
        sum += vecData[index];
        if (index > dataStrt)
        {
            rmssd += pow(vecData[index] - last, 2);
        }
        last = vecData[index];
    }
    mean = sum / maxlength;
    rmssd = sqrt(rmssd / maxlength);
    
    // calculate standard deviation
    variance = 0.0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        variance += pow(mean - vecData[index], 2.0);
    }
    //cout << variance << endl;
    variance /= (maxlength - 1);
    stdev = sqrt(variance);
    
    // calculate median
    variance = 0.0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        variance += pow(mean - vecData[index], 2.0);
    }
    
    // calculate median
    double median = 0.0;
    double quart1 = 0.0;
    double quart3 = 0.0;
    // copy selected part of data
    vector <double> vecSort(vecData.begin() + dataStrt, vecData.begin() + maxlimit);
    sort(vecSort.begin(), vecSort.end());
    if (vecSort.size() % 2 == 1)   // odd number of entries
    {
        int ndxCentre = (vecSort.size() - 1) / 2;
        median = vecSort[ndxCentre];
        quart1 = vecSort[ndxCentre / 2];
        quart3 = vecSort[ndxCentre * 3 / 2];
    }
    else   // even number of entries
    {
        int ndxCentre = vecSort.size() / 2;
        median = (vecSort[ndxCentre] + vecData[ndxCentre-1]) / 2;
        quart1 = vecSort[ndxCentre / 2];
        quart3 = vecSort[ndxCentre * 3 / 2];
    }
    double lower = quart1 - outSize * (quart3 - quart1);
    double upper = quart3 + outSize * (quart3 - quart1);
    if (verbose > 1)
    {
        printf("median %f (IRQ %f to %f) %f %f\n", median, quart1, quart3, lower, upper);
    }
    
    // check for possible ectopic intervals
    // outSize - detect if more than outSize IQR units above/below quartile\n";
    // outType - replace outlier with median, mean, or interpolate previous & next\n";
    long outliers = 0;
    for (long index=dataStrt; index<maxlimit; index++)
    {
        if (vecData[index] > upper || vecData[index] < lower)
        {
            outliers++;
            if (verbose > 1)
            {
                printf("outlier: %d %f (%f)\n", index, vecData[index], fabs(vecData[index] - median) / (quart3 - quart1));
            }
            switch (outType)
            {
                case 1:   // replace outlier with median
                    vecData[index] = median;
                    break;
                case 2:   // replace outlier with mean
                    vecData[index] = mean;
                    break;
                case 3:   // replace outlier with interpolated value of previous and next
                    if (index == 0 || index == vecData.size()-1)   // there is no previous or no next
                    {
                        vecData[index] = median;
                    }
                    else
                    {
                        vecData[index] = (vecData[index+1] + vecData[index-1]) / 2.0;
                    }
                    break;
            }
        }
    }
    
    if (verbose > 1)
    {
        cout << "From " << dataMin << " to " << dataMax << endl;
        cout << "stats: dataStrt maxlimit mean stdev rmssd outliers" << endl;
    }
    
    printf("stats: %d %d %f %f %f %f %d\n", dataStrt, maxlimit, mean, stdev, rmssd, median, outliers);
}

