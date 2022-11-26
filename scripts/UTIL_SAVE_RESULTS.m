classdef UTIL_SAVE_RESULTS
    %UTIL_SAVE_RESULTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
                
        function [isOK]=saveTimeSeriesResults(app, dbFilesCols, sheetName, resultCol,chkExist)
            
            global f
            global epochList
            %%flag to check if the file already exist error
            isOK=true;
            
            
            %% check if the file already exist or not
            FilePath = app.editResultDir.Value;
            
            %fid=fopen(strcat(FilePath,'/',ResultType,app.editExperimentName.Value),'.xlsx'),'a');
            
            if  chkExist && isfile(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx'))
                msgbox('File Alredy Exist. Please either delete old file or provide different file name.');
                isOK=false;
                return
            end
            f= waitbar(0,'0','Name','Writing Time series data in Excel .....');
            for fIndex = 1:size(resultCol,1)
                progressTxt = strcat(num2str(fIndex),'/',num2str(size(dbFilesCols,1)));
                
                f = waitbar(fIndex/size(dbFilesCols,1),f,progressTxt,'Name','Writing data in Excel .....');
                
                
                
                currSheetName=strcat(sheetName,'_',dbFilesCols(fIndex).name);
                currData = resultCol{fIndex,1};
                [epochN,V]=size(currData);
                dataToWrite={};
                heading={};
                %% for each epoch
                
                currIndex=1;
                tmpEPOACH_N=size(epochList{fIndex,1},2);
                for epochId=1:tmpEPOACH_N
                    %% for each feature
                    
                    heading{1,currIndex}=strcat('Epoch_',num2str(epochList{fIndex,1}(1,epochId)));
                    for v=1:V
                        heading{2,currIndex}=strcat('V_',num2str(v));
                        try
                            data=currData{epochId,v};
                            for i=1:size(data,1)
                                dataToWrite{i,currIndex}=currData{epochId,v}(i,1);
                            end
                        catch
                            x=1;
                        end
                        currIndex=currIndex+1;
                        
                    end
                end
                
                FilePath = app.editResultDir.Value;
                try
                    xlswrite(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx'),[heading;dataToWrite],currSheetName);
                catch
                    x=1;
                end
                
                
                
                %xlswrite(fileName,[heading;dataToWrite],sheetName)
            end
            close(f);
        end
        
         function [isOK]=saveInSingleSheetExcel(app,  dbFilesCols, sheetName,chkIsExist)
            
            global epochList
            global FileNameList
            global f
            global ALL_StatisticCol
            global ALL_ScaleHeadingCol
            
            
            if strcmp(sheetName,'ComputationTime')
                 allStatistics= ALL_StatisticCol(:,CONS_INDEX.computationTime);
            else
                allStatistics= ALL_StatisticCol(:,CONS_INDEX.functionalValues);
            end
            
           
            singleResultSelData = UTIL_GUI.getStatisticSelData(app);
            
            %% flag to know if save successed..
            isOK = true;
            mc = ?STATISTIC_INDEX;
            %chkSelMeasures = app.uitableSMeasures.Data;
            
            %selData = cell2mat(chkSelMeasures(:,2));
            %             selData = getStatisticSelData(app);
            %             singleResultSelData=selData(1:200,1);
            %singleResultSelData = getStatisticSelData(app);
            
            selMeasureIDs = find(singleResultSelData==1);
            
            
            %% check if the file already exist or not
            FilePath = app.editResultDir.Value;
            
            %fid=fopen(strcat(FilePath,'/',ResultType,app.editExperimentName.Value),'.xlsx'),'a');
            
            if isfile(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx')) && chkIsExist
                msgbox('File Alredy Exist. Please delete old file or provide different file name.');
                isOK=false;
                return
            end
            
            
            
            %             if selData(STATISTIC_INDEX.Nonlinearity_VM,1)==1
            %                 removeInd = find(selMeasureIDs==STATISTIC_INDEX.Nonlinearity_VM);
            %                 selMeasureIDs(removeInd)=[];
            %                 selMeasureIDs=[selMeasureIDs;STATISTIC_INDEX.Nonlinearity_VM*10+1;STATISTIC_INDEX.Nonlinearity_VM*10+2;STATISTIC_INDEX.Nonlinearity_VM*10+3];
            %             end
            
            measureHeading={};
            scaleHeading = {};
            heading{1,1}='File';
            
            f= waitbar(0,'0','Name','Writing data in Excel .....');
            EPOACH_N=1;
            FILE_MAX_EPOACH = 1;
            for fIndex=1:size(epochList,1)
                if EPOACH_N < max(size(epochList{fIndex,1},2))
                    EPOACH_N=max(size(epochList{fIndex,1},2));
                    FILE_MAX_EPOACH = fIndex;
                end
                
            end
            
            
            for fIndex = 1:size(allStatistics,1)
                
                progressTxt = strcat(num2str(fIndex),'/',num2str(size(dbFilesCols,1)));
                
                f = waitbar(fIndex/size(dbFilesCols,1),f,progressTxt,'Name','Writing data in Excel .....');
                
                
                
                
                %try
                currStatisticCol = allStatistics{fIndex,1};
                %EPOACH_N = size(currStatisticCol,1);
                %EPOACH_N= size(epochList{fIndex,1},2);
                %% in case different file have different number of epcoh, get the maximum one
                tmpEPOACH_N=size(epochList{fIndex,1},2);
                
                dataToWrite{fIndex,1}=FileNameList{fIndex};
                %% start writing from second column
                colID = 2;
                for measureID=selMeasureIDs'
                    try
                        [SCALE_N,FEATURE_N]=size(currStatisticCol{1,measureID});
                    catch
                        x=1
                    end
                    if fIndex ==FILE_MAX_EPOACH
                        %% to avid
                        %if measureID < 200
                        measureHeading{1,colID}= mc.PropertyList(measureID).Name;
                        %                         else
                        %                             selMeasureId = floor( measureID/10);
                        %                             measureNO = mod(measureID,10);
                        %                             measureHeading{1,colID}=strcat(mc.PropertyList(selMeasureId).Name,'_',num2str(measureNO));
                        %                         end
                    end
                    for scaleID=1:SCALE_N
                        %if (measureID==STATISTIC_INDEX.ExtendedPoincare || measureID==STATISTIC_INDEX.Multiscales_LZC || measureID==STATISTIC_INDEX.RQA_Statistic)||   & ~isempty(ALL_ScaleHeadingCol{measureID})
                        %% make sure ALL_ScaleHeadingCol is not empty so check size before particular measure..
                        if  size(ALL_ScaleHeadingCol,1)>=measureID & ~isempty(ALL_ScaleHeadingCol{measureID})
                            scaleHeaderInfo = strsplit(ALL_ScaleHeadingCol{measureID,1},';');
                            
                            try
                                scaleHeading{1,colID}=scaleHeaderInfo{scaleID};
                            catch
                                x=1;
                            end
                        else
                            %% for computation time and other single Measurements
                            scaleHeading{1,colID}=strcat('Scale-',num2str(scaleID));
                        end
                        
                        for featureID=1:FEATURE_N
                            
                            for epoachID=1:tmpEPOACH_N
                                currEID = epochList{fIndex,1}(1,epoachID);
                                % disp([epoachID measureID scaleID featureID])
                                try
                                    dataToWrite{fIndex,colID}=currStatisticCol{epoachID,measureID}(scaleID,featureID);
                                catch
                                    x=1;
                                end
                                
                                
                                  if strcmp(sheetName,'ComputationTime')
                                        heading{1,colID}='';
                                  else
                                         if fIndex==FILE_MAX_EPOACH
                                            if app.chkSelEpoch.Value ==1
                                                heading{1,colID}=strcat('v_',num2str(featureID),'_ep-',num2str(epochList{fIndex,1}(1,epoachID)));
                                            else
                                                heading{1,colID}=strcat('v_',num2str(featureID),'_ep-',num2str(epoachID));

                                            end
                                    
                                         end
                                
                                  end
            
                                  
                                  
                               
                                colID = colID+1;
                                
                            end
                            %% if the epoch smaller than max Epoch jump the colID
                            if tmpEPOACH_N<EPOACH_N
                                oldColID=colID;
                                colID=colID+EPOACH_N-tmpEPOACH_N;
                                %% put x mark for the data where there is not record to fetch
                                %% this is sepearte missing values or inf values from epoch not available case
                                for tmpColID=oldColID:colID-1
                                    dataToWrite{fIndex,tmpColID}='x';
                                end
                            end
                            %disp([measureID scaleID featureID])
                        end
                    end
                    
                end
                %   catch
                %            app.editProgressInfoExcel.Value = strcat('file ',num2str(fIndex),' / ',num2str(size(ALL_StatisticCol,1)),' Completed....'));
                
                %     end
            end
            if size(measureHeading,2)<size(dataToWrite,2)
                measureHeading{1,size(dataToWrite,2)}='';
            end
            if size(scaleHeading,2) < size(dataToWrite,2)
                scaleHeading{1,size(dataToWrite,2)}='';
            end
            
            %% there may be cases number of headers differ in different files..
            maxEpochs = max([size(dataToWrite,2),size(measureHeading,2),size(heading,2),size(scaleHeading,2)]);
            if size(measureHeading,2)<maxEpochs
                measureHeading{1,maxEpochs}='';
            end
            if size(scaleHeading,2)<maxEpochs
                scaleHeading{1,maxEpochs}='';
            end
            if size(heading,2)<maxEpochs
                heading{1,maxEpochs}='';
            end
            if size(heading,2)<maxEpochs
                heading{1,maxEpochs}='';
            end
            
            
            if size(dataToWrite,2)<maxEpochs
                dataToWrite{1,maxEpochs}='';
            end
            
            try
                dataToWrite =[measureHeading;scaleHeading;heading;dataToWrite];
            catch
                x=1;
            end
            FilePath = app.editResultDir.Value;
            try
                xlswrite(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx'),dataToWrite,sheetName);
            catch
                cd('../com/ExternalPackages/xlwrite')
                javaaddpath('poi_library/xmlbeans-2.3.0.jar');
                javaaddpath('poi_library/stax-api-1.0.1.jar');
                javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
                javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
                javaaddpath('poi_library/poi-3.8-20120326.jar');
                javaaddpath('poi_library/dom4j-1.6.1.jar');
                xlwrite(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx'),dataToWrite,sheetName);
                cd('../../../scripts');
            end
            
            close(f)
         end
        
         function [isOK]=saveInExcelPerFile(app,  dbFilesCols, sheetName,chkIsExist)
            
            
            global FileNameList
            global f
            global ALL_StatisticCol
            global ALL_ScaleHeadingCol
            global epochList
            
            
            allStatistics= ALL_StatisticCol(:,CONS_INDEX.functionalValues);
           
            
            
             
            %% flag to know if save successed..
            isOK = true;
            mc = ?STATISTIC_INDEX;
            %chkSelMeasures = app.uitableSMeasures.Data;
            
            %selData = cell2mat(chkSelMeasures(:,2));
            %             selData = getStatisticSelData(app);
            %             singleResultSelData=selData(1:200,1);
            selMethods = UTIL_GUI.getStatisticSelData(app);
            selMeasureIDs = find(selMethods==1);
            measureN=size(selMeasureIDs,1);
            
           
            
            %% check if the file already exist or not
            FilePath = app.editResultDir.Value;
            % Writing per file
            
            if isfile(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx')) && chkIsExist
                msgbox('File Alredy Exist. Please delete old file or provide different file name.');
                isOK=false;
                return
            end
            
            %measureN = size(measureID,2)
            allData = allStatistics(:,CONS_INDEX.functionalValues);
            fileN=size(allData,1);
            
            f= waitbar(0,'0','Name','Writing data in Excel .....');
            for fIndex=1:fileN
                progressTxt = strcat(num2str(fIndex),'/',num2str(size(dbFilesCols,1)));
                
                f = waitbar(fIndex/size(dbFilesCols,1),f,progressTxt,'Name','Writing data in Excel .....');
                
                epochN = size(allData{fIndex,1},1);
                dataToWrite={};
                for eID=1:epochN
                    currFData=allData{fIndex,1}(eID,selMeasureIDs);
                    V = size(currFData{1,1},2);
                    
                    currRow=2;
                    dataToWrite{1,(eID-1)*V+3}=strcat('Epoch-',num2str(epochList{fIndex,1}(1,eID)));
                    for m=1:measureN
                        currMData = currFData{1,m};
                        %%scale
                        sN = size(currMData,1);
                        for s=1:sN
                            
                            if eID==1
                                dataToWrite{currRow,1}=mc.PropertyList(selMeasureIDs(m)).Name;
                                try
                                    if ~isempty(ALL_ScaleHeadingCol) && ~isempty(ALL_ScaleHeadingCol{selMeasureIDs(m)})
                                        
                                        scaleInfo=strsplit(ALL_ScaleHeadingCol{selMeasureIDs(m)},';');
                                        dataToWrite{currRow,2}=scaleInfo{s};
                                        
                                        
                                    else
                                        dataToWrite{currRow,2}=num2str(s);
                                    end
                                catch
                                    dataToWrite{currRow,2}=num2str(s);
                                end
                                
                            end
                            for v=1:V
                               try
                                    dataToWrite{currRow,(eID-1)*V+v+2} = currMData(s,v);
                               catch
                                   x=1
                               end
                            end
                            currRow = currRow+1;
                        end
                    end
                end
                FilePath = app.editResultDir.Value;
                xlswrite(strcat(FilePath,'/',app.editExperimentName.Value,'.xlsx'),dataToWrite,strcat('R_',FileNameList{fIndex}));
                
                
            end
            close(f);
         end
         
         
         function saveParamInXMLFile(app,  resultPath)
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xmlData{1,1}='INIT';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='SampleRate';
            tmpXMLData{1,2}=app.editSampleR.Value;
            tmpXMLData{2,1}='EpochTimeInSecond';
            tmpXMLData{2,2}=app.editSampleR.Value;
            tmpXMLData{3,1}='StartTimeInSecond';
            tmpXMLData{3,2}=app.editStartT.Value;
            tmpXMLData{4,1}='MaxLengthInSecond';
            tmpXMLData{4,2}=app.editMaxLength.Value;     
            %%
            xmlData{1,2}=tmpXMLData;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            xmlData{2,1}='OUTLIERS';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='MedianW';
            tmpXMLData{1,2}=app.editOutlierMW.Value;
            %%
            xmlData{2,2}=tmpXMLData;
            
            
            %%KSTest
            xmlData{3,1}='KSTest';
            tmpXMLData={};
            tmpXMLData{1,1}='alpha';
            tmpXMLData{1,2}=app.editKSLevelOfSig.Value;
            xmlData{3,2}=tmpXMLData;
            
            
            %%SWTest
            xmlData{4,1}='SWTEST';
            tmpXMLData={};
            tmpXMLData{1,1}='alpha';
            tmpXMLData{1,2}=app.editSW_P.Value;
            xmlData{4,2}=tmpXMLData;
            
            %%autocovaance            
            xmlData{5,1}='AUTO_COVARANCE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='lagK';
            tmpXMLData{1,2}=app.editAutoCovLagK.Value;
            %%
            xmlData{5,2}=tmpXMLData;
            
            %%auto correlation           
            xmlData{6,1}='AUTO_CORRELATION';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='numLag';
            tmpXMLData{1,2}=app.editAutoCorrNumLags.Value;
%             tmpXMLData{2,1}='numSTD';
%             tmpXMLData{2,2}=app.editAutoCorrNumSTD.Value;
            %%
            xmlData{6,2}=tmpXMLData;
            
            %%moving window                
            xmlData{7,1}='M_WINDOW';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editMWindowM.Value;
            tmpXMLData{2,1}='t1';
            tmpXMLData{2,2}=app.editMWindowT1.Value;
            tmpXMLData{3,1}='t2';
            tmpXMLData{3,2}=app.editMWindowT2.Value;
            %%
            xmlData{7,2}=tmpXMLData;
            
            
            %% HIGUNCHI_FD
                        
            xmlData{8,1}='HIGUNCHI_FD';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='KMax';
            tmpXMLData{1,2}=app.editHiguchiFD_KMax.Value;
            %%
            xmlData{8,2}=tmpXMLData;
            
            
            %%Correlation Dimension
            
            xmlData{9,1}='CORRDIM';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editCorrDimM.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editCorrDimLag.Value;
            %%
            xmlData{9,2}=tmpXMLData;
            
            %%DFA
            xmlData{10,1}='DFA';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editDFAEmbededDim.Value;
            tmpXMLData{2,1}='k';
            tmpXMLData{2,2}=app.editDFAOrder.Value;
            %%
            xmlData{10,2}=tmpXMLData;
            
            %%RQA
            
            xmlData{11,1}='RQA';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editRQA_M.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editRQA_Tau.Value;
            tmpXMLData{3,1}='r';
            tmpXMLData{3,2}=app.editRQA_R.Value;
             tmpXMLData{4,1}='minLine';
            tmpXMLData{4,2}=app.editRQA_Minline.Value;
            
            %%
            xmlData{11,2}=tmpXMLData;
            %%%%%%%%%%%%%%%%%%%%%
            
            
            %%EPP
            
            xmlData{12,1}='EPP';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='K';
            tmpXMLData{1,2}=app.editEPPLag.Value;
            %%
            xmlData{12,2}=tmpXMLData;
            
            %%Multiscale LZC
            
            xmlData{13,1}='M_LZC';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='scale';
            tmpXMLData{1,2}=app.editMLZCScal.Value;
            %%
            xmlData{13,2}=tmpXMLData;
            
            
            %%LLE
            
            xmlData{14,1}='LLE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editLLE_M.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editLLE_Tau.Value;
            tmpXMLData{3,1}='meanperiod';
            tmpXMLData{3,2}=app.editLLE_MeanPeriod.Value;
             tmpXMLData{4,1}='maxiter';
            tmpXMLData{4,2}=app.editLLE_Maxiter.Value;
            
            %%
            xmlData{14,2}=tmpXMLData;
            
            
            %% SHANNON Entropy
            
            xmlData{15,1}='SHANNON_EN';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editShEn_M.Value;
            tmpXMLData{2,1}='numInt';
            tmpXMLData{2,2}=app.editShEn_numInt.Value;
            %%
            xmlData{15,2}=tmpXMLData;
            
            %% Entropy of Difference (EoD)
            
            
             xmlData{16,1}='EOD';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editEoD_M.Value;
            tmpXMLData{2,1}='shift';
            tmpXMLData{2,2}=app.editEoD_Shift.Value;
            %%
            xmlData{16,2}=tmpXMLData;
            
            %%KL Divergance
            
            xmlData{17,1}='KLD';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editKLD_M.Value;
            tmpXMLData{2,1}='shift';
            tmpXMLData{2,2}=app.editKLD_Shift.Value;
            %%
            xmlData{17,2}=tmpXMLData;
            
            %% Entropy Mochan
            
            xmlData{18,1}='EN_MOCHAN';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editMoChan_M.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editMoChan_T.Value;
            %%
            xmlData{18,2}=tmpXMLData;
            
            %% TSALLIS_ENTROPY
            
            xmlData{19,1}='TSALLIS_ENTROPY';
            tmpXMLData={};
            tmpXMLData{1,1}='q';
            tmpXMLData{1,2}=app.editTEntropyQ.Value;
            xmlData{19,2}=tmpXMLData;
            
            %% AE
            
             xmlData{20,1}='AE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='binsize';
            tmpXMLData{1,2}=app.editAE_BinSize.Value;
            tmpXMLData{2,1}='scale';
            tmpXMLData{2,2}=app.editAE_Scale.Value;
            tmpXMLData{3,1}='min';
            tmpXMLData{3,2}=app.editAE_Min.Value;
             tmpXMLData{4,1}='max';
            tmpXMLData{4,2}=app.editAE_Max.Value;
            
            %%
            xmlData{20,2}=tmpXMLData;
            
            %% Entropy of Entropy
            
             xmlData{21,1}='EOE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='binsize';
            tmpXMLData{1,2}=app.editEE_BinSize.Value;
            tmpXMLData{2,1}='scale';
            tmpXMLData{2,2}=app.editEE_Scale.Value;
            tmpXMLData{3,1}='min';
            tmpXMLData{3,2}=app.editEE_Min.Value;
             tmpXMLData{4,1}='max';
            tmpXMLData{4,2}=app.editEE_Max.Value;
            
            %%
            xmlData{21,2}=tmpXMLData;
            
            
            %% Renyi Entropy
            
             xmlData{22,1}='RENYI_ENTROPY';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='q';
            tmpXMLData{1,2}=app.editREntropyQ.Value;
            %%
            xmlData{22,2}=tmpXMLData;
            
            %% Permutation Entropy
            
            xmlData{23,1}='M_PE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editPEM.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editPET.Value;
             tmpXMLData{3,1}='scale';
            tmpXMLData{3,2}=app.editPEScale.Value;
            %%
            xmlData{23,2}=tmpXMLData;
            
            %% AAPE
            
             xmlData{24,1}='AAPE';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editAAPEM.Value;
            tmpXMLData{2,1}='tau';
            tmpXMLData{2,2}=app.editAAPET.Value;
            tmpXMLData{3,1}='a';
            tmpXMLData{3,2}=app.editAAPEA.Value;
            %%
            xmlData{24,2}=tmpXMLData;
            
            %% IMPE
            
            xmlData{25,1}='IMPE';
            tmpXMLData={};            
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editImPEM.Value;
            tmpXMLData{2,1}='t';
            tmpXMLData{2,2}=app.editImPET.Value;
            %tmpXMLData{3,1}='scale';
            %tmpXMLData{3,2}=app.editImPEScale.Value;
            xmlData{25,2}=tmpXMLData;
            
            
            
            %% MPM_E
            
            xmlData{26,1}='M_PME';
            tmpXMLData={};            
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editMPeM.Value;
            tmpXMLData{2,1}='t';
            tmpXMLData{2,2}=app.editMPeT.Value;
            % tmpXMLData{3,1}='scale';
            % tmpXMLData{3,2}=app.editMPeScale.Value;
            xmlData{26,2}=tmpXMLData;
            
            %% Approximate Entropy
            
            xmlData{27,1}='APPROX_EN';
            tmpXMLData={};            
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editApEnM.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editApEnR.Value;           
            xmlData{27,2}=tmpXMLData;
            
            
            %% Conditional Entropy
            
            xmlData{28,1}='CONDITIONAL_EN';
            tmpXMLData={};            
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editCE_M.Value;
            tmpXMLData{2,1}='numInt';
            tmpXMLData{2,2}=app.editCE_NumInt.Value;           
            xmlData{28,2}=tmpXMLData;
            
            %% Corrected Conditional Entropy
            
            xmlData{29,1}='CorrectedCE';
            tmpXMLData={};            
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editCorrectedCE_M.Value;
            tmpXMLData{2,1}='numInt';
            tmpXMLData{2,2}=app.editCorrectedCE_NumInt.Value;           
            xmlData{29,2}=tmpXMLData;
            
            
            %% Sample Entropy           
            
            xmlData{30,1}='SAMPLE_ENTROPY';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editSE_M.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editSE_R.Value;            
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editSE_TAU.Value;            
            
            xmlData{30,2}=tmpXMLData;
            
            
            %% Sample Entropy Richmond          
            
            xmlData{31,1}='SAMPLE_ENTROPY_R';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editSE_RH_M.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editSE_RH_R.Value;            
            
            xmlData{31,2}=tmpXMLData;
            
            %% Complexity Index
            
            xmlData{32,1}='COMPLEX_IND';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editCI_M.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editCI_R.Value;            
            tmpXMLData{3,1}='tmax';
            tmpXMLData{3,2}=app.editCI_Tau.Value;            
            
            xmlData{32,2}=tmpXMLData;
            
            %% Cos Entropy
            
            xmlData{33,1}='COS_EN';
            tmpXMLData={}; 
            tmpXMLData{1,1}='cosR';
            tmpXMLData{1,2}=app.editCosEn_cosR.Value;
            tmpXMLData{2,1}='m';
            tmpXMLData{2,2}=app.editCosEn_M.Value;            
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editCosEn_TAU.Value;            
            
            xmlData{33,2}=tmpXMLData;
            
            
            %% Fixed Sample Entropy
            
            
            xmlData{34,1}='Fixed_SAMP_EN';
            tmpXMLData={}; 
            tmpXMLData{1,1}='nWindow';
            tmpXMLData{1,2}=app.editFSampEn_nWindow.Value;
            tmpXMLData{2,1}='fnstep';
            tmpXMLData{2,2}=app.editFSampEn_fNumStep.Value;
            tmpXMLData{3,1}='m';
            tmpXMLData{3,2}=app.editFSampEn_M.Value;            
            tmpXMLData{4,1}='r';
            tmpXMLData{4,2}=app.editFSampEn_R.Value;            
            
            xmlData{34,2}=tmpXMLData;
            
            
            %% MSE
            
            xmlData{35,1}='MSE';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editMSE_M.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editMSE_R.Value;            
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editMSE_Tau.Value;            
            
            xmlData{35,2}=tmpXMLData;
            
            
            %% Fuzzy Entropy
            
            xmlData{36,1}='FUZZY_ENTROPY';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editFE_M.Value;
            tmpXMLData{2,1}='mf';
            tmpXMLData{2,2}=app.pMenuFE_MF.Value;            
            tmpXMLData{3,1}='rn';
            tmpXMLData{3,2}=app.editFE_T.Value;
            tmpXMLData{4,1}='local';
            tmpXMLData{4,2}=app.pMenuFE_L.Value;            
            tmpXMLData{5,1}='tau';
            tmpXMLData{5,2}=app.editFE_Tau.Value;  
            
            xmlData{36,2}=tmpXMLData;
            
            
            %% Distribution Entropy
            
            xmlData{37,1}='DISTRIBUTION_ENTROPY';
            tmpXMLData={}; 
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editDE_M.Value;
            tmpXMLData{2,1}='binNum';
            tmpXMLData{2,2}=app.editDE_B.Value;            
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editDE_Tau.Value;            
            
            xmlData{37,2}=tmpXMLData;
            
            
            %% RCMSE_STD
            
            xmlData{38,1}='RCMSE_STD';
            
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{2,2}=app.editRCMSEstdM.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editRCMSEstdR.Value;            
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editRCMSEstdTau.Value;
            tmpXMLData{4,1}='scale';
            tmpXMLData{4,2}=app.editRCMSEstdScale.Value;
            xmlData{38,2}=tmpXMLData;
            
            
            %% RCMFE_STD
            
            xmlData{39,1}='RCMFE_STD';
            
            tmpXMLData={};           
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editRCMFEstdM.Value;
            tmpXMLData{2,1}='r';
            tmpXMLData{2,2}=app.editRCMFEstdR.Value;
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editRCMFEstdTau.Value;
            tmpXMLData{4,1}='n';
            tmpXMLData{4,2}=app.editRCMFEstdN.Value;
            tmpXMLData{5,1}='scale';
            tmpXMLData{5,2}=app.editRCMFEstdScale.Value;
            
            xmlData{39,2}=tmpXMLData;
            
            %% RCMDE
            
            xmlData{40,1}='RCMDE';
            tmpXMLData={};            
            tmpXMLData{2,1}='m';
            tmpXMLData{2,2}=app.editRCMDE_M.Value;
            tmpXMLData{3,1}='c';
            tmpXMLData{3,2}=app.editRCMDE_NoC.Value;
            tmpXMLData{1,1}='tau';
            tmpXMLData{1,2}=app.editRCMDE_Tau.Value;
            tmpXMLData{4,1}='scale';
            tmpXMLData{4,2}=app.editRCMDE_Scale.Value;
            xmlData{40,2}=tmpXMLData;
            
            %% Slope Entropy
            
            xmlData{41,1}='SLOPE_EN';
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{2,2}=app.editRCMSEstdM.Value;
            tmpXMLData{2,1}='gamma';
            tmpXMLData{2,2}=app.editSlopeEnGamma.Value;
            tmpXMLData{3,1}='delta';
            tmpXMLData{3,2}=app.editSlopeEnDelta.Value;
         
            xmlData{41,2}=tmpXMLData;
            
            %% Bubble Entropy
            
            xmlData{42,1}='BUBBLE_EN';
            tmpXMLData={};
            tmpXMLData{1,1}='m';
            tmpXMLData{1,2}=app.editBubbleEnM.Value;
            
            xmlData{42,2}=tmpXMLData;
            
            %% Phase Entropy
            
                  
             xmlData{43,1}='PHASE_EN';
             tmpXMLData={};
             tmpXMLData{1,1}='k';
             tmpXMLData{1,2}=app.editPhEnK.Value;
            
             xmlData{43,2}=tmpXMLData;
            
            %%%% multiscale PH
            
            xmlData{44,1}='M_PHASE_EN';
             tmpXMLData={};
             tmpXMLData{1,1}='k';
             tmpXMLData{1,2}=app.editMPhEnK.Value;
             
             tmpXMLData{2,1}='scale';
             tmpXMLData{2,2}=app.editMPhEnScale.Value;
            
             xmlData{44,2}=tmpXMLData;
             
             
           %% FNN
            
            xmlData{45,1}='FNN';
            tmpXMLData={};
            tmpXMLData{1,1}='minDim';
            tmpXMLData{1,2}=app.editFracFNN_MinDim.Value;
            tmpXMLData{2,1}='maxDim';
            tmpXMLData{2,2}=app.editFracFNN_MaxDim.Value;
            tmpXMLData{3,1}='tau';
            tmpXMLData{3,2}=app.editFracFNN_Tau.Value;
            tmpXMLData{4,1}='rt';
            tmpXMLData{4,2}=app.editFracFNN_Rt.Value;
            xmlData{45,2}=tmpXMLData;
            
            
            %% AFN
            
            xmlData{46,1}='AFN';
            tmpXMLData={};
            tmpXMLData{1,1}='binsize';
            tmpXMLData{1,2}=app.editAFN_BinSize.Value;
            tmpXMLData{2,1}='tmax';
            tmpXMLData{2,2}=app.editAFN_TMax.Value;
            xmlData{46,2}=tmpXMLData;
            
            
            %% Auto Mutual Information (AMI)
            
            xmlData{47,1}='AMI';
            tmpXMLData={};
            tmpXMLData{1,1}='binsize';
            tmpXMLData{1,2}=app.editMI_Partitions.Value;
            tmpXMLData{2,1}='tmax';
            tmpXMLData{2,2}=app.editMI_TMax.Value;
            xmlData{47,2}=tmpXMLData;
            
            %% CCM
            
             xmlData{48,1}='CCM';
            tmpXMLData={};
            tmpXMLData{1,1}='k';
            tmpXMLData{1,2}=app.editCCM_Lag.Value;
            
            xmlData{48,2}=tmpXMLData;
            
            
            %%Alan Factor
            
             xmlData{49,1}='AlanFactor_AF';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='nWindow';
            tmpXMLData{1,2}=app.editAlanFactor_nWindow.Value;
            %%
            xmlData{49,2}=tmpXMLData;
            
            
            
             xmlData{50,1}='Tone_Entopy';
            %%
            tmpXMLData={};
            tmpXMLData{1,1}='tau';
            tmpXMLData{1,2}=app.editToneE_M.Value;
            %%
            xmlData{50,2}=tmpXMLData;
            
            
            
            %
            % xmlData{10,1}='M_PME_2';
            % tmpXMLData={};
            % tmpXMLData{1,1}='t';
            % tmpXMLData{1,2}=app.editMPe2T.Value;
            % tmpXMLData{2,1}='m';
            % tmpXMLData{2,2}=app.editMPe2M.Value;
            % % tmpXMLData{3,1}='scale';
            % % tmpXMLData{3,2}=app.editMPeScale.Value;
            % xmlData{10,2}=tmpXMLData;
            %
            % xmlData{11,1}='RCMDE_2';
            % tmpXMLData={};
            % tmpXMLData{1,1}='tau';
            % tmpXMLData{1,2}=app.editRCMDE_2Tau.Value;
            % tmpXMLData{2,1}='m';
            % tmpXMLData{2,2}=app.editRCMDE_2M.Value;
            % tmpXMLData{3,1}='c';
            % tmpXMLData{3,2}=app.editRCMDE_2NoC.Value;
            % tmpXMLData{4,1}='scale';
            % tmpXMLData{4,2}=app.editRCMDE_2Scale.Value;
            % xmlData{11,2}=tmpXMLData;
            %
            %
            %
            %
            %
            % xmlData{12,1}='SAMPLE_ENTROPY_2';
            % tmpXMLData={};
            % tmpXMLData{1,1}='tau';
            % tmpXMLData{1,2}=app.editSE_2TAU.Value;
            % tmpXMLData{2,1}='m';
            % tmpXMLData{2,2}=app.editSE_2M.Value;
            % tmpXMLData{3,1}='r';
            % tmpXMLData{3,2}=app.editSE_2R.Value;
            % xmlData{12,2}=tmpXMLData;
            
            
            
            
           
            
            
           
            
            isError = true;
            try
                cd('../com/utils')
                writeToXML(strcat(resultPath,'\Param_',app.editExperimentName.Value,'.xml'),xmlData);
                % strcat(resultPath,'\',FileName)
                isError = false;
                throwME(MException("Go To Finally","Finally"));
            catch e %e is an MException struct
                if isError
                    getReport(e);
                    
                end
                % more error handling...
                
                %% moving back
                cd('../../scripts')
            end
         end
        
         
         
         
         
         
         function saveParamInExcel(app)
             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            xmlData{1,1}='INIT';
            xmlData{1,2}=strcat('SampleRate=',app.editSampleR.Value,';EpochTimeInSecond=',app.editSampleR.Value,';StartTimeInSecond=',app.editStartT.Value,';MaxLengthInSecond=',app.editMaxLength.Value);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Outliers
            xmlData{2,1}='OUTLIERS';
            xmlData{2,2}=strcat('MedianW=',app.editOutlierMW.Value);
           
            
            
            %%KSTest
            xmlData{3,1}='KSTest';           
            xmlData{3,2}=strcat('alpha=',app.editKSLevelOfSig.Value);
            
            
            
            %%SWTest
            xmlData{4,1}='SWTEST';
            xmlData{4,2}=strcat('alpha=',app.editSW_P.Value);
            
            
            %%autocovaance            
            xmlData{5,1}='AUTO_COVARANCE';
            xmlData{5,2}=strcat('lagK=',app.editAutoCovLagK.Value);
            
            
            %%auto correlation           
            xmlData{6,1}='AUTO_CORRELATION';
            xmlData{6,2}=strcat('numLag=',app.editAutoCorrNumLags.Value);%';numSTD=',app.editAutoCorrNumSTD.Value);
            %%
           
            
            %%moving window                
            xmlData{7,1}='M_WINDOW';
            xmlData{7,2}=strcat('m=',app.editMWindowM.Value,';t1=',app.editMWindowT1.Value,';t2=',app.editMWindowT2.Value);
            
            
            
            %% HIGUNCHI_FD
                        
            xmlData{8,1}='HIGUNCHI_FD';
            xmlData{8,2}=strcat('KMax=',app.editHiguchiFD_KMax.Value);
          
            
            %%Correlation Dimension
            
            xmlData{9,1}='CORRDIM';
            xmlData{9,2}=strcat('m=',app.editCorrDimM.Value,';tau=',app.editCorrDimLag.Value);
           
            
            %%DFA
            xmlData{10,1}='DFA'; 
            xmlData{10,2}=strcat('m=',app.editDFAEmbededDim.Value,';k=',app.editDFAOrder.Value);
            
            %%RQA
            
            xmlData{11,1}='RQA';
            xmlData{11,2}=strcat('m=',app.editRQA_M.Value,';tau=',app.editRQA_Tau.Value,';r=',app.editRQA_R.Value,';minLine=',app.editRQA_Minline.Value);
            
            
            %%EPP
            
            xmlData{12,1}='EPP';
            xmlData{12,2}=strcat('K=',app.editEPPLag.Value);
            
            %%Multiscale LZC
            xmlData{13,1}='M_LZC';
            xmlData{13,2}=strcat('scale=',app.editMLZCScal.Value);
            %%
            
            %%LLE
            
            xmlData{14,1}='LLE';
            xmlData{14,2}=strcat('m=',app.editLLE_M.Value,';tau=',app.editLLE_Tau.Value,'meanPeriod=',app.editLLE_MeanPeriod.Value,';maxiter=',app.editLLE_Maxiter.Value);
            
            
            %% SHANNON Entropy
            
            xmlData{15,1}='SHANNON_EN';
            xmlData{15,2}=strcat('m=',app.editShEn_M.Value,';numInt=',app.editShEn_numInt.Value);
           
            %% Entropy of Difference (EoD)
            
            
             xmlData{16,1}='EOD';
             xmlData{16,2}=strcat('m=',app.editEoD_M.Value,';shift=',app.editEoD_Shift.Value);
             
            
            
            %%KL Divergance
            
            xmlData{17,1}='KLD';
            xmlData{17,2}=strcat('m=',app.editKLD_M.Value,';shift=',app.editKLD_Shift.Value);
            
           
            
            %% Entropy Mochan
            
            xmlData{18,1}='EN_MOCHAN';
            xmlData{18,2}=strcat('m=',app.editMoChan_M.Value,';tau=',app.editMoChan_T.Value);
          
            
            %% TSALLIS_ENTROPY
            
            xmlData{19,1}='TSALLIS_ENTROPY';
            xmlData{19,2}=strcat('q=',app.editTEntropyQ.Value);
            
            
            
            %% AE
            
             xmlData{20,1}='AE';
             xmlData{20,2}=strcat('binsize=',app.editAE_BinSize.Value,';scale=',app.editAE_Scale.Value,';min=',app.editAE_Min.Value,';max=',app.editAE_Max.Value);
             
             
          
            
            %% Entropy of Entropy
            
             xmlData{21,1}='EOE';
             xmlData{21,2}=strcat('binsize=',app.editEE_BinSize.Value,';scale=',app.editEE_Scale.Value,';min=',app.editEE_Min.Value,';max=',app.editEE_Max.Value);
             
           
            
            
            %% Renyi Entropy
            
             xmlData{22,1}='RENYI_ENTROPY';
             xmlData{22,2}=strcat('q=',app.editREntropyQ.Value);
             
           
            %% Permutation Entropy
            
            xmlData{23,1}='M_PE';
            xmlData{23,2}=strcat('m=',app.editPEM.Value,';tau=',app.editPET.Value,';scale=',app.editPEScale.Value);
            
            
            
            %% AAPE
            
             xmlData{24,1}='AAPE';
             xmlData{24,2}=strcat('m=',app.editAAPEM.Value,';tau=',app.editAAPET.Value,';a=',app.editAAPEA.Value);
             
          
            
            %% IMPE
            
            xmlData{25,1}='IMPE';
            xmlData{25,2}=strcat('m=',app.editImPEM.Value,';t=',app.editImPET.Value,';scale=',app.editImPEScale.Value);
            
            
            
            
            %% MPM_E
            
            xmlData{26,1}='M_PME';
            xmlData{26,2}=strcat('m=',app.editMPeM.Value,';t=',app.editMPeT.Value);
           
            
            %% Approximate Entropy
            
            xmlData{27,1}='APPROX_EN';
            xmlData{27,2}=strcat('m=',app.editApEnM.Value,';r=',app.editApEnR.Value);
         
            
            
            %% Conditional Entropy
            
            xmlData{28,1}='CONDITIONAL_EN';
            xmlData{28,2}=strcat('m=',app.editCE_M.Value,';numInt=',app.editCE_NumInt.Value);
             
            
            %% Corrected Conditional Entropy
            
            xmlData{29,1}='CorrectedCE';
            xmlData{29,2}=strcat('m=',app.editCorrectedCE_M.Value,';numInt=',app.editCorrectedCE_NumInt.Value);
            
           
            
            %% Sample Entropy           
            
            xmlData{30,1}='SAMPLE_ENTROPY';
            xmlData{30,2}=strcat('m=',app.editSE_M.Value,';r=',app.editSE_R.Value,';tau=',app.editSE_TAU.Value);
           
            
            
            %% Sample Entropy Richmond          
            
            xmlData{31,1}='SAMPLE_ENTROPY_R';
            xmlData{31,2}=strcat('m=',app.editSE_RH_M.Value,';r=',app.editSE_RH_R.Value);
             
           
            %% Complexity Index
            
            xmlData{32,1}='COMPLEX_IND';
            xmlData{32,2}=strcat('m=',app.editCI_M.Value,';r=',app.editCI_R.Value,';tmax=',app.editCI_Tau.Value);
            
            
            
            %% Cos Entropy
            
            xmlData{33,1}='COS_EN';           
            xmlData{33,2}=strcat('m=',app.editCosEn_M.Value,';cosR=',app.editCosEn_cosR.Value,';tau=',app.editCosEn_TAU.Value);
            
            
            
            
            %% Fixed Sample Entropy
            
            
            xmlData{34,1}='Fixed_SAMP_EN';
            xmlData{34,2}=strcat('nWindow=',app.editFSampEn_nWindow.Value,';m=',app.editFSampEn_M.Value,';r=',app.editFSampEn_R.Value,';fnstep=',app.editFSampEn_fNumStep.Value);
            
            
            
            
            %% MSE
            
            xmlData{35,1}='MSE';
            xmlData{35,2}=strcat('m=',app.editMSE_M.Value,';r=',app.editMSE_M.Value,';tau=',app.editMSE_Tau.Value);
          
            
            %% Fuzzy Entropy
            
            xmlData{36,1}='FUZZY_ENTROPY';
            xmlData{36,2}=strcat('m=',app.editFE_M.Value,';mf=',app.pMenuFE_MF.Value,';tau=',app.editFE_Tau.Value,';local=',app.pMenuFE_L.Value,';rn=',app.editFE_T.Value);
            
          
            
           
            
            
            %% Distribution Entropy
            
            xmlData{37,1}='DISTRIBUTION_ENTROPY';
            xmlData{37,2}=strcat('m=',app.editDE_M.Value,';binNum=',app.editDE_B.Value,';tau=',app.editDE_Tau.Value);
           
            
            %% RCMSE_STD
            
            xmlData{38,1}='RCMSE_STD';
            xmlData{38,2}=strcat('m=',app.editRCMSEstdM.Value,';r=',app.editRCMFEstdR.Value,';tau=',app.editRCMSEstdTau.Value,';scale=',app.editRCMSEstdScale.Value);
           
            
            
            %% RCMFE_STD
            
            xmlData{39,1}='RCMFE_STD'; 
            xmlData{39,2}=strcat('m=',app.editRCMFEstdM.Value,';r=',app.editRCMFEstdR.Value,';tau=',app.editRCMFEstdTau.Value,';n=',app.editRCMFEstdN.Value,';scale=',app.editRCMFEstdScale.Value);
            
            
            
            %% RCMDE
            
            xmlData{40,1}='RCMDE';
            xmlData{40,2}=strcat('m=',app.editRCMDE_M.Value,';c=',app.editRCMDE_NoC.Value,';tau=',app.editRCMDE_Tau.Value,';scale=',app.editRCMDE_Scale.Value);
            
            
            %% Slope Entropy
            
            xmlData{41,1}='SLOPE_EN';
            xmlData{41,2}=strcat('m=',app.editRCMSEstdM.Value,';gamma=',app.editSlopeEnGamma.Value,';delta=',app.editSlopeEnDelta.Value);
         
            %% Bubble Entropy
            
            xmlData{42,1}='BUBBLE_EN';
    
            xmlData{42,2}=strcat('m=',app.editBubbleEnM.Value);
            
            %% Phase Entropy
            
                  
             xmlData{43,1}='PHASE_EN';
             xmlData{43,2}=strcat('k=',app.editPhEnK.Value);
             
            
            
           %% FNN
            
            xmlData{44,1}='FNN';
            xmlData{44,2}=strcat('minDim=',app.editFracFNN_MinDim.Value,';maxDim=',app.editFracFNN_MaxDim.Value,';tau=',app.editFracFNN_Tau.Value,';rt=',app.editFracFNN_Rt.Value);
            
            %% AFN
            xmlData{45,1}='AFN';
            xmlData{45,2}=strcat('binsize=',app.editAFN_BinSize.Value,';tmax=',app.editAFN_TMax.Value);
                        
            
            %% Auto Mutual Information (AMI)
            xmlData{46,1}='AMI';            
            xmlData{46,2}= strcat('binsize=',app.editMI_Partitions.Value,';tmax=',app.editMI_TMax.Value);
                       
            %% CCM            
            xmlData{47,1}='CCM';
            xmlData{47,2}=strcat('k=',app.editCCM_Lag.Value);
            
            %% alan Factor
            xmlData{48,1}='AlanFactor_AF';
            xmlData{48,2}=strcat('nWindow=',app.editAlanFactor_nWindow.Value);
            
            
            
            %% Tone Entropy 
            xmlData{49,1}='TONE_ENTROPY';
            xmlData{49,2}=strcat('tau=',app.editToneE_M.Value);
          
            
          
        
             try
                xlswrite(strcat(app.editResultDir.Value,'/',app.editExperimentName.Value,'.xlsx'),xmlData,'Parameters');
             catch
                 
             end
        end
       
         
    end
end

