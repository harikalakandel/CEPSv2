function RQA = getRQA_marwan(data)


    
    %x1 = sawtooth(2*pi*f0*t,0.25);
    
   
    
    %% only getting result with T
    
    
    epsilon=0.01;Centering=0;display=0;m=2;
    [SPt]=SymPlot_JMGi(data,'T',m,epsilon,Centering,display);
    
    RQA = rqa_marwan(SPt)

end

