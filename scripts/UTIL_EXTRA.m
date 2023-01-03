classdef UTIL_EXTRA
    %UTIL_EXTRA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end


    methods(Static)
    

        function [binaryData]=applyBinarization(currData,binarisationFID)
             binaryData=[];
             if binarisationFID ==2
                     chkValue = mean(currData);
                     binaryData = currData >= chkValue;
                    
                 elseif binarisationFID == 3
                    chkValue1 = mean(currData)-std(currData);
                    chkValue2 = mean(currData)+std(currData);
                    binaryData = (currData >= chkValue1) & (currData <= chkValue2);
                    
                    
                 elseif binarisationFID == 4
                    
                    binaryData = currData(2:end,1)>=currData(1:end-1,1);
                    
                    
                 end

                
                 
        end


        function clearDataAnalysisDisplay(app)

            app.tabDA_Fig1.Title="Fig1 Not USED";
            app.tabDA_Fig2.Title="Fig2 Not USED";
            app.tabDA_Fig3.Title="Fig2 Not USED";
            app.tabDA_Data1.Title="Data1 Not USED";
            app.tabDA_Data2.Title="Data2 Not USED";
            app.tabDA_Data3.Title="Data3 Not USED";

            app.uiTable_DA1.Data=[];
            app.uiTable_DA2.Data=[];
            app.uiTable_DA3.Data=[];
            %app.panelDA_fig1.figure=[];
            
             app.txtNAI.Text = "--";
        

        end
    
        function[dataCopies,legendText] = applyNormalization(app,normalizationList,dataCopies,legendText)
                 if size(normalizationList,2)==1

                            %for nIndex=normalizationList
                            X =dataCopies{1,1};
                            tmpData=eval(app.pMenuNormalization.Value);
                            
                            for i=1:size(dataCopies,1)
                                dataCopies{i,1}=tmpData;
                            end
                            
                        else
                            for nIndex = normalizationList
                                %% X is used inside formula in pMenuNormalization
                                X =dataCopies{nIndex-1,1};
                                dataCopies{nIndex-1,1}=eval(app.pMenuNormalization.Items{nIndex});
                                legendText{nIndex-1,1}=app.pMenuNormalization.Items{nIndex};
                            end
                        end

        end
        
        function [dataCopies,legendText]=applyFineGrane(app,interpolationList,nFineGrid,dataCopies,legendText)
                
                if size(interpolationList,2) >1
                    currData = dataCopies{1,1};
                    for i=1:size(interpolationList,2)
                        dataCopies{i,1} = interpn(currData,nFineGrid,app.pMenuIP_Method.Items{interpolationList(1,i)});
                        legendText{i,1}=app.pMenuIP_Method.Items{interpolationList(1,i)};
                    end

                else
                    for i=1:size(dataCopies,1)
                        dataCopies{i,1} = interpn(dataCopies{i,1},nFineGrid,app.pMenuIP_Method.Items{interpolationList(1,1)});
                        %legendText{i,1}=strcat(legendText{i,1},'FG - ')
                    end
                end
            
        end
                

        function [dataCopies,legendText]=applyCourseGrain(app,scaleList,slideBy,functionID,dataCopies,legendText)
            if size(scaleList,2)>1
                    %currData = PreprocessedDataSet{fileList,1};
                    currFun = app.pMenuScaleAggregate.Value;

                    
                    index=1;
                    currData=dataCopies{1,1};
                    for s=scaleList
                        startIds=1:slideBy:(size(currData,1)-s+1);
                        tmpData =[];
                       
                        legendText{index,1} = strcat('Scale - ',num2str(s));
                        for id=startIds
                            %% scale is s
                            tmpData = [tmpData eval(strcat(currFun,'(currData(id:id+s-1))'))];
                        end
                        dataCopies{index,1}=tmpData;
                        index=index+1;
                    end

                    %% trying all slides with fix scalse

                    %% coursegrain by slide
                elseif size(slideBy,2)>1
                   
                    currFun = app.pMenuScaleAggregate.Value;
                    index=1;
                    %% for all slide window from 1 to scaleList
                    currData=dataCopies{1,1};
                    for s=1:size(slideBy,2)
                        
                        startIds=1:s:(size(currData,1)-slideBy(1,s)+1);
                        tmpData =[];
                        legendText{s,1} = strcat('SlideW - ',num2str(slideBy(1,s)));
                        for id=startIds
                            %% scale is scale
                            tmpData = [tmpData eval(strcat(currFun,'(currData(id:id+slideBy(1,s)-1))'))];
                        end

                        dataCopies{index,1}=tmpData;
                        index=index+1;


                    end

                elseif size(functionID,2)>1


                   
                    scale=scaleList(1,1);
                    slide=slideBy(1,1);
                    startIds=1:slide:(size(currData,1)-scale+1);
                    
                    %%for all aggregation function except 'all' (first one)

                    currData=dataCopies{1,1};
                    for i=functionID
                       
                        currFun = app.pMenuScaleAggregate.Items{i};
                        legendText{i-1,1}=currFun;
                        tmpData =[];
                        for id=startIds
                            try
                                tmpData = [tmpData eval(strcat(currFun,'(currData(id:id+scale-1))'))];
                            catch
                                kk=1
                            end
                        end


                        dataCopies{i-1,1}=tmpData;
                        

                    end
                    
                else  %% there is not any parameters range in course grain



                    %  plot(app.UIAxesCG_Original,currData,'color',distColorList(1,:));

                    scale=scaleList(1,1);
                    slide=slideBy(1,1);
                    

                    %%for all aggregation function except 'all' (first one)



                    currFun = app.pMenuScaleAggregate.Value;

                    for i=1:size(dataCopies,1)
                
                        tmpData =[];
                        currData = dataCopies{i,1};
                        startIds=1:slide:(size(currData,1)-scale+1);
                        for id=startIds
                            tmpData = [tmpData eval(strcat(currFun,'(currData(id:id+scale-1))'))];
                        end
                        dataCopies{i,1}=tmpData;
                    end

                end

        end


       
        function [startLine,endLine,nDiv]=getCutFileParameters(app,currData)

            divSelIndex = find(strcmp(app.pMenuDivisionType.Items,app.pMenuDivisionType.Value));

            overlapping = str2num(app.editCutFile_Overlap.Value);


                cutInit=str2num(app.editCutFile_Init.Value);
                cutEnd=str2num(app.editCutFile_End.Value);
                if app.TimeSeriesButton.Value==1
                    cutInit = cutInit*str2num(app.editSampleR.Value);
                    cutEnd = cutEnd*str2num(app.editSampleR.Value);
                    overlapping = overlapping * str2num(app.editSampleR.Value);
                end

                totalSize=size(currData,1)-cutInit-cutEnd;


                if   divSelIndex==1

                    nDiv = str2num(app.editDivision.Value);

                    windowSize=floor((totalSize+nDiv*overlapping-overlapping)/nDiv);

                    if 2*overlapping > windowSize
                        msgbox('Number of division is too large for the overlapping');
                        return
                    end

                elseif divSelIndex ==2
                    windowSize = str2num(app.editDivision.Value);
                    if app.TimeSeriesButton.Value==1
                        windowSize = windowSize*str2num(app.editSampleR.Value);

                    end
                    if 2*overlapping > windowSize
                        msgbox('Overlapping size cannot exit window size');
                        return
                    end

                    nDiv = floor((totalSize - overlapping)/(windowSize-overlapping));
                else
                    %sectorSize = strsplit(app.editDivision.Value,',')

                end

                startLine = [0:windowSize-overlapping:totalSize-windowSize]+cutInit
                endLine = [0+windowSize:windowSize-overlapping:totalSize]+cutInit




        end
               

        function applySegmentationOfFile(app,event,PreprocessedDataSet)
            
            

            
            
            try
                %cla(app.UIAxesCG_Original)

                app.PanelChk.AutoResizeChildren='off';
                ax1= subplot(2,1,1, 'Parent',app.PanelChk)

                
                columnList = UTIL_GUI.getDimensionList(app);
                fileList= UTIL_GUI.getFileIDList(app);
                
                if size(fileList,2) <=0 || size(columnList ,2) <=0 || size(fileList,2) > 1
                    
                    msgbox('Please select one of file and column...');
                    
                    return;
                end
                
                divSelIndex = find(strcmp(app.pMenuDivisionType.Items,app.pMenuDivisionType.Value));
                
                currData = PreprocessedDataSet{fileList(1)};


                
                overlapping = str2num(app.editCutFile_Overlap.Value);
                
                
                cutInit=str2num(app.editCutFile_Init.Value);
                cutEnd=str2num(app.editCutFile_End.Value);
                if app.TimeSeriesButton.Value==1
                    cutInit = cutInit*str2num(app.editSampleR.Value);
                    cutEnd = cutEnd*str2num(app.editSampleR.Value);
                    overlapping = overlapping * str2num(app.editSampleR.Value);
                end
                
                totalSize=size(currData,1)-cutInit-cutEnd;
                
                
                if   divSelIndex==1
                    
                    nDiv = str2num(app.editDivision.Value);
                    
                    windowSize=floor((totalSize+nDiv*overlapping-overlapping)/nDiv);
                    
                    if 2*overlapping > windowSize
                        msgbox('Number of division is too large for the overlapping');
                        return
                    end
                    
                elseif divSelIndex ==2
                    windowSize = str2num(app.editDivision.Value);
                    if app.TimeSeriesButton.Value==1
                        windowSize = windowSize*str2num(app.editSampleR.Value);
                        
                    end
                    if 2*overlapping > windowSize
                        msgbox('Overlapping size cannot exit window size');
                        return
                    end
                    
                    nDiv = floor((totalSize - overlapping)/(windowSize-overlapping));
                else
                    %sectorSize = strsplit(app.editDivision.Value,',')
                    
                end
                
                startLine = [0:windowSize-overlapping:totalSize-windowSize]+cutInit
                endLine = [0+windowSize:windowSize-overlapping:totalSize]+cutInit
                
                %plot(app.UIAxesCG_Original,currData,'color','black');
                plot(ax1,currData,'color','black');

               % hold(app.UIAxesCG_Original,'on')
               hold(ax1,'on')
                
                %             %%start line
                %             xPoints=[   startLine;startLine]';
                %             yPoints=repmat([min(currData) max(currData)],size(startLine,2),1);
                %             plot(app.UIAxesCG_Original,xPoints',yPoints','color','green')
                
                %             %%end line
                %             xPoints1=[   endLine;endLine]';
                %             yPoints1=repmat([min(currData) max(currData)],size(endLine,2),1);
                %             plot(app.UIAxesCG_Original,xPoints',yPoints','color','red')
                
                height = (max(currData)-min(currData));
                
                %rectangle(app.UIAxesCG_Original,'Position',[1,median(currData)-height/4,startLine(1)-1,height/2],'Curvature', 0.2,'FaceColor', [1, 0,0, 0.7],'EdgeColor', [0.2, 0.1, 0, 0.6]);
                %rectangle(app.UIAxesCG_Original,'Position',[endLine(end),median(currData)-height/4,size(currData,1)-endLine(end),height/2],'Curvature', 0.2,'FaceColor', [1, 0,0, 0.7],'EdgeColor', [0.2, 0.1, 0, 0.6]);

                rectangle(ax1,'Position',[1,median(currData)-height/4,startLine(1)-1,height/2],'Curvature', 0.2,'FaceColor', [1, 0,0, 0.7],'EdgeColor', [0.2, 0.1, 0, 0.6]);
                rectangle(ax1,'Position',[endLine(end),median(currData)-height/4,size(currData,1)-endLine(end),height/2],'Curvature', 0.2,'FaceColor', [1, 0,0, 0.7],'EdgeColor', [0.2, 0.1, 0, 0.6]);
                


                
                gray = [0.7 0.7 0.7];
                %rectangle(app.UIAxesCG_Original,'Position',[leftLocUp, lowerLimit,rightLocUp-leftLocUp,upperLimit-lowerLimit],'Curvature', 0.2,'FaceColor', [1, 0, 0, 0.7],'EdgeColor', [1, 0, 0, 0.7]);
                for v =1:nDiv
                    %rectangle(app.UIAxesCG_Original,'Position',[startLine(v),median(currData)-height/4,endLine(v)-startLine(v),height/2],'Curvature', 0.2,'FaceColor', [0, 1,0, 0.2],'EdgeColor', [0.2, 0.1, 0, 0.6]);
                    rectangle(ax1,'Position',[startLine(v),median(currData)-height/4,endLine(v)-startLine(v),height/2],'Curvature', 0.2,'FaceColor', [0, 1,0, 0.2],'EdgeColor', [0.2, 0.1, 0, 0.6]);
                    %line(app.UIAxesCG_Original,[startLine(v),endLine(v)],[median(currData)+height/4,median(currData)-height/4],'color',gray,'LineStyle','--')
                    line(ax1,[startLine(v),endLine(v)],[median(currData)+height/4,median(currData)-height/4],'color',gray,'LineStyle','--')
                end
                
            catch
                msgbox({'Problem in selection of paremeters...','Please try different combinations'})
            end
                   
        end

    end

    methods
        function obj = UTIL_EXTRA(inputArg1,inputArg2)
            %UTIL_EXTRA Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        end
end

