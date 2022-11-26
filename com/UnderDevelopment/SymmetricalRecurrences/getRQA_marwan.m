function RQA = getRQA_marwan(data,m,epsilon)


    
    
  
    
    
    
    
    %x1 = sawtooth(2*pi*f0*t,0.25);
    
   
    
    %% only getting result with T
    
    
    %epsilon=0.01;Centering=0;display=1;m=2;
    [SPt]=SymPlot_JMGi(data,'T',m,epsilon,0,0);
    
    RQA = rqa_marwan(SPt)

end

