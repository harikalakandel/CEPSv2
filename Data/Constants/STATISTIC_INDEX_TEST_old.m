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
%        Discrete_CS = 29
        Continious_CS = 29+1
        
%         Time_Domain = -1
%         RMS=30+2
%         RMSSD = 31+2
%         HjorthActivity = 32+2
%         HjorthMobility = 35
%         HjorthComplexity = 36
%         Frequency_Domain = -1
%         FastLomb = 37+1  %% results are store in sepearte file 
%         FFT = 37+1   +1    %% results are store in sepearte file 
%         
%         Stationarity_And_Nonlinearity = -1       
        AutoCorrelation = 39+2
        AutoCovariance = 40   +1+1
        ReverseA_Test = 41      +1+1
      
        MovingWindowTest = 42+2
        
        %Nonlinearity_GLC = 43
        
%         Nonlinearity_VM = 45
%         /home/deepak/workspace/matlab/Projects/cepsv2/com/ExternalPackages/FractionalDimension
%FD_Moisy_Box
%        
%         
%         Dimensions_And_Exponents = -1
        Higuchi_FD = 45+2
        Petrosian_FD = 47+1
        %BoxCount_FD = 47+2
%         FD_M=46+4
%         FD_C=47+4
%         FD_K=48+4
%         FD_S=49+4
        AlanFactor_AF = 46+4+4
        CorrDim_D2 = 46+9
        %HurstExponent_H = 47+9
        DFA = 48+9
        %DFA_MATS = 48+6+4
        LargestLyapunovExp_LLE = 49+5+5
        RQA = 50+5+5
        ExtendedPoincare_EPP = 56+5
        %AsymesticIndex_ASI=57+5
        ComplexCorrelation_CCM=52  +5 +6
        %LZC = 53+6+5
        Multiscale_LZC = 53+7+5
        
        %Other_Complexity_Measures=-1
        Permutation_JS_Complexity_PJSC = 53+14
       
        %Shannon_and_Generalised_Entropies = -1
        ShannonEntropy_SE  = 55+14
        RenyiEntropy_RE = 56+14
        TsallisEntropy_TE = 57+14
        AverageEntropy_AE = 58+14
        Entropy_of_Entropy_EoE = 59+14
        ToneEntropy_T_E= 60+14
        EntropyOfDifference_EoD = 68+7
        KullbachLeiblerDivergence_KLD= 62+14
        %Entropy_MC = 62+7+8
        
       
        %Ordinal_Entropies = -1
        MultiscalePE_mPE = 64+7+8
        RenyiPE_RPE = 64+7+1+8
        TsallisPE_TPE = 64+17
        AmplitudeAware_PE=65+17
        edge_PE = 65+18
        ImPE = 66+18
        mPM_E = 614+1+4+6
       
        
        %Conditional_Entropies = -1        
        ConditionalEntropy_CE = 69+18
        CorrectedConditionalEntropy_CCE = 70+18
        ApEn = 78+1+4+6
        ApEn_LightWeight = 78+7 +5
        AvgApEn_Profile= 78+6  +7
        SampEn_DS = 72+7+6  +7
        SampEn_Richmond = 73+7+6  +7
        LightWeightSampEn = 73+7+6  +2 +6
        AvgSampEn_Profile = 73+22
        
        
        
        CosEn_And_QSE = 74+22
        FixedSampEn_fSampEn=75+22
        mSE = 76+22
        ComplexityIndex_CI = 77+22
        FuzzyEntropy_FE = 78+22
        FuzzyEntropy_CAFE = 79+22
       % DistributionEntropy = 75
        
        
        %Other_Entropies = -1
        RCmSE_SD = 80+8+8+7
        RCmFE_SD = 81+8+8+7
        RCmDE = 82+8+8+7
        DistributionEntropy_DistEn = 83+8+8+7
        SlopeEntropy_SlopeEn = 84+8+8+7
        BubbleEntropy_BE = 85+8+8+7
        PhaseEntropy_PhEn = 86+8+8+7
        MultiscalePh_MPhEn = 86+8+1+8+7

        %EntropyHub_Entropies=-1
        
        Attention_AttnEn = 86+8+1+8+2  +5    +1  +1
        CosineSimilarity_CosiEn= 86+8+1+8+4-8
        GriddedDistributed_GridEn = 86+8+1+8+5-1    +1    +6
        Incremental_IncrEn = 86+8+1+8+7-2+7
        
        
        
        %Time_Frequency_Domain = -1
        SpectralEntropy_SpEn = 88+29
        DifferentialEntropy_DiffEn = 89+29
        
        %Nonlinearity_GLC_V1=300
        %Nonlinearity_GLC_V2=301
        %Nonlinearity_GLC_V3=302
        
        AncillaryMethods = -1
        AutoMutualInformation_AMI = 939
        FalseNearestNeighbours_FNN=92+29
        AverageFalseNeighbours_AFN = 93+29
        CPEI_olofsen = 93+29+1
       
        
        %Farara_D2 = 96
        %Farara_D2_Log = 95+2
        %Farara_D2__lag1 = 97+1
        %Farara_D2__lag1_Log = 97+2
        

       
       
        
    end
    methods(Static)
%     
%          function allLists = getAllImplementedList()
%             mc = ?STATISTIC_INDEX;
%             %% total number of statitistics we going to calculate
%             totalNumStatistics = size(mc.PropertyList,1);
%             allLists= ones(totalNumStatistics,1)==1;
%             for i=1:totalNumStatistics
%                 allLists(i,1)=STATISTIC_INDEX.isImplemented(i);
%             end
%             
%          end
% 
% 
%          function [ans]= getSubHeading(index)
%             ans = [];
%              mc = ?STATISTIC_INDEX;
%              for i=index:-1:1
%                 if mc.PropertyList(i).DefaultValue==-1
%                     ans = mc.PropertyList(i).Name;
%                     break;
%                 end
%              end
%         end
       
            
    end         
end