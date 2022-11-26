classdef UTIL_PROCESS_DATA
    %UTIL_PROCESS_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
        
        function [truncatedDataSet]=getTruncatedDataSet(RawData,tIndexSet)
            truncatedDataSet = RawData;
            try
                for i=size(tIndexSet,1):-1:1
                    
                    truncatedDataSet(tIndexSet(i,1):tIndexSet(i,2),:)=[];
                end
            catch
                x=1;
            end
        end
        
     
                
        function [data,OutlierInfo]=processData(app,data,flagRemoveO,flagMedianFilter,flagApplyFilter,outlierM_Width,outlierWindowL,medianFOrder,lowPass,highPass)
            
            
            OutlierInfo = [];
            
            
         
            
            
            %if app.chkRemoveOutliers.Value ==1
            if flagRemoveO
                [data,OutlierInfo]= UTIL_PROCESS_DATA.removeOutliers(app,data,outlierM_Width,outlierWindowL);
            end
            %if app.chkMedianFilter.Value ==1
            if flagMedianFilter
                data=medfilt1(data,medianFOrder);
            end
            
            %if app.chkApplyFilter.Value==1
            if flagApplyFilter
                cd('../com/ExternalPackages/RecurrencePlot_ToolBox')
                
                data=fftfilter(data,lowPass,highPass);
                
                cd('../../../scripts')
            end
            
            
            
        end
        
        function [data, OutlierInfo] = removeOutliers(app,data,outlierM_Width,outlierWindowL)
            
            
            %% need to redefine getOutliersListTF for multi dimensional array
            OutlierInfo=[];
            startIndex=1;
            
            
            
            
            
