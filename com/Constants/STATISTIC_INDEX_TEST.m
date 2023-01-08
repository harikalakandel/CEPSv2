classdef STATISTIC_INDEX_TEST
    properties( Constant = true )      
        %-1 for all properties that are  used as seperator
%         Descriptive_Statistics = -1 %1
%         Mean = 2 
%         Median = 3
%         Mode = 4
%         Min =5
%         Max = 6        
%         Range = 7
%         
%         Q3 = 8
%         Q1= 9
%         IQR=10
%         SD=11
%         %Variance=11
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
%         Discrete_CS = 29
        Continious_CS = 30
        
%         Time_Domain = -1
%         RMS=32
%         RMSSD = 33
%         HjorthActivity = 34
%         HjorthMobility = 35
%         HjorthComplexity = 36
%         Jitter_Measures = 37
%         Shimmer_Measures = 38
%         Frequency_Domain = -1
%         FastLomb = 40 %% results are store in sepearte file 
%         FFT = 41   %% results are store in sepearte file 
%         
%         Stationarity_And_Nonlinearity = -1       
        AutoCorrelation = 43
        AutoCovariance = 44
        ReverseA_Test =45
      
        MovingWindowTest =46
        %Nonlinearity_GLC = 43
        
        Nonlinearity_VM = 47
        
       
        
        Dimensions_And_Exponents = -1
        Higuchi_FD = 49
%        Petrosian_FD = 50
%         Amplitude_FD =  51
%         Distance_FD =  52
%         Lintersect_FD =  53
%         Pintersect_FD =  54
%         Sign_FD =  55
%         FD_Moisy_Box = 56
%         FD_Linden_Box = 57
         FD_nldian = 58
         FD_nldwan = 59
%         
% 
% 
% 
%         FD_M=60
%         FD_C=61
%         FD_K=62
%         FD_S=63
         mFD_Maragos = 64
        AlanFactor_AF = 65
        CorrDim_D2 = 66
%         HurstExponent_H = 67
        DFA = 68
%         DFA_MATS = 69
        LargestLyapunovExp_LLE = 70
        RQA = 71
%         RQA_marwan=72
        ExtendedPoincare_EPP = 73
        
         HRA_PI_GI_AI_SI = 74
%         EhlerIndex_EI = 75
%         HRA_Accel_Decel = 76
%         AsymmSpreadIndex_ASI=77
        ComplexCorrelation_CCM=78
%         LZC = 79
        Multiscale_LZC = 80
        
%        Other_Complexity_Measures=-1
        Permutation_JS_Complexity_PJSC = 82
%        EEP_Kalauzi = 83
       
%        Shannon_and_Generalised_Entropies = -1
        ShannonEntropy_SE  = 85
        RenyiEntropy_RE = 86
        TsallisEntropy_TE = 87
        AverageEntropy_AE = 88
        Entropy_of_Entropy_EoE = 89
        ToneEntropy_T_E= 90
        EntropyOfDifference_EoD = 91
        KullbachLeiblerDivergence_KLD= 92
%        Entropy_MC = 93
        ShannonExtropy_SEx = 94
        
       
 %       Ordinal_Entropies = -1
        MultiscalePE_mPE = 96
        RenyiPE_RPE = 97
        TsallisPE_TPE = 98
        AmplitudeAware_PE=99
        Edge_PE = 100
        ImPE = 101
        mPM_E = 102
        CPEI_olofsen = 103
       
        
        Conditional_Entropies = -1        
        ConditionalEntropy_CE = 105
        CorrectedConditionalEntropy_CCE = 106
        ApEn = 107
        ApEn_LightWeight = 108
        AvgApEn_Profile= 108+1
        SampEn_DS = 109+1
        SampEn_Richman = 110+1
        LightWeightSampEn = 111+1
        AvgSampEn_Profile = 112+1
        CosEn_And_QSE = 113+1
        FixedSampEn_fSampEn=114+1
        mSE = 115+1
        
        ComplexityIndex_CI = 116+1
        FuzzyEntropy_FE = 117+1
        FuzzyEntropy_CAFE = 118+1
       % DistributionEntropy = 75
        
        
        Other_Entropies = -1
        RCmSE_SD = 120+1
        RCmFE_SD = 121+1
        RCmDE = 122+1
        DistributionEntropy_DistEn = 123+1
        SlopeEntropy_SlopeEn = 124+1
        BubbleEntropy_BE = 125+1
        PhaseEntropy_PhEn = 126+1
        MultiscalePhEn_mPhEn = 127+1
%         ModifiedmSE_MMSE = 128
%         CompositeMsE_CmSE = 129
%         EntropyHub_Entropies=-1
        
        Attention_AttnEn = 131+1
        CosineSimilarity_CoSiEn= 132+1
        GriddedDistEn_GDistEn = 133+1
        IncrementEntropy_IncrEn = 134+1
        
%         Time_Frequency_Domain = -1
%        SpectralEntropy_SpEn = 136
        DifferentialEntropy_DiffEn = 137+1
        
        %Nonlinearity_GLC_V1=300
        %Nonlinearity_GLC_V2=301
        %Nonlinearity_GLC_V3=302
        
%         AncillaryMethods = -1
        AutoMutualInformation_AMI = 139+1
        FalseNearestNeighbours_FNN=140+1
        AverageFalseNeighbours_AFN = 141+1
        CPEI_olofsen = 142+1

        
       
        
        %Farara_D2 = 96
        %Farara_D2_Log = 95+2
        %Farara_D2__lag1 = 97+1
        %Farara_D2__lag1_Log = 97+2
        

       
       
        
    end
    methods(Static)
    
        function obj = STATISTIC_INDEX()
            disp('object created')
        end
        
        
        function allLists = getAllImplementedList()
            mc = ?STATISTIC_INDEX;
            %% total number of statitistics we going to calculate
            totalNumStatistics = size(mc.PropertyList,1);
            allLists= ones(totalNumStatistics,1)==1;
            for i=1:totalNumStatistics
                allLists(i,1)=STATISTIC_INDEX.isImplemented(i);
            end
            
        end
            
         function [ans]= getSubHeading(index)
            ans = [];
             mc = ?STATISTIC_INDEX;
             for i=index:-1:1
                if mc.PropertyList(i).DefaultValue==-1
                    ans = mc.PropertyList(i).Name;
                    break;
                end
             end
        end
            
    end         
end