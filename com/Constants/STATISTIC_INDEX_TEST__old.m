classdef STATISTIC_INDEX_TEST
    properties( Constant = true )      
        %-1 for all properties that are  used as seperator
%         Descriptive_Statistics = -1
%         Mean = 2
%         Median = 3
%         Mode = 4
%         Min = 5
%         Max = 6        
%         Range = 7
%         
%         Q3 = 8
%         Q1= 9
%         IQR=10
%         SD=11

%         CV=12        
%         RoCV=13
%                
%         Simple_Linear_Measures = -1
%         Length=15
%         Slope=16
%         Intercept =17
%         RobustSlope = 18
%         RobustIntercept = 19       
%       
%         Normality_Tests=-1
%         Skewness=21
%         StdErrSkewness=22
%         IsSkewness = 23
%         Kurtosis = 24
%         StdErrKurtosis=25
%         IsKurtosis = 26
        KolmogorovSmirnovTest=27
        ShapiroWilkTest=28      
        %Discrete_CS = 29
        Continious_CS = 29+1
        
%         Time_Domain = -1
%         RMS=30+2
%         RMSSD = 31+2
%         HjorthActivity = 32+2
%         HjorthMobility = 35
%         HjorthComplexity = 36
%         Jitter_Measures = 37
%         Shimmer_Measures = 38
%         Frequency_Domain = -1
%         FastLomb = 37+1 +2 %% results are store in sepearte file 
%         FFT = 37+1   +1 +2   %% results are store in sepearte file 
%         
%         Stationarity_And_Nonlinearity = -1       
        AutoCorrelation = 39+2+2
        AutoCovariance = 40   +1+1+2
        ReverseA_Test = 41      +1+1+2
      
        MovingWindowTest = 42+2+2
        %Nonlinearity_GLC = 43
        
        %Nonlinearity_VM = 45+2
        
       
        
       % Dimensions_And_Exponents = -1
        Higuchi_FD = 45+2+2
        Petrosian_FD = 47+1+2
%         Amplitude_FD =  47+1+2+1
%         Distance_FD =  47+1+2+2
%         Lintersect_FD =  47+1+2+3
%         Pintersect_FD =  47+1+2+4
%         Sign_FD =  47+1+2+5


%         FD_Moisy_Box = 47+2+2
%         FD_Linden_Box = 47+2+1+2
%         FD_nldian = 47+2+1+2+1
%         FD_nldwan = 47+2+1+2+2
        



%         FD_M=46+4+1+2+2
%         FD_C=47+4+1+2+2
%         FD_K=48+4+1+2+2
%         FD_S=49+4+1+2+2
%         mFD_Maragos = 49+4+1+1+2+2
        AlanFactor_AF = 46+4+4+1+1+2+2+5
        CorrDim_D2 = 46+9+1+1+2+2+5
        %HurstExponent_H = 47+9+1+1+2+2
        DFA = 48+9+1+1+2+2+5
        %DFA_MATS = 48+6+4+1+1+2+2
        LargestLyapunovExp_LLE = 49+5+5+1+1+2+2+5
        RQA = 50+5+5+1+1+2+2+5
        %RQA_marwan=50+5+5+1+1+2+2+1
        ExtendedPoincare_EPP = 56+5+1+1+2+2+1+5
        
        %HRA_Symmetrics = 56+5+1+1+2+1+2+1+1-1