%             %% removing dataset over whole dataset
%             if perEpoch
%                 windowLength=size(data,1);
%             else
%                 windowLength = str2double(app.editSampleR.Value)*str2double(app.editEpochT.Value);
%             end
            
            
            while startIndex<=size(data,1)
                endIndex=min(startIndex+outlierWindowL-1,size(data,1));
                
                %outerMWidth = str2num(app.editOutlierMW.Value);
                try
                for v=1:size(data,2)
                    cd('../com/algorithms');
                    try
                    OutlierList = getOutliersListTF(data(startIndex:endIndex,v))+startIndex-1;
                    catch
                        x=100
                    end
                    cd('../../scripts');
                    %OutlierList=[OutlierList nan(size(OutlierList))];
                    
                    for oIndex=OutlierList(:,1)'
                        try
                            lIndex = max(1,oIndex-outlierM_Width);
                        catch
                            x=100000;
                        end
                        uIndex = min(size(data,v),oIndex+outlierM_Width);
                        replaceVal = median([data(lIndex:oIndex-1,v)' data(oIndex+1:uIndex,v)']);
                        %% feature Index rowID originalData repalcedData
                        OutlierInfo=[OutlierInfo;v oIndex data(oIndex,1) replaceVal];
                        data(oIndex,v)=replaceVal;
                        %OutlierList(oIndex,2)=replaceVal;
                        
                    end
                end
                catch
                    x=66666;
                end
               
                startIndex = endIndex+1;
            end
           
        end
        function [currIndex]=mergeOverlapping(currIndex)
            
            currIndex = sortrows(currIndex,1);
            i=1;
            while true
                if currIndex(i,2) >= currIndex(i+1,1)
                    currIndex(i,2)=max(currIndex(i,2), currIndex(i+1,2));
                    currIndex(i+1,:)=[];
                else
                    %% if current row is not merge move to next row
                    i=i+1;
                end
                %% if all rows are check break out of the loop
                if i>=size(currIndex,1)
                    break;
                end
            end
        end
        
        function [noisyData,info]=addNoise(app,data)
             N=size(data,1);
            
            
            cd('../com/ExternalPackages/noiseGenerator');
            blendingCoff = str2num(app.editNoiseWaveFrequecy.Value)/100;
            info = strcat(app.pMenuNoiseType.Value,' BlendCoff: ',num2str(blendingCoff))
            maxValue = max(data);
            minValue = min(data);
            waveFreq = str2double(app.editNoiseWaveFrequecy.Value);
            waveAmp = str2double(app.editWaveAmplitude.Value);
            fs = str2double(app.editSampleR.Value);
            if strcmp(app.pMenuNoiseType.Value,"White Noise")==1
               myNoise=rand(N,1);
              
                
            elseif strcmp(app.pMenuNoiseType.Value,"Blue Noise")==1
                    myNoise=bluenoise(N)';
                    
            elseif strcmp(app.pMenuNoiseType.Value,"Pink Noise")==1
                    myNoise=pinknoise(N)';
                    
            elseif strcmp(app.pMenuNoiseType.Value,"Violet Noise")==1
                    myNoise=violetnoise(N)';
            elseif strcmp(app.pMenuNoiseType.Value,"Red Noise")==1
                    myNoise=rednoise(N)';
            elseif strcmp(app.pMenuNoiseType.Value,"Sine Wave")==1
                    myNoise=getSineWave(fs,waveFreq,N,waveAmp);
            elseif strcmp(app.pMenuNoiseType.Value,"Cosine Wave")==1
                    myNoise=getCosineWave(fs,waveFreq,N,waveAmp);
            end
            noisyData = data + ((maxValue-minValue)*blendingCoff*myNoise(1:N,1));
            cd('../../../scripts')
            
            
        end


        function [noise] = getOnlyNoise(app)
           
            
           
            cd('../com/ExternalPackages/noiseGenerator');
            blendingCoff = str2num(app.editNoiseWaveFrequecy.Value)/100;
           
            maxValue = 1;
            minValue = 100;
            waveFreq = str2double(app.editNoiseWaveFrequecy.Value);
            waveAmp = str2double(app.editWaveAmplitude.Value);
            fs = str2double(app.editSampleR.Value);
            N = 5 * fs;
            if strcmp(app.pMenuNoiseType.Value,"White Noise")==1
               myNoise=rand(N,1);
              
                
            elseif strcmp(app.pMenuNoiseType.Value,"Blue Noise")==1
                    myNoise=bluenoise(N)';
                    
            elseif strcmp(app.pMenuNoiseType.Value,"Pink Noise")==1
                    myNoise=pinknoise(N)';
                    
            elseif strcmp(app.pMenuNoiseType.Value,"Violet Noise")==1
                    myNoise=violetnoise(N)';
            elseif strcmp(app.pMenuNoiseType.Value,"Red Noise")==1
                    myNoise=rednoise(N)';
            elseif strcmp(app.pMenuNoiseType.Value,"Sine Wave")==1
                    myNoise=getSineWave(fs,waveFreq,N,waveAmp);
            elseif strcmp(app.pMenuNoiseType.Value,"Cosine Wave")==1
                    myNoise=getCosineWave(fs,waveFreq,N,waveAmp);
            end
            cd('../../../scripts')
            noise = ((maxValue-minValue)*blendingCoff*myNoise(1:N,1));
           
            
            
        end



        
        function plotDataFigures(app)
            global RawDataSet
            global PreprocessedDataSet
            global dataDeletedIndex
            global ALL_StatisticCol
            
            global leftLocUp
            global rightLocUp
            
            global legendIndex
            
            
            %^%choose particular data file...
            selFileIndex = find(strcmp(app.pMenuFileNames.Items,app.pMenuFileNames.Value))-2 ;
            if selFileIndex<=0
                msgbox('Please select a data file');
                return
            end
            selDimensionIndex = find(strcmp(app.pMenuDimension.Items,app.pMenuDimension.Value))-2
            if selDimensionIndex<=0
                msgbox('Please select a data column');
                return
            end
            
           
            if isempty(legendIndex) | sum(legendIndex(:,1)==selFileIndex & legendIndex(:,2)==selDimensionIndex)==0
                legendIndex=[legendIndex ;selFileIndex selDimensionIndex];
            end
            
            
            
            cla(app.myAxesDown);
            cla(app.myAxesUp);
            data = RawDataSet{selFileIndex,1}(:,selDimensionIndex);
            
            %dataTruncated = TruncatedDataSet{selIndex,1};
            datProcessed = PreprocessedDataSet{selFileIndex,1}(:,selDimensionIndex);
            %myLegendDown={'Pre-processed Data'};
            %             %% choose particular feature
            
            
            
            
            
            % hold(app.myAxesDown,'on')
            plot(app.myAxesDown,datProcessed,'color','blue');
            
            if app.chkShowOutliers.Value==1
                
                try
                    OutlierInfoCol = ALL_StatisticCol{selFileIndex,CONS_INDEX.outliers};
                    if size(OutlierInfoCol,1)>0
                        hold(app.myAxesDown,'on');
                        plot(app.myAxesDown,OutlierInfoCol(:,1),OutlierInfoCol(:,2),'*','color','red');
                    end
                catch
                    x=1
                end
                
                
            end
            
            
            %             if app.chkShowTruncatedData.Value==1 && size(dataDeletedIndex{selFileIndex,selDimensionIndex},1)>0
            %                 truncatedData = UTIL_PROCESS_DATA.getTruncatedDataSet(data,dataDeletedIndex{selFileIndex,selDimensionIndex});
            %                 hold(app.myAxesDown,'on')
            %                 plot(app.myAxesDown,truncatedData,'color','green');
            %                 myLegendDown={'Pre-processed Data','Truncated Data'};
            %             end
            % legend(app.myAxesDown,myLegendDown)
            
            if app.chkShowTruncatedData.Value==1
                %                 if isempty(myLegend)
                %                     myLegend{1,1}='Raw data';
                %                 elseif isempty(find(strcmp(myLegend,'Raw data')))
                %                     myLegend{1,size(myLegend,2)+1}='Raw data';
                %                 end
                
                lowerLimit = min(data);
                upperLimit = max(data);
                
                
                
                    if ~isempty(leftLocUp) & ~isempty(rightLocUp)
                        hold(app.myAxesUp,'on')
                        rectangle(app.myAxesUp,'Position',[leftLocUp, lowerLimit,rightLocUp-leftLocUp,upperLimit-lowerLimit],'Curvature', 0.2,'FaceColor', [1, 0, 0, 0.7],'EdgeColor', [1, 0, 0, 0.7]);
                    else
                        if ~isempty(leftLocUp)
                            hold(app.myAxesUp,'on')
                            plot(app.myAxesUp,[leftLocUp,leftLocUp],[lowerLimit,upperLimit],'color','red');
                        end
                        if ~isempty(rightLocUp)
                            hold(app.myAxesUp,'on')
                            plot(app.myAxesUp,[rightLocUp,rightLocUp],[lowerLimit,upperLimit],'color','blue');
                        end
                    end
                
                
                %% display all deleted data range in a box....
                try
                    currDeletedInfo = dataDeletedIndex{selFileIndex,1};
                    for i=1:size(currDeletedInfo,1)
                        hold(app.myAxesUp,'on')
                        %plot(app.myAxesUp,[currDeletedInfo(i,1),currDeletedInfo(i,2)],[lowerLimit,upperLimit],'color','red');
                        rectangle(app.myAxesUp,'Position',[currDeletedInfo(i,1), lowerLimit,currDeletedInfo(i,2)-currDeletedInfo(i,1),upperLimit-lowerLimit],'Curvature', 0.2,'FaceColor', [1, 0, 0, 0.7],'EdgeColor', [1, 0, 0, 0.7]);
                    end
                catch
                    x=1;
                    %% no date is truncated/deleted......
                end
                
               % plot(app.myAxesUp,data,'ButtonDownFcn',{@UTIL_PROCESS_DATA.TestMe,app,1},'color','black');
            else
                if ~isempty(dataDeletedIndex) && ~ isempty(dataDeletedIndex{selFileIndex,1})
                    data = UTIL_PROCESS_DATA.getTruncatedDataSet(data,dataDeletedIndex{selFileIndex,1});
                
                end
               % plot(app.myAxesUp,truncatedData,'color','black');
            end
            plot(app.myAxesUp,data,'ButtonDownFcn',{@UTIL_PROCESS_DATA.TestMe,app,1},'color','black');
