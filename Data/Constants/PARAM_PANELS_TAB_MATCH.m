classdef PARAM_PANELS_TAB_MATCH
    %METHODS_PANELS Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
       
        function panelName = getPanelNameByDesc(panelDesc)
            panelName='notDefined';
           
            if strcmp(panelDesc,METHODS_PANELS.normalityTest)
                panelName = 'uiPanelNormalityTest';
            elseif strcmp(panelDesc,METHODS_PANELS.stationaryAndNonlinearity)
                panelName = 'uiPanelStationarityAndN';
            elseif strcmp(panelDesc,METHODS_PANELS.dimensionalAndExponents)
                panelName = 'uiPanelDimensionsAndE'; 
                
            elseif strcmp(panelDesc,METHODS_PANELS.ordinalEntropies)
                panelName = 'uiPanelOrdinalE'; 
            elseif strcmp(panelDesc,METHODS_PANELS.conditionalEntropies)
                panelName = 'uiPanelConditionalE'; 
                
            elseif strcmp(panelDesc,METHODS_PANELS.otherEntropies)
                panelName = 'uiPanelOtherE';
          
            elseif strcmp(panelDesc,METHODS_PANELS.ancillaryMethods)
                panelName = 'uiPanelAncillaryMethods';
            elseif strcmp(panelDesc,METHODS_PANELS.shannonAndGeneralisedEntropies)
                panelName = 'uiPanelShannnonGEntropies';
                
                
%             elseif strcmp(panelDesc,METHODS_PANELS.timeDomain)
%                 panelName = 'uiPanelTimeDomain';
%             elseif strcmp(panelDesc,METHODS_PANELS.frequencyDomain)
%                 panelName = 'uiPanelFrequencyDomain';
%            elseif strcmp(panelDesc,METHODS_PANELS.frequencyDomain)
%                 panelName = 'uiPanelFrequencyDomain';
            else
                x=1;
            end
            
        end
        
        function panelName = getPanelNameByConst(panelConst)
            try
                panelName = METHODS_PANELS.getPanelNameByDesc(eval(strcat('METHODS_PANELS.',panelConst)))
            catch
                x=1
            end
        end
    end
   
    properties( Constant = true )
        normalityTest='Normality Test';       
        stationaryAndNonlinearity='Stationary & Nonlinearity';        
        ordinalEntropies='Ordinal Entropies';
        
        otherEntropies='Other Entropies';
        conditionalEntropies='Conditional Entropies';
        dimensionalAndExponents='Dimensional & Exponents';
        ancillaryMethods="Ancillary Methods";
        shannonAndGeneralisedEntropies="Shannnon & Generalised Entrpoies"
        
        %milicious='Mi.......'
        %timeDomain = 'Time Domain ';
        %frequencyDomain='Frequency Domain';

    end
          


end

