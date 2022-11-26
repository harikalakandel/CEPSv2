/******************************************************************************

Program does various types of analysis on ECG recordings

Author: D. Cornforth

******************************************************************************/
#ifndef ANALYSE_H
#define ANALYSE_H



static const int DEFAULT_PATTERN = 2;
static const int DEFAULT_PATTERN_MIN = 1;
static const int DEFAULT_PATTERN_MAX = 1000;

static const int DEFAULT_BINS = 20;
static const int DEFAULT_BINS_MIN = 2;
static const int DEFAULT_BINS_MAX = 100;

static const double DEFAULT_RSQ = 0.996;
static const double DEFAULT_RSQ_MIN = 0.0;
static const double DEFAULT_RSQ_MAX = 1.0;

static const int DEFAULT_SCALE_MIN = 1;
static const int DEFAULT_SCALE_MAX = 1000;
static const int DEFAULT_SCALE = 1;

static const int DEFAULT_OUTSIZE = 10;
static const int DEFAULT_OUTSIZE_MIN = 1.5;

static const double DEFAULT_TOLERANCE = 0.15;
static const double DEFAULT_TOLERANCE_MIN = 0.000001;
static const double DEFAULT_TOLERANCE_MAX = 1000;

static const double DEFAULT_WINDOW = 10;
static const double DEFAULT_WINDOW_MIN = 0.001;
static const double DEFAULT_WINDOW_MAX = 1000000;

static const double DEFAULT_EXPONENT = 2.0;
static const double DEFAULT_EXPONENT_MIN = -100.0;
static const double DEFAULT_EXPONENT_MAX = 100.0;

static const int FILTER_LENGTH = 5;
static const int DEFAULT_MOMENTS = 5;
static const int DEFAULT_MOMENTS_MAX = 100;

//-----------------------------------------------------------------------------
// helper class to store a complete result for one calculation
//
class Result
{
  public:
    string name;
    double x[2];
    double y;
    Result (string, double, double, double);
};

//-----------------------------------------------------------------------------
// constructor
//
Result::Result (string n, double x1 , double x2, double yy)
{
  name = n;
  x[0] = x1;
  x[1] = x2;
  y = yy;
}

//-----------------------------------------------------------------------------
// main class
//
class Analyse
{
  private:
    vector <double> vecData;
    vector <Result> results;
    double *probability;
    long dataStrt, dataWind;
    int dataSkip, dataReps;
		int scale;   // scale to use for downsampling
    double dataMax;
    double dataMin;
    double mean;
    double variance;   // variance of RR intervals
    double stdev;
    double skew;
    double kurt;
    double outSize;   // size of outlier allowed
    int outType;   // method to treat outliers
    int verbose;
    int last_pattern;
    double last_tolerance;
  public:
    Analyse(void);
    ~Analyse(void);
    void AllanFactor(char*);
    void ApproxEntropy(char*);
    void BatchMode(char*);
    void CCM(char*);
    void Choose(char*);
    void Dfa(char*);
    void Diff(char*);
    void FileRead(char*);
    void FractalDimension(char*);
    void Interactive();
    void MultiScaleEntropy(char*);
    bool Menu(char*);
		void Moments(char*);
    void Normalise(char*);
    void OutlierParams(char*);
    void Regression(char*);
    void RenyiDivergence(char*);
    void RenyiEntropy(char*);
    void RenyiHistogram(char*);
    void RenyiProbs(int, int, double);
    double SampleEntropy(int, double);
    void Scale(char*);
    Result Slope(double*, double*, int, int);
    void StdevWavelet(char*);
    void ShowOptions();
    void Statistics();
};

//------------------------------------------------------------------------
// Convert string to lower case
//
void lower(char* mixed)
{
  for (char* ptr=mixed; *ptr!=0; ptr++)
  {
    *ptr = tolower (*ptr);
  }
}

//------------------------------------------------------------------------
// Get minimum of three values, ignoring NaNs
//
double min3(double val1, double val2, double val3)
{
    double answer = val1;
    if (val2 < answer)
	{
      answer = val2;
	}
    if (val3 < answer)
	{
      answer = val3;
	}
	
    return answer;
}

//------------------------------------------------------------------------
// Get maximum of three values, ignoring NaNs
//
double max3(double val1, double val2, double val3)
{
    double answer = val1;
    if (val2 > answer)
	{
      answer = val2;
	}
    if (val3 > answer)
	{
      answer = val3;
	}
	
    return answer;
}

//------------------------------------------------------------------------
// Choose best of 2 values, do not use NaNs
//
double choose2(double val1, double val2)
{
    double answer = 0.0;   // default if both are NaNs
	
	// case 1: both values OK
	if(!isnan(val1) && !isnan(val2))
	{
		answer = (val1 + val2) / 2.0;
	}
	else if (!isnan(val1) && isnan(val2))
	{
		answer = val1;
	}
	else if (isnan(val1) && !isnan(val2))
	{
		answer = val2;
	}
	
    return answer;
}

#endif