%             legendText={};
%             for i=1:size(legendIndex,1)
%                 legendText{1,i}=strcat('File :',num2str(legendIndex(i,1)),' Dimension :',num2str(legendIndex(i,2)))
%             end
%             legend(app.myAxesUp,legendText)
            
            
            
        end
        
        function TestMe(axis, ObjectH, app,id)
            
            global leftLocUp
            global rightLocUp
            
            
            
            %% move the figure option to selected axes.
            % app.pMenuFigureNo.Value = app.pMenuFigureNo.Items(id);
            
            %   if id==1
            
            coordinates = app.myAxesUp.CurrentPoint;
            if strcmp(get(gcbf,'selectiontype'),'alt')
                rightLocUp = coordinates(1,1);
                %% clear the left mark to delte if it is after right mark to delete
                if ~isempty(leftLocUp) & rightLocUp <=leftLocUp
                    leftLocUp=[];
                end
                
            elseif strcmp(get(gcbf,'selectiontype'),'normal')
                leftLocUp = coordinates(1,1);
                %% clear the left mark to delte if it is after right mark to delete
                if ~isempty(rightLocUp) & leftLocUp >=rightLocUp
                    rightLocUp=[];
                end
            end
            
            UTIL_PROCESS_DATA.plotDataFigures(app);
            
            
            %             else
            %
            %                 coordinates = app.myAxesDown.CurrentPoint;
            %                 if strcmp(get(gcbf,'selectiontype'),'alt')
            %                     rightLocDown = coordinates(1,1);
            %                     %% clear the left mark to delte if it is after right mark to delete
            %                     if ~isempty(leftLocDown) & rightLocDown <=leftLocDown
            %                         leftLocDown=[];
            %                     end
            %
            %                 elseif strcmp(get(gcbf,'selectiontype'),'normal')
            %                     leftLocDown = coordinates(1,1);
            %                     %% clear the left mark to delte if it is after right mark to delete
            %                     if ~isempty(rightLocDown) & leftLocDown >=rightLocDown
            %                         rightLocDown=[];
            %                     end
            %                 end
            %
            %                 UTIL_PROCESS_DATA.plotDataFigures(app);
            
            
            %     end
        end
        
        
    end
end

