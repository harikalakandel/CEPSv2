

sLength=500;
m=2
rCoff=0.2;
stepEF=5;

m1= 7;
gdeN=3;   
noSector=16;


repNo=50;


  %  violetNoise(:,i)=violetnoise(500)';
  %      logMap(:,i)=getLogMap(500)';
    
  
blueNoiseCol = nan(500,repNo);
violetNoiseCol = nan(500,repNo);
LogMapCol = nan(500,repNo);


   results={};
   
   results{1,1}="Blue Noise";
   
   results{1,8}="Violet Noise";
   
   results{1,15}="Log Map";
   
   results{2,1}="FuzzyEn";
   results{2,2}="SampEn";
   results{2,3}="AppEn";
   
     results{2,4}="PermEn";
   results{2,5}="bubbleEn";
   
      
   results{2,6}="PhEn";
   
   
    
 
   
   results{2,1+7}="FuzzyEn";
   results{2,2+7}="SampEn";
   results{2,3+7}="AppEn";   
     results{2,4+7}="PermEn";
   results{2,5+7}="BubbleEn";       
   results{2,6+7}="PhEn";
   
   
   results{2,1+14}="FuzzyEn";
   results{2,2+14}="SampEn";
   results{2,3+14}="AppEn";
   
     results{2,4+14}="PermEn";
   
   
       results{2,5+14}="BubbleEn";
   results{2,6+14}="PhEn";
   
    for i=1:repNo
        cd('../../../ExternalPackages/noiseGenerator')
        blueNoiseCol(:,i)=bluenoise(500)';
        cd('../../../com/algorithms/PhaseEntropy/workWithNoise')   
        
        m=2;
        rCoeff=0.2;
        r = rCoeff*std(blueNoiseCol(:,i));
        exFunc= 5;
        tau = 1;%%%%%%?????????
        scale = 1;%%???????????
      
        %%fuzzyEntropy
         cd('../../../ExternalPackages/FuzzyEntropy_Matlab-master');
         results{i+2,1}=FuzEn_MFs(blueNoiseCol(:,i)',m,"Constant_Gaussian",r,0,tau);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        %%sampleEntroy
        cd('../../../ExternalPackages/DataShare');
        results{i+2,2}=SampEn(blueNoiseCol(:,i)',m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')     
        %%AppEntropy
          cd('../../../ExternalPackages/Entropy_measures');
        results{i+2,3}=ApEn(blueNoiseCol(:,i),m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
            
        m=7;
            
            
        %%Permutation Entropy
        cd('../../../ExternalPackages/MPerm');
          results{i+2,4}=MPerm(blueNoiseCol(:,i),m,tau,scale);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
         %%bubble Entropy
          cd('../../bubbleEntropy');
          results{i+2,5}=getBubbleEn(blueNoiseCol(:,i)',m,false);
         cd('../PhaseEntropy/workWithNoise')  
          
          noSector=16;
            %%phEntropy
          cd('../')
          results{i+2,6}=getPhEntropyV1_Corrected(blueNoiseCol(:,i),noSector);
           cd('workWithNoise')

        
    end

    
    
     for i=1:repNo
        cd('../../../ExternalPackages/noiseGenerator')
        violetNoiseCol(:,i)=violetnoise(500)';
        cd('../../../com/algorithms/PhaseEntropy/workWithNoise')   
        
        m=2;
        rCoeff=0.2;
        r = rCoeff*std(violetNoiseCol(:,i));
        exFunc= 5;
        tau = 1;%%%%%%?????????
        scale = 1;%%???????????
      
        %%fuzzyEntropy
         cd('../../../ExternalPackages/FuzzyEntropy_Matlab-master');
         results{i+2,1+7}=FuzEn_MFs(violetNoiseCol(:,i)',m,"Constant_Gaussian",r,0,tau);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        %%sampleEntroy
        cd('../../../ExternalPackages/DataShare');
        results{i+2,2+7}=SampEn(violetNoiseCol(:,i)',m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')     
        %%AppEntropy
          cd('../../../ExternalPackages/Entropy_measures');
        results{i+2,3+7}=ApEn(violetNoiseCol(:,i),m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
            
        m=7;
            
            
        %%Permutation Entropy
        cd('../../../ExternalPackages/MPerm');
          results{i+2,4+7}=MPerm(violetNoiseCol(:,i),m,tau,scale);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
         %%bubble Entropy
          cd('../../bubbleEntropy');
          results{i+2,5+7}=getBubbleEn(violetNoiseCol(:,i)',m,false);
         cd('../PhaseEntropy/workWithNoise')  
          
          noSector=16;
            %%phEntropy
          cd('../')
          results{i+2,6+7}=getPhEntropyV1_Corrected(violetNoiseCol(:,i),noSector);
           cd('workWithNoise')

        
     end
    
     mu=4;
     
     
     for i=1:repNo
        cd('../../../ExternalPackages/noiseGenerator/Chaotic Systems Toolbox')
        LogMapCol(:,i)=logistic(500);
        cd('../../../../com/algorithms/PhaseEntropy/workWithNoise')   
        
        m=2;
        rCoeff=0.2;
        r = rCoeff*std(LogMapCol(:,i));
        exFunc= 5;
        tau = 1;%%%%%%?????????
        scale = 1;%%???????????
      
        %%fuzzyEntropy
         cd('../../../ExternalPackages/FuzzyEntropy_Matlab-master');
         results{i+2,1+14}=FuzEn_MFs(LogMapCol(:,i)',m,"Constant_Gaussian",r,0,tau);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        %%sampleEntroy
        cd('../../../ExternalPackages/DataShare');
        results{i+2,2+14}=SampEn(LogMapCol(:,i)',m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')     
        %%AppEntropy
          cd('../../../ExternalPackages/Entropy_measures');
        results{i+2,3+14}=ApEn(LogMapCol(:,i),m,r);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
            
        m=7;
            
            
        %%Permutation Entropy
        cd('../../../ExternalPackages/MPerm');
          results{i+2,4+14}=MPerm(LogMapCol(:,i),m,tau,scale);
        cd('../../algorithms/PhaseEntropy/workWithNoise')  
        
         %%bubble Entropy
          cd('../../bubbleEntropy');
          results{i+2,5+14}=getBubbleEn(LogMapCol(:,i)',m,false);
         cd('../PhaseEntropy/workWithNoise')  
          
          noSector=16;
            %%phEntropy
          cd('../')
          results{i+2,6+14}=getPhEntropyV1_Corrected(LogMapCol(:,i),noSector);
           cd('workWithNoise')

        
     end
     
     
     
     
     
    
    
      
      
      
      
