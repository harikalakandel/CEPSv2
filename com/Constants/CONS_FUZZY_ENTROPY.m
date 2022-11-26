classdef CONS_FUZZY_ENTROPY
    properties( Constant = true )
        Triangular=1
        Trapezoidal=2
        Z_shaped=3
%         Bell_shaped_N2=4
%         Bell_shaped_N3=5
        Gaussian=4
        Constant_Gaussian=5
%         Exponential_N3=8
%         Exponential_N4 = 9
          
    end

    methods(Static)
    
        function rVal = getRnValue(index)
            rVal = -999;
            if index==CONS_FUZZY_ENTROPY.Triangular
                rVal= 0.3;
            elseif index==CONS_FUZZY_ENTROPY.Z_shaped
                rVal=  0.1286;
            elseif index==CONS_FUZZY_ENTROPY.Trapezoidal
                rVal=  2.8691;
%                 
%             elseif index==CONS_FUZZY_ENTROPY.Bell_shaped_N2
%                 rVal=  0.1414;
%                 
%             elseif index==CONS_FUZZY_ENTROPY.Bell_shaped_N3
%                 rVal=  0.1732;                
            elseif index==CONS_FUZZY_ENTROPY.Gaussian
                rVal=  0.1253;
            elseif index==CONS_FUZZY_ENTROPY.Constant_Gaussian
                rVal=  0.0903;
%             elseif index==CONS_FUZZY_ENTROPY.Exponential_N3
%                 rVal=  0.0077;                
%              elseif index==CONS_FUZZY_ENTROPY.Exponential_N4
%                 rVal=  0.0018;
            end
        end
            
       
       function mfName = getMembershipFName(index)
            mfName = "";
            if index==CONS_FUZZY_ENTROPY.Triangular
                mfName= "Triangular";
            elseif index==CONS_FUZZY_ENTROPY.Z_shaped
                mfName= "Z_shaped";
            elseif index==CONS_FUZZY_ENTROPY.Trapezoidal
                mfName= "Trapezoidal";
                
%             elseif index==CONS_FUZZY_ENTROPY.Bell_shaped_N2
%                 mfName= "Bell_shaped";
%                 
%             elseif index==CONS_FUZZY_ENTROPY.Bell_shaped_N3
%                 mfName= "Bell_shaped";            
            elseif index==CONS_FUZZY_ENTROPY.Gaussian
                mfName= "Gaussian";         
                
             elseif index==CONS_FUZZY_ENTROPY.Constant_Gaussian
                mfName= "Constant_Gaussian";            
%                 
%              elseif index==CONS_FUZZY_ENTROPY.Exponential_N3
%                 mfName= "Exponential";            
%              elseif index==CONS_FUZZY_ENTROPY.Exponential_N4
%                 mfName= "Exponential";
            end
       
        end
        
       
    end
end