%         EhlerIndex_EI = 56+5+1+1+2+1+2+1+1+1-1
%         PointCare = 56+5+1+1+2+1+1+2+1+1+1-1
%         AsymesticIndex_ASI=57+5+1+1+2+1+1+2+1+1+1-1
        ComplexCorrelation_CCM=52  +5+1+1 +6+1+2+1+1+2+1+1+1-1+5
        %LZC = 53+6+5+1+1+1+2+1+1+2+1+1+1-1+5
        Multiscale_LZC = 53+7+5+1+1+1+2+1+1+2+1+1+1-1+5
        
        %Other_Complexity_Measures=-1
        Permutation_JS_Complexity_PJSC = 53+14+1+1+2+1+1+2+1+1+1-1+5+1
        %EEP_Kalauzi = 53+14+1+1+2+1+1+2+1+1+1
       
        %Shannon_and_Generalised_Entropies = -1
        ShannonEntropy_SE  = 55+14+1+1+2+1+1+2+1+1+1+5+1
        RenyiEntropy_RE = 56+14+1+1+2+1+1+2+1+1+1+5+1
        TsallisEntropy_TE = 57+14+1+1+2+1+1+2+1+1+1+5+1
        AverageEntropy_AE = 58+14+1+1+2+1+1+2+1+1+1+5+1
        Entropy_of_Entropy_EoE = 59+14+1+1+2+1+1+2+1+1+1+5+1
        ToneEntropy_T_E= 60+14+1+1+2+1+1+2+1+1+1+5+1
        EntropyOfDifference_EoD = 61+14+1+1+2+1+1+2+1+1+1+5+1
        KullbachLeiblerDivergence_KLD= 62+14+1+1+2+1+1+2+1+1+1+5+1
        %Entropy_MC = 63+14+1+1+2+1+1+2+1+1+1+5
        ShannonExtropy_SEx = 63+14+1+1+2+1+1+2+1+1+1+5+1+1
        
       
        %Ordinal_Entropies = -1
        MultiscalePE_mPE = 64+7+8+1+1+2+1+1+2+1+1+1+5+1+1
        RenyiPE_RPE = 64+7+1+8+1+1+2+1+1+2+1+1+1+5+1+1
        TsallisPE_TPE = 64+17+1+1+2+1+1+2+1+1+1+5+1+1
        AmplitudeAware_PE=65+17+1+1+2+1+1+2+1+1+1+5+1+1
        edge_PE = 65+18+1+1+2+1+1+2+1+1+1+5+1+1
        ImPE = 66+18+1+1+2+1+1+2+1+1+1+5+1+1
        mPM_E = 614+1+4+6+1+1+2+1+1+2+1+1+1+5+1+1
       
        
        %Conditional_Entropies = -1        
        ConditionalEntropy_CE = 69+18+1+1+2+1+1+2+1+1+1+5+1+1
        CorrectedConditionalEntropy_CCE = 70+18+1+1+2+1+1+2+1+1+1+5+1+1
        ApEn = 78+1+4+6+1+1+2+1+1+2+1+1+1+5+1+1
        ApEn_LightWeight = 78+7+1 +5+1+2+1+1+2+1+1+1+5+1+1
        AvgApEn_Profile= 78+6  +7+1+1+2+1+1+2+1+1+1+5+1+1
        SampEn_DS = 72+7+6  +7+1+1+2+1+1+2+1+1+1+5+1+1
        SampEn_Richmond = 73+7+6  +7+1+1+2+1+1+2+1+1+1+5+1+1
        LightWeightSampEn = 73+7+1+6  +2 +6+1+2+1+1+2+1+1+1+5+1+1
        AvgSampEn_Profile = 73+22+1+1+2+1+1+2+1+1+1+5+1+1
        CosEn_And_QSE = 74+22+1+1+2+1+1+2+1+1+1+5+1+1
        FixedSampEn_fSampEn=75+22+1+1+2+1+1+2+1+1+1+5+1+1
        mSE = 76+22+1+1+2+1+1+2+1+1+1+5+1+1
        
        ComplexityIndex_CI = 77+22+1+1+2+1+1+2+1+1+1+5+1+1
        FuzzyEntropy_FE = 78+22+1+1+2+1+1+2+1+1+1+5+1+1
        FuzzyEntropy_CAFE = 79+22+1+1+2+1+1+2+1+1+1+5+1+1
       % DistributionEntropy = 75
        
        
        %Other_Entropies = -1
        RCmSE_SD = 80+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        RCmFE_SD = 81+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        RCmDE = 82+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        DistributionEntropy_DistEn = 83+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        SlopeEntropy_SlopeEn = 84+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        BubbleEntropy_BE = 85+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        PhaseEntropy_PhEn = 86+8+8+7+1+1+2+1+1+2+1+1+1+5+1+1
        MultiscalePh_MPhEn = 86+8+1+8+7+1+1+2+1+1+2+1+1+1+5+1+1
%         ModifiedmSE_MMSE = 86+8+1+8+7+1+1+1+2+1+1+2+1+1+1
%         CompositeMsE_CmSE = 86+8+1+8+7+1+1+1+1+2+1+1+2+1+1+1

        %EntropyHub_Entropies=-1
        
        Attention_AttnEn = 86+8+1+8+2  +5    +1  +1+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        CosineSimilarity_CosiEn= 86+8+1+8+4-8+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        GriddedDistributed_GridEn = 86+8+1+8+5-1    +1    +6+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        Incremental_IncrEn = 86+8+1+8+7-2+7+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        
        
        
        %Time_Frequency_Domain = -1
        SpectralEntropy_SpEn = 88+29+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        DifferentialEntropy_DiffEn = 89+29+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        
        %Nonlinearity_GLC_V1=300
        %Nonlinearity_GLC_V2=301
        %Nonlinearity_GLC_V3=302
        
        %AncillaryMethods = -1
        AutoMutualInformation_AMI = 91+29+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        FalseNearestNeighbours_FNN=92+29+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        AverageFalseNeighbours_AFN = 93+29+1+1+1+1+2+1+1+2+1+1+1+5+1+1
        CPEI_olofsen = 93+29+1+1+1+1+2+1+1+2+1+1+1+1+5+1+1

        
       
        
        %Farara_D2 = 96
        %Farara_D2_Log = 95+2
        %Farara_D2__lag1 = 97+1
        %Farara_D2__lag1_Log = 97+2
        

       
       
        
    end
    methods(Static)
    
       
    end         
end