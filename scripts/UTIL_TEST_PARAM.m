classdef UTIL_TEST_PARAM
    %UTIL_TEST_PARAM Summary of this class goes here
    %   Detailed explanation goes here



    methods(Static)
        function [flagOK]= runTestParam(app)
            % isValidData = checkValidData(app)
            %
            % %%
            %
            % if  ~isValidData
            %     return
            % end

            global PreprocessedDataSet
            global epochList
            global FileNameList
            global f

            flagOK = false;

            testRunTime=[];

            %dbDirectoryPath=app.editDataDir.Value;
            %% all constrants are stored in com/constants folder
            addpath('../com/Constants');
            %%addpath('../com/algorithms')



            %% read sample rate, epoch time(in second) ,data frame start time and timing unit (second/
            SAMPLING_RATE = str2double(app.editSampleR.Value);
            EPOCH_TIME_IN_SECOND =  str2double(app.editEpochT.Value);
            %START_TIME_IND_SECOND =  str2double(app.editStartT.Value);
            %MAX_DATA_LENGTH_SECOND = str2double(app.editMaxLength.Value);
            %TOTAL_OBSEVATION_TIME_SECOND =  str2double(app.editTObservationT.Value);




            %%STATISTIC_INDEX contains all the statistic properties we are going to measure
            %% StatisticCol contains STATISTIC_INDEX.PropertyList
            %%create the meta.class object using the ? operator with the class name
            %mc = ?STATISTIC_INDEX_TEST;


            %             allExt = app.pMenuDbFileExtension.Value;
            %             selectedIndex = app.pMenuDbFileExtension.Value ;
            %             selExt = char(strtrim(allExt(selectedIndex,:)));
            %selExt = app.pMenuDbFileExtension.Value;
            %dbFilesCols  = dir(strcat(dbDirectoryPath,'../*.',selExt));


            %% get selected statistic
            %chkSelMeasures = app.uitableSMeasures.Data;
            %selData = cell2mat(chkSelMeasures(:,2));

            selData = UTIL_GUI.getStatisticSelData(app);








            %change1 30/05/2020
            %sample rate is input from user
            %% all batch process have same sample rate.
            %SAMPLING_RATE = getSamplingRate(dbFilesCols(fIndex).name);
            %startIndex = (START_TIME_IND_SECOND-1)*SAMPLING_RATE+1;
            %% width of the epoch is the sampling rate times epoch time in second.
            epochWidth = SAMPLING_RATE*EPOCH_TIME_IN_SECOND;





            %
            %
            %             fromFile=str2double(app.editTestFileIDFrom.Value);
            %             fromEpoch= str2double(app.editTestEpochIDFrom.Value);
            %             fromDimension=str2double(app.editTestDimensionIDFrom.Value);
            %
            %
            %
            %
            %             toFile=str2double(app.editTestFileIDTo.Value);
            %             toEpoch= str2double(app.editTestEpochIDTo.Value);
            %             toDimension=str2double(app.editTestDimensionIDTo.Value);



            fileList = UTIL_GUI.getFileIDList(app);

            columnList = UTIL_GUI.getDimensionList(app);
            allEpochList = UTIL_GUI.getEpochList(app);

            if isempty(allEpochList )
                allEpochList=1;
            end

            totalCount = (size(fileList,2) > 1 )+ (size(columnList,2) > 1) + isempty(columnList)+(size(allEpochList,2) > 1);

            if totalCount >1
                msgbox('Choose only one range among Files, columns or epochs');
                return;
            end
            % if size(fileList,2)>1 && size(columnList,2)>1
            %                 msgbox('Please select one of file and column...');
            %                 return;
            % end


            %             %scaleTest = UTIL_GUI.getIdListFromString(app.editS)
            %             selScaleIndex = find(strcmp(app.pMenuScale.Items,app.pMenuScale.Value));
            %             if (selScaleIndex==1)
            %                 corseGScale = UTIL_GUI.getIdListFromString(app.editScaleRange);
            %             else
            %                 corseGScale = [selScaleIndex-1];
            %             end



            %scaleTest = app.pMenuScale.Value;
            paramIncrement= str2double(app.editTestStepSize.Value);

            %totalCount=(toFile-fromFile+toEpoch-fromEpoch);
            currRunCount=0;
            f= waitbar(0,'0','Name','Processing statistic calculation .....');




            %    SampEn_DS
            %% m = 1 or 2 [Ronak: 2]; r = 0.15 or 0.25 x SD [Ronak: 2]; ? = 1 (?MAX = 12), N > 750
            %% sflag= 1 default
            %sflag = str2double(Param.SAMPLE_ENTROPY.sFlag.Text;
            %% set cflag = 0 for using SampEn_DS.m instead of cmatches.dll
            %cflag = str2double(Param.SAMPLE_ENTROPY.cFlag.Text;
            %% set m = 1 or 2

            xIndex=1;


            resultCol={};

            allEpoch=[];

            % toFile = min(toFile,size(PreprocessedDataSet,1));

            %diffCases = (fromFile<toFile)+(fromEpoch<toEpoch)+(fromDimension <toDimension);
            diffCases = (size(fileList,2)>1)+ (size(columnList,2)>1)+(size(allEpochList,2)>1)
            %selIndex = find(selData==1);
            %for fIndex  = fromFile:toFile
           
            for fIndex = fileList


                %data=loadData(handles,dbFilesCols,dbDirectoryPath,fIndex)  ;
                data = PreprocessedDataSet{fIndex,1};
               
              
                if app.chkSingleData.Value ==1
                    epochWidth=size(data,1);
                end
                epochTxt=app.editSelEpochList.Value;
                UTIL_GUI.setEpochList(app,  data, epochWidth, fIndex,epochTxt);

                %data = truncateDataBeyondRange(handles,data,MAX_DATA_LENGTH_SECOND,SAMPLING_RATE);
                %% truncate data

                %dimensionList = [fromDimension:toDimension];

                %dList = find(dimensionList>0 & dimensionList <=size(data,2));
                %dimensionList = dimensionList(1,dList);



                %data = removeOutliersAllData(handles,data);
                %totalEpoch = floor(N /epochWidth);
                % for v=dimensionList
                
                if isempty(columnList)
                    currColumnList = 1:size(data,2);
                else
                    
                    currColumnList=columnList;
                end
                
                for v = currColumnList
                    %                     for corseGScale = corseGScale
                    %                         currData=UTIL_GUI.getCorseGScale(currData(:,v),corseGScale,pMenuScaleSlideBy.Value,pMenuScaleAggregate.Value);
                    %for epochID = fromEpoch:toEpoch
                    %for epochID = [1]  %% need to work on this...
                    for epochID = allEpochList

                        if sum(epochList{fIndex}(1,:)==epochID)==0
                            continue;
                        else
                            if sum(allEpoch==epochID)==0
                                allEpoch=[allEpoch epochID];
                            end
                        end
                        %                     try
                        %                     epochID = epochList{fIndex}(1,eID);
                        %                     catch
                        %                         x=1;
                        %                     end
                        currSIndex = (epochID-1)*epochWidth+1;

                        try
                            endIndex = min(currSIndex+epochWidth-1,size(data,1));
                            currData = data(currSIndex:endIndex,:);
                        catch e

                            msgbox('Data Index out of range');
                            close(f);
                            break
                        end

                        % epochInfo{currIndex,1}=[epochID,currSIndex,endIndex];
                        % epochInfo{currIndex,2}=currData;

                        %    [~,data]=removeOutlierEpoch(handles,data,currData,currSIndex,endIndex,[]);
                        isError = true;
                        if(selData(STATISTIC_INDEX_TEST.SampEn_DS)==1)



                            try


                                tic
                                cd('../com/ExternalPackages/DataShare');





                                m =  str2double(app.editSE_M.Value);
                                tau =  str2double(app.editSE_TAU.Value);
                                r=str2double(app.editSE_R.Value);


                                m1 =  str2double(app.editSE_M_T1.Value);
                                tau1 =  str2double(app.editSE_TAU_T1.Value);
                                r1=str2double(app.editSE_R_T1.Value);

                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+tau1-tau+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);

                                diffParam = (m1>m) + (tau1>tau) + (r1<r);

                                if diffParam >1
                                    msgbox('Please provide the range in only one parameter ');
                                    close(f)
                                    return 
                                end

                                if (m1<m) || (tau1<tau) || (r1<r)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end



                                %                             elseif (diffCases+diffParam) > 1 && STATISTIC_INDEX.isTimeSeriesMeasure(selIndex)
                                %                                 msgbox('This is time series data so choose only one range')
                                %                             end
                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1
                                        for pR=r:paramIncrement:r1




                                            pR1=pR*nanstd(currData(:,v));
                                            resultCol{xIndex,yIndex}=SampEn(currData(isnan(currData(:,v))==0,v)',pM,pR1,pTau);






                                            if r1>r
                                                yIndex=yIndex+1;
                                            end
                                        end
                                        if tau1>tau
                                            yIndex=yIndex+1;
                                        end
                                    end
                                    if m1>m
                                        yIndex=yIndex+1;
                                    end

                                end

                                isError = false;

                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct
                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                                % more error handling...
                                %cTime = toc;
                                %app.txtInfoProcessing.Value = strcat('Computation Time :',num2str(toc)))
                                testRunTime=[testRunTime;toc];


                            end

                            %%%%%%%%%%%%%%%%%%HHHHHHHHHHaaaaaaaaaaa

                        elseif(selData(STATISTIC_INDEX_TEST.Continious_CS)==1)



                            try


                                tic
                                cd('../com/ExternalPackages/Santamaria code');





                                minValue = str2double(app.editCCM_Min.Value);
                                maxValue= str2double(app.editCCM_Max.Value);
                                distSS= str2double(app.editCCM_DistSS.Value);


                                minValue1 = str2double(app.editCCM_Min_T1.Value);
                                maxValue1= str2double(app.editCCM_Max_T1.Value);
                                distSS1= str2double(app.editCCM_DistSS_T1.Value);

                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((minValue1-m+maxValue1-tau+distSS1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);

                                diffParam = (minValue1>minValue) + (maxValue1>maxValue) + (distSS1>distSS);

                                if diffParam >1
                                    msgbox('Please provide the range in only one parameter ');
                                    close(f)
                                    return
                                end

                                if (minValue1<minValue) || (maxValue1<maxValue) || (distSS1<distSS)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end





                                %                             elseif (diffCases+diffParam) > 1 && STATISTIC_INDEX.isTimeSeriesMeasure(selIndex)
                                %                                 msgbox('This is time series data so choose only one range')
                                %                             end
                                yIndex =1;
                                for pMinValue=minValue:paramIncrement:minValue1
                                    for pMaxValue=maxValue:paramIncrement:maxValue1
                                        for pDistSS=distSS:paramIncrement:distSS1





                                            resultCol{xIndex,yIndex}=ContinuousComplexityMeasures(currData(isnan(currData(:,v))==0,v)',pMinValue,pMaxValue,pDistSS);






                                            if distSS1>distSS
                                                yIndex=yIndex+1;
                                            end
                                        end
                                        if maxValue1>maxValue
                                            yIndex=yIndex+1;
                                        end
                                    end
                                    if minValue1>minValue
                                        yIndex=yIndex+1;
                                    end

                                end

                                isError = false;

                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct
                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                                % more error handling...
                                %cTime = toc;
                                %app.txtInfoProcessing.Value = strcat('Computation Time :',num2str(toc)))
                                testRunTime=[testRunTime;toc];


                            end



                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ??? check0108
                        elseif(selData(STATISTIC_INDEX.FixedSampEn_fSampEn)==1)
                            isError = true;
                            try

                                cd('../com/ExternalPackages/Fixed SampEn');
                                tic

                                nWindow= str2num(app.editSampleR.Value);
                                factorNSteps= str2double(app.editFSampEn_fNumStep.Value);


                                m =  str2double(app.editFSampEn_M.Value);

                                rFact =  str2double(app.editFSampEn_R.Value);



                                tmpVal = nan(size(currData));


                                tmpData = currData(isnan(currData(:,v))==0,v);
                                rThreshold = rFact*nanstd(tmpData);
                                pSD = nanstd(tmpData);
                                %% floor or ceil ?????
                                pNStep=floor(factorNSteps*nWindow);
                                tmpVal(:,v)=fSampEn(tmpData,nWindow,pNStep,m,rThreshold,pSD);





                                StatisticCol{currIndex,STATISTIC_INDEX.FixedSampEn_fSampEn} = tmpVal;

                                ComputationTime{currIndex,STATISTIC_INDEX.FixedSampEn_fSampEn}=toc;
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct
                                if isError
                                    getReport(e)

                                end
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                            end



                        elseif(selData(STATISTIC_INDEX_TEST.SampEn_Richman)==1)



                            try


                                tic
                                cd('../com/ExternalPackages/SampEn');





                                m =  str2double(app.editSE_RH_M.Value);

                                r=str2double(app.editSE_RH_R.Value);


                                m1 =  str2double(app.editSE_RH_M_T1.Value);

                                r1=str2double(app.editSE_RH_R_T1.Value);

                                if (m1 > m )+ (r1 > r) >1
                                    msgbox('Please choose range in only one parameter');
                                    return;
                                end

                              

                                 if (m1<m) || (r1<r)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end







                                yIndex =1;
                                for pM=m:paramIncrement:m1

                                    for pR=r:paramIncrement:r1




                                        pR1=pR*nanstd(currData(:,v));
                                        resultCol{xIndex,yIndex}=sampen(currData(isnan(currData(:,v))==0,v)',pM,pR1);


                                        yIndex = yIndex1;



                                        
                                    end


                                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...
                                %cTime = toc;
                                %app.txtInfoProcessing.Value = strcat('Computation Time :',num2str(toc)))
                                testRunTime=[testRunTime;toc];

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                        elseif(selData(STATISTIC_INDEX_TEST.SlopeEntropy_SlopeEn)==1)

                            try

                                cd('../com/ExternalPackages/Cuesta-frau_SlopeEntropy');
                                tic
                                m = str2num(app.editSlopeEnM.Value);
                                gamma =  str2double(app.editSlopeEnGamma.Value);
                                delta =  str2double(app.editSlopeEnDelta.Value);



                                m1 = str2num(app.editSlopeEnM_T1.Value);
                                gamma1 =  str2double(app.editSlopeEnGamma_T1.Value);
                                delta1 =  str2double(app.editSlopeEnDelta_T1.Value);

                                 if ((m1 > m )+ (gamma1 > gamma) + (delta1 > delta))>1
                                    msgbox('Please choose range in only one parameter');
                                    return;
                                 end

                                  if (m1 < m ) || (gamma1 < gamma) || (delta1 > delta)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end






                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+gamma1-gamma+delta1-delta)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pGamma=gamma:paramIncrement:gamma1
                                        for pDelta=delta:paramIncrement:delta1




                                            [pe, ~] = SlopeEntr(currData(isnan(currData(:,v))==0,v), pM, pGamma, pDelta);
                                            resultCol{xIndex,yIndex}=pe;

                                            %resultCol{xIndex,yIndex}=getSlopeEntropy(currData(isnan(currData(:,v))==0,v),pM,pGamma,pDelta);
                                            %disp([xIndex yIndex]);

                                            yIndex = yIndex+1;


                                           
                                        end
                                       
                                    end
                                   
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.CosEn_And_QSE)==1)

                            try



                                cd('../com/ExternalPackages/DataShare');

                                tic

                                cosR = str2num(app.editCosEn_cosR.Value);
                                m =  str2double(app.editCosEn_M.Value);
                                tau =  str2double(app.editCosEn_TAU.Value);



                                cosR1 = str2num(app.editCosEn_cosR_T1.Value);
                                m1 =  str2double(app.editCosEn_M_T1.Value);
                                tau1 =  str2double(app.editCosEn_TAU_T1.Value);


                                if ((cosR1 > cosR) + (m1 > m) + (tau1 > tau)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end
                                 if (m1 < m ) || (tau1 < tau) || (cosR1 > cosR)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                 end


                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+tau1-tau+cosR1-cosR)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1
                                        for pCosR=cosR:paramIncrement:cosR1




                                            sE=SampEn_DS(currData(isnan(currData(:,v))==0,v)',pM,pCosR,pTau);


                                            resultCol{xIndex,yIndex}=sE + log(2*pCosR) - log(mean(currData));
                                            %disp([xIndex yIndex])

                                            yIndex = yIndex +1 




                                          
                                        end
                                       
                                    end
                                   


                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end

                            %%MSE
                        elseif(selData(STATISTIC_INDEX_TEST.mSE)==1)



                            try

                                tic

                                cd('../com/ExternalPackages/PhysioNet-Cardiovascular-Signal-Toolbox-1.0.2/Tools/Entropy_Tools');

                                m =  str2num(app.editMSE_M.Value);
                                r = str2double(app.editMSE_R.Value);
                                tau =  str2num(app.editMSE_Tau.Value);

                                m1 =  str2num(app.editMSE_M_T1.Value);
                                r1 = str2double(app.editMSE_R_T1.Value);
                                tau1 =  str2num(app.editMSE_Tau_T1.Value);


                                 if ((r1 > r) + (m1 > m) + (tau1 > tau)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end


                                  if (r1 < r) || (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end



                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+tau1-tau+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pR=r:paramIncrement:r1
                                        % for pTau=tau:paramIncrement:tau1


                                        for pTau = tau:paramIncrement:tau1


                                            pR1=pR*nanstd(currData(:,v));
                                            resultCol{xIndex,yIndex}=ComputeMultiscaleEntropy(currData(isnan(currData(:,v))==0,v)',pM,pR1,tau1);

                                            yIndex = yIndex + 1;

                                         
                                        end
                                    end
                                    
                                end
                              


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





                            %% Tsallis Permutation Entropy
                        elseif(selData(STATISTIC_INDEX_TEST.TsallisPE_TPE)==1)



                            try

                                tic

                                cd('../com/ExternalPackages/Luciano Zunino');





                                m =  str2num(app.editPTE_M.Value);
                                tau = str2double(app.editPTE_Tau.Value);
                                k =  str2num(app.editPTE_TO.Value);

                                m1 =  str2num(app.editPTE_M_T1.Value);
                                tau1 = str2double(app.editPTE_Tau_T1.Value);
                                k1 =  str2num(app.editPTE_TO_T1.Value);

                                  if ((k1 > k) + (m1 > m) + (tau1 > tau)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end

                                  if (k1 < k) || (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end






                              

                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1
                                        % for pTau=tau:paramIncrement:tau1


                                        for pK = k:paramIncrement:k1



                                            resultCol{xIndex,yIndex}=Tsallis_perm_entropy(currData(isnan(currData(:,v))==0,v),pM,pTau,pK);

%Tsallis_perm_entropy(currData(isnan(currData(:,v))==0,v),m,tau,k)
                                            yIndex = yIndex + 1;

                                         
                                            end
                                        end
                                       


                                    end
                                   
                                
                                %                     if tau1>tau
                                %                         yIndex=yIndex+1;
                                %                     end
                                %
                                %                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %% Renyi Permutation Entropy
                        elseif(selData(STATISTIC_INDEX_TEST.RenyiPE_RPE)==1)



                            try

                                tic

                                cd('../com/ExternalPackages/Luciano Zunino');





                                m =  str2num(app.editRPE_M.Value);
                                tau = str2double(app.editRPE_Tau.Value);
                                k =  str2num(app.editRPE_RO.Value);

                                m1 =  str2num(app.editRPE_M_T1.Value);
                                tau1 = str2double(app.editRPE_Tau_T1.Value);
                                k1 =  str2num(app.editRPE_RO_T1.Value);

                                 if ((k1 > k) + (m1 > m) + (tau1 > tau)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end

                                   if (k1 < k) || (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end





                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+tau1-tau+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                   
                                    for pTau=tau:paramIncrement:tau1
                                        % for pTau=tau:paramIncrement:tau1


                                        for pK = k:paramIncrement:k1



                                            resultCol{xIndex,yIndex}=Renyi_perm_entropy(currData(isnan(currData(:,v))==0,v),pM,pTau,pK);

                                            yIndex = yIndex + 1;

                                        end
                                       


                                    end
                                   
                                end
                                %                     if tau1>tau
                                %                         yIndex=yIndex+1;
                                %                     end
                                %
                                %                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end

                            %%%%%%%%%%%%%%%%%%%% editPE


                            %% Renyi Permutation Entropy
                            %elseif(selData(STATISTIC_INDEX_TEST.RenyiPE_RPE)==1)
                        elseif(selData(STATISTIC_INDEX_TEST.Edge_PE)==1)



                            try

                                tic
                                cd('../com/ExternalPackages/edgePE');
                                %cd('../com/ExternalPackages/Luciano Zunino');


                                m = str2double(app.editEdgePE_M.Value);
                                t = str2double(app.editEdgePE_T.Value);
                                r= str2double(app.editEdgePE_R.Value);

                                m1 = str2double(app.editEdgePE_M_T1.Value);
                                t1 = str2double(app.editEdgePE_T_T1.Value);
                                r1= str2double(app.editEdgePE_R_T1.Value);

                                 if ((t1 > t) + (m1 > m) + (r1 > r)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end


                                  if (r1 < r) || (m1 < m) || (t1 < t)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end



                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pT=t:paramIncrement:t1
                                        % for pTau=tau:paramIncrement:tau1


                                        for pR = r:paramIncrement:r1



                                            resultCol{xIndex,yIndex}=edgePE(currData(isnan(currData(:,v))==0,v)',pM,pT,pR);
                                            yIndex=yIndex+1;


                                            
                                        end
                                        

                                    end
                                    
                                end
                                %                     if tau1>tau
                                %                         yIndex=yIndex+1;
                                %                     end
                                %
                                %                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                        elseif(selData(STATISTIC_INDEX_TEST.Higuchi_FD)==1)

                            try
                                cd('../com/ExternalPackages/Fractal_dimension_measures');
                                tic
                                kMax = str2double(app.editHiguchiFD_KMax.Value);
                                kMax1 = str2double(app.editHiguchiFD_KMax_T1.Value);

                                if (kMax1 < kMax) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end





                                yIndex =1;
                                for pKMax=kMax:paramIncrement:kMax1
                                    resultCol{xIndex,yIndex}=Higuchi_FD(currData(isnan(currData(:,v))==0,v)',pKMax);
                                    
                                     yIndex=yIndex+1;
                                
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end



                            %%work01

                            %%%%%%%%%%%%%%%%%%


                            %%%% Shannon Extropy




                        elseif(selData(STATISTIC_INDEX_TEST.ShannonExtropy_SEx)==1)
                            try

                                tic
                                cd('../com/ExternalPackages/Giuseppse_Extropies');
                                m = str2double(app.editSEx_M.Value);
                                numInt = str2num(app.editSEx_NumInt.Value);

                                m1 = str2double(app.editSEx_M_T1.Value);
                                numInt1 = str2num(app.editSEx_NumInt_T1.Value);

                                 if ( (m1 > m) + (numInt1 > numInt)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end

                                 if (numInt1 < numInt) || (m1 < m)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                  end




                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pNumInt=numInt:paramIncrement:numInt1
                                        resultCol{xIndex,yIndex}=ShannonExtropy(currData(~isnan(currData(:,v)),v),pM,pNumInt);
                                        yIndex=yIndex+1;
                                    end
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct
                                testRunTime=[testRunTime;toc];
                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value
                                    rethrow(e);
                                elseif  isError
                                    getReport(e);

                                end
                            end
                            %%HRA symmetrics



                        elseif(selData(STATISTIC_INDEX_TEST.HRA_PI_GI_AI_SI)==1)

                            try
                                cd('../com/ExternalPackages/Ashis');
                                tic
                                tau   =str2double(app.editHRM_Tau.Value);
                                tau1   =str2double(app.editHRM_Tau_T1.Value);

                                methodID = find(strcmp(app.pMenuHRM.Items,app.pMenuHRM.Value));


                              if (tau1 > tau) && (methodID == 1)
                                    msgbox('Please choose only one range in parameters')                                    
                                    close(f);
                                    return
                                  end

                                if (tau1 < tau)                                 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end

                                yIndex =1;
                                for pTau=tau:paramIncrement:tau1
                                    tmpVal= nan(4,1);
                                    hrm = hrasymm(currData(~isnan(currData(:,v)),v),pTau) ;

                                    tmpVal(1,1)=hrm.PI;
                                    tmpVal(2,1)=hrm.GI;
                                    tmpVal(3,1)=hrm.SI;
                                    tmpVal(4,1)=hrm.AI;



                                    if methodID ==1

                                        resultCol{xIndex,yIndex}=tmpVal(1,1);                                    
                                        yIndex=yIndex+1;

                                        resultCol{xIndex,yIndex}=tmpVal(2,1);                                    
                                        yIndex=yIndex+1;

                                        resultCol{xIndex,yIndex}=tmpVal(3,1);                                    
                                        yIndex=yIndex+1;

                                        resultCol{xIndex,yIndex}=tmpVal(4,1);                                    
                                        yIndex=yIndex+1;
                                    else

                                         resultCol{xIndex,yIndex}=tmpVal(methodID-1,1);                                    
                                         yIndex=yIndex+1;
                                    end

                                    
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end





                            %%% nldwan

                        elseif(selData(STATISTIC_INDEX_TEST.FD_nldwan)==1)



                            try


                                tic
                                cd('../com/ExternalPackages/Fractal_dimension_measures')

                                m =  str2double(app.editFDnldwanWL.Value);

                                tau=str2double(app.editFDnldwanWS.Value);

                                m1 =  str2double(app.editFDnldwanWL_T1.Value);

                                tau1=str2double(app.editFDnldwanWS_T1.Value);

                              





                               if ((tau1 > tau) + (m1 > m)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                               end

                                 if (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end






                                

                                yIndex =1;
                                for pM=m:paramIncrement:m1

                                    for pTau=tau:paramIncrement:tau1




                                        [meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldwan(currData(isnan(currData(:,v))==0,v),pM,pTau,[]);
                                        allResults = [meanFDiml,stdFDiml,meanFImp,stdFImp];
                                        ind = find(strcmp(app.pMenuFDNldwan.Items,app.pMenuFDNldwan.Value)) ;


                                        resultCol{xIndex,yIndex}=allResults(1,ind);


                                        yIndex=yIndex+1;



                                        
                                    end

                                   

                                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...
                                %cTime = toc;
                                %app.txtInfoProcessing.Value = strcat('Computation Time :',num2str(toc)))
                                testRunTime=[testRunTime;toc];

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                        elseif(selData(STATISTIC_INDEX_TEST.FD_nldian)==1)



                            try


                                tic
                                cd('../com/ExternalPackages/Fractal_dimension_measures')

                                

                                m =  str2double(app.editFDnldianWL.Value);

                                tau=str2double(app.editFDnldianWS.Value);

                                m1 =  str2double(app.editFDnldianWL_T1.Value);

                                tau1=str2double(app.editFDnldianWS_T1.Value);

                                if ((tau1 > tau) + (m1 > m)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                  if (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end




                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+tau1-tau+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1

                                    for pTau=tau:paramIncrement:tau1




                                        [meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldian(currData(isnan(currData(:,v))==0,v),pM,pTau,[]);
                                        allResults = [meanFDiml,stdFDiml,meanFImp,stdFImp];
                                        ind = find(strcmp(app.pMenuFDNldian.Items,app.pMenuFDNldian.Value)) ;


                                        resultCol{xIndex,yIndex}=allResults(1,ind);

                                        yIndex=yIndex+1;

                                    end

                                    
                                end



                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...
                                %cTime = toc;
                                %app.txtInfoProcessing.Value = strcat('Computation Time :',num2str(toc)))
                                testRunTime=[testRunTime;toc];

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                            %%%%  CPEI


                        elseif(selData(STATISTIC_INDEX_TEST.CPEI_olofsen)==1)

                            try
                                cd('../com/ExternalPackages/Olofsen_CPEI')
                                tic
                                epz   =str2double(app.editCPEI_epz.Value);
                                epz1   =str2double(app.editCPEI_epz_T1.Value);


                                if (epz1 < epz) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end


                                yIndex =1;
                                for pKMax=epz:paramIncrement:epz1

                                    tmpEPZ=pKMax;
                                    if app.chkUseIntraQuarderRange.Value ==1



                                        q = quantile(currData(isnan(currData(:,v))==0,v),[.25 .50 .75]);

                                        tmpEPZ=(q(3)-q(1))*pKMax;
                                    end



                                    resultCol{xIndex,yIndex}=CPEI(currData(isnan(currData(:,v))==0,v),tmpEPZ);
                                    yIndex=yIndex+1;
                                    

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end








                            %%% Tone Entropy


                        elseif(selData(STATISTIC_INDEX_TEST.ToneEntropy_T_E)==1)

                            try

                                cd('../com/ExternalPackages/ToneEntropy');
                                tic
                                m = str2double(app.editToneE_M.Value);
                                m1 = str2double(app.editToneE_M_T1.Value);

                                if (m1 < m) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end





                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((kMax1-kMax)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                %for pM=m:paramIncrement:m1



                                [a,b]=getMultiLagToneEntropy_Karm(currData(isnan(currData(:,v))==0,v),m1);
                                outputIndex = find(strcmp(app.pMenuToneEntropy.Items,app.pMenuToneEntropy.Value)) ;
                                %disp([xIndex yIndex])
                                if  outputIndex==1
                                    tmpVal=a;
                                else
                                    tmpVal=b;
                                end

                                if m1>m
                                    for pM=m:paramIncrement:m1
                                        resultCol{xIndex,yIndex}=tmpVal(1,pM);
                                        yIndex=yIndex+1;
                                    end
                                else
                                     resultCol{xIndex,yIndex}=tmpVal(1,m1)
                                     yIndex=yIndex+1;
                                end

                                %end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end








                        elseif(selData(STATISTIC_INDEX_TEST.AlanFactor_AF)==1)


                            try
                                cd('../com/ExternalPackages/DavidCornforth_HRV');
                                tic
                                nWindow = str2double(app.editAlanFactor_nWindow.Value);
                                nWindow1 = str2double(app.editAlanFactor_nWindow_T1.Value);

                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((kMax1-kMax)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                            
                                if (nWindow1 < nWindow) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end


                                yIndex =1;
                                for pWindow=nWindow:paramIncrement:nWindow1



                                    resultCol{xIndex,yIndex}=getAllanFactor(currData(isnan(currData(:,v))==0,v),pWindow);
                                    %disp([xIndex yIndex])

                                   

                                        yIndex=yIndex+1;
                                   

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                testRunTime=[testRunTime;toc];
                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.CorrDim_D2)==1)

                            try



                                cd('../com/ExternalPackages/matlabToolBox/Predictive Maintenance');


                                m=str2num(app.editCorrDimM.Value);
                                tau =str2num(app.editCorrDimLag.Value);

                                m1=str2num(app.editCorrDimM_T1.Value);
                                tau1 =str2num(app.editCorrDimLag_T1.Value);

                                  if ((tau1 > tau) + (m1 > m) ) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end

                                if (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1

                                        tic
                                        resultCol{xIndex,yIndex} = correlationDimension(currData(isnan(currData(:,v))==0,v),pM,pTau);
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                    end                                

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back



                                cd('../../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end
                        elseif(selData(STATISTIC_INDEX_TEST.ReverseA_Test)==1)

                            try

                                cd('../com/ExternalPackages/ECheynet-stationaryTests-af2a370');


                                paramIncrement=1;
                                app.editTestStepSize.Value = '1';
                                method1=2;
                                method=1;

                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((method1-method)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pMethod=method:paramIncrement:method1


                                    tic
                                    resultCol{xIndex,yIndex}=RA_test(currData(isnan(currData(:,v))==0,v)',pMethod);
                                    testRunTime=[testRunTime;toc];
                                    %disp([xIndex yIndex])


                                    yIndex=yIndex+1;

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct


                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end

                            end


                    elseif(selData(STATISTIC_INDEX_TEST.ShapiroWilkTest)==1)

                            try
                                %  cd('../com/ExternalPackages/Fractal_dimension_measures');
                                cd('../com/ExternalPackages/swtest');
                               alpha = str2double(app.editSW_P.Value);
                                if alpha <=0 || alpha >=1
                                    alpha = 0.05;
                                    app.editSW_P.Value = '0.05';
                                end
                                

                                alpha1 = str2double(app.editSW_P_T1.Value);
                                if alpha1 <=0 || alpha1 >=1
                                    alpha1 = 1;
                                    app.editSW_P_T1.Value = '1.005';
                                end

                                  if (alpha1 < alpha) 
                                    msgbox('Invalid Range.... ');
                                    close(f);
                                    return
                                  end


                                




                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((alpha1-alpha)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pAlpha=alpha:paramIncrement:alpha1

                                   tic
                                   
                                    [H, pValue, SWstatistic] = swtest(currData(isnan(currData(:,v))==0,v), pAlpha);
                                    tmpResults = [H, pValue, SWstatistic];
                                    index = find(strcmp(app.pMenuSW_Measures.Items,app.pMenuSW_Measures.Value));
                                    resultCol{xIndex,yIndex}=tmpResults(1,index);
                                    testRunTime=[testRunTime;toc];
                                    %disp([xIndex yIndex])


                                    yIndex=yIndex+1;

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end
                        















                        elseif(selData(STATISTIC_INDEX_TEST.KolmogorovSmirnovTest)==1)

                            try
                                %  cd('../com/ExternalPackages/Fractal_dimension_measures');

                                alpha = str2double(app.editKSLevelOfSig.Value);
                                alpha1 = str2double(app.editKSLevelOfSig_T1.Value);


                                if alpha <=0 || alpha >=1
                                    alpha = 0.05;
                                    app.editKSLevelOfSig.Value = '0.05';
                                end


                                if alpha1 <=0 || alpha1 >=1
                                    alpha1 = 0.05;
                                    app.editKSLevelOfSig_T1.Value = '0.05';
                                end


                                if (alpha1 < alpha) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end

                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((alpha1-alpha)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pAlpha=alpha:paramIncrement:alpha1


                                    tic
                                    resultCol{xIndex,yIndex}=kstest(currData(isnan(currData(:,v))==0,v)','alpha',pAlpha);
                                    testRunTime=[testRunTime;toc];
                                    %disp([xIndex yIndex])


                                    yIndex=yIndex+1;

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                %%cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end
                            %
                            %%%%%%%%%%%%%% profiling

                            %% approx
                        elseif(selData(STATISTIC_INDEX_TEST.AvgApEn_Profile)==1)

                            try
                                cd('../com/ExternalPackages/Chanda/Entropy-Codes-master/Approximate entropy');

                                m = str2double(app.editAvgApEn_Profile_M.Value);
                                m1 = str2double(app.editAvgApEn_Profile_M_T1.Value);

                                if (m1 < m)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end




                                yIndex =1;
                                for pM=m:paramIncrement:m1


                                    tic
                                    tmpV=apEnProfiling(currData(isnan(currData(:,v))==0,v),pM);
                               
                                    profile = tmpV(~isinf(tmpV(:,2)),2);

                                    resultCol{xIndex,yIndex}=nanmean(profile);
                                    testRunTime=[testRunTime;toc];
                                    %disp([xIndex yIndex])


                                    yIndex=yIndex+1;

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end
                            %


                            %% Sample
                        elseif(selData(STATISTIC_INDEX_TEST.AvgSampEn_Profile)==1)

                            try
                                cd('../com/ExternalPackages/Chanda/Entropy-Codes-master/Sample entropy');

                                m = str2double(app.editAvgSampEn_Profile_M.Value);
                                m1 = str2double(app.editAvgSampEn_Profile_M_T1.Value);

                                if (m1 < m)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end


                                yIndex =1;
                                for pM=m:paramIncrement:m1


                                    tic
                                    tmpV=sampEnProfiling(currData(isnan(currData(:,v))==0,v),pM);

                                    profile = tmpV(~isinf(tmpV(:,2)),2);



                                   resultCol{xIndex,yIndex}=nanmean(profile);
                                    testRunTime=[testRunTime;toc];
                                    %disp([xIndex yIndex])


                                    yIndex=yIndex+1;

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e)

                                end
                            end
                            %








                        elseif(selData(STATISTIC_INDEX_TEST.ImPE)==1)

                            try



                                cd('../com/ExternalPackages/DataShare');


                                m = str2double(app.editImPEM.Value);
                                t = str2double(app.editImPET.Value);
                                scale = str2double(app.editImPEScale.Value);

                                m1 = str2double(app.editImPEM_T1.Value);
                                t1 = str2double(app.editImPET_T1.Value);
                                scale1 = str2double(app.editImPEScale_T1.Value);


                                  if ((t1 > t) + (m1 > m) + (scale1 > scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end

                                  if (scale1 < scale) || (m1 < m) || (t1 < t)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end





                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pT=t:paramIncrement:t1

                                        tic
                                        tmpVal = impe(currData(isnan(currData(:,v))==0,v),pM,pT,scale1);
                                        testRunTime=[testRunTime;toc];
                                        for pScale=scale:paramIncrement:scale1

                                            resultCol{xIndex,yIndex}=tmpVal(1,pScale);
                                            
                                            yIndex=yIndex+1;
                                           

                                        end
                                        
                                    end
                                    
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                        elseif(selData(STATISTIC_INDEX_TEST.MultiscalePE_mPE)==1)

                            try



                                cd('../com/ExternalPackages/MPerm');


                                m = str2double(app.editPEM.Value);
                                t = str2double(app.editPET.Value);
                                scale = str2double(app.editPEScale.Value);

                                m1 = str2double(app.editPEM_T1.Value);
                                t1 = str2double(app.editPET_T1.Value);
                                scale1 = str2double(app.editPEScale_T1.Value);


                               if ((t1 > t) + (m1 > m) + (scale1 > scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                               end

                                if (scale1 < scale) || (m1 < m) || (t1 < t)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end



                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pT=t:paramIncrement:t1

                                        tic

                                        %resultCol{xIndex,yIndex} = MPerm(currData(isnan(currData(:,v))==0,v),pM,pT,scale1);
                                        tmpVal = MPerm(currData(isnan(currData(:,v))==0,v),pM,pT,scale1);
                                        testRunTime=[testRunTime;toc];
                                        disp('Corking...')

                                        for pScale=scale:scale1
                                            resultCol{xIndex,yIndex}=tmpVal(1,pScale);
                                            
                                             yIndex=yIndex+1;
                                        end
                                    end
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                            %%Shannon Entropy
                        elseif(selData(STATISTIC_INDEX_TEST.ShannonEntropy_SE)==1)

                            try

                                cd('../com/ExternalPackages/Entropy_measures');


                                m = str2double(app.editShEn_M.Value);
                                numInt = str2double(app.editShEn_numInt.Value);

                                m1 = str2double(app.editShEn_M_T1.Value);
                                numInt1 = str2double(app.editShEn_numInt_T1.Value);

                                if ((m1 > m) + (numInt1 > numInt)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (m1 < m) || (numInt1 < numInt)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end





                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pNumInt=numInt:paramIncrement:numInt1

                                        tic
                                        resultCol{xIndex,yIndex} = ShannonEn(currData(isnan(currData(:,v))==0,v),pM,pNumInt);
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                    end
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end

                            end

                            %%%%% MoChan Entropy



                            %%Permutation JS Complexity PJSC
                        elseif(selData(STATISTIC_INDEX_TEST.Permutation_JS_Complexity_PJSC)==1)

                            try

                                cd('../com/ExternalPackages/Luciano Zunino');


                                m = str2double(app.editPJSC_M.Value);
                                tau = str2double(app.editPJSC_Tau.Value);

                                m1 = str2double(app.editPJSC_M_T1.Value);
                                tau1 = str2double(app.editPJSC_Tau_T1.Value);






                                  if ((tau1 > tau) + (m1 > m) ) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end


                                  if (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end




                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1

                                        tic
                                        resultCol{xIndex,yIndex} = JS_complexity(currData(isnan(currData(:,v))==0,v),pM,pTau);
                                        testRunTime=[testRunTime;toc];

                                       
                                        yIndex=yIndex+1;
                                        
                                    end
                                   
                                     

                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end

                            end




                            %%%%%%%%%%%%%%%%%%%%%Harikala
                            %%Entropy of Difference
                        elseif(selData(STATISTIC_INDEX_TEST.EntropyOfDifference_EoD)==1)

                            try

                                cd('../com/algorithms/EntropyOfDiff');


                                m = str2double(app.editEoD_M.Value);
                                shift = str2num(app.editEoD_Shift.Value);

                                m1 = str2double(app.editEoD_M_T1.Value);
                                shift1 = str2num(app.editEoD_Shift_T1.Value);

                                if ((shift1 > shift) + (m1 > m) ) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end


                                if (m1 < m) || (shift1 < shift)
                                    msgbox('Invalid Range.... ');
                                    close(f);
                                    return
                                end


                                  


                                


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pShift=shift:paramIncrement:shift1
                                        %%EDm = getEntropyOfDiff(data,m,shiftN)
                                        %[~,tmpValue(1,i)]=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);


                                        tic
                                        resultCol{xIndex,yIndex} = getEntropyOfDiff(currData(isnan(currData(:,v))==0,v),pM,pShift);
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                        
                                    end
                                   
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end

                            end

                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        elseif(selData(STATISTIC_INDEX_TEST.KullbachLeiblerDivergence_KLD)==1)

                            try



                                cd('../com/algorithms/EntropyOfDiff');


                                m = str2num(app.editKLD_M.Value);
                                shift = str2num(app.editKLD_Shift.Value);

                                m1 = str2num(app.editKLD_M_T1.Value);
                                shift1 = str2num(app.editKLD_Shift_T1.Value);

                                 if ((shift1 > shift) + (m1 > m) ) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end

                                  if (m1 < m) || (shift1 < shift)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end




                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pShift=shift:paramIncrement:shift1
                                        
                                        tic
                                        [~, resultCol{xIndex,yIndex}] = getEntropyOfDiff(currData(isnan(currData(:,v))==0,v),pM,pShift);
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                    end
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end

                            end


                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                            %% MPE

                        elseif(selData(STATISTIC_INDEX_TEST.mPM_E)==1)

                            try
                                cd('../com/ExternalPackages');

                                m = str2double(app.editMPeM.Value);
                                t = str2double(app.editMPeT.Value);
                                %scale = str2double(app.editMPeScale.Value);

                                m1 = str2double(app.editMPeM_T1.Value);
                                t1 = str2double(app.editMPeT_T1.Value);
                                %scale1 = str2double(app.editMPeScale_T1.Value);

                                if ((t1 > t) + (m1 > m)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end


                                if (m1 < m) || (t1 < t)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end


                               

                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pT=t:paramIncrement:t1

                                        tic
                                        resultCol{xIndex,yIndex}=perm_min_entropy(currData(isnan(currData(:,v))==0,v),pM,pT);
                                        %tmpVal = MPerm(currData(isnan(currData(:,v))==0,v),pM,pT,scale1);
                                        testRunTime=[testRunTime;toc];
                                       
                                        yIndex=yIndex+1;
                                    end
                                end
                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                      %%%%%%%%%%%%%%%

                        elseif(selData(STATISTIC_INDEX_TEST.RCmSE_SD)==1)

                            try

                                cd('../com/ExternalPackages/DataShare')
                                m = str2double(app.editRCMSEstdM.Value);
                                tau = str2double(app.editRCMSEstdTau.Value);
                                r = str2double(app.editRCMSEstdR.Value);
                                scale = str2double(app.editRCMSEstdScale.Value);

                                m1 = str2double(app.editRCMSEstdM_T1.Value);
                                tau1 = str2double(app.editRCMSEstdTau_T1.Value);
                                r1 = str2double(app.editRCMSEstdR_T1.Value);
                                scale1 = str2double(app.editRCMSEstdScale_T1.Value);


                                if ((tau1 > tau) + (m1 > m) + (r1 > r)+(scale1 > scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (scale1 < scale) || (m1 < m) || (t1 < t) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end






                               yIndex =1;
                                for pR=r:paramIncrement:r1

                                    for pM=m:paramIncrement:m1
                                        for pTau=tau:paramIncrement:tau1

                                            tmpR = pR*nanstd(currData(:,v));
                                            tic
                                            tmpVal = [RCMSE_std(currData(isnan(currData(:,v))==0,v)',pM,tmpR,pTau,scale1)]
                                            testRunTime=[testRunTime;toc];
                                            for pScale=scale:paramIncrement:scale1
                                                resultCol{xIndex,yIndex}=tmpVal(1,pScale);
                                                yIndex=yIndex+1;                                               
                                            end
                                        end
                                    end
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end

















                        elseif(selData(STATISTIC_INDEX_TEST.AverageEntropy_AE)==1)

                            try

                                cd('../com/ExternalPackages/EA')
                                bins = str2double(app.editAE_BinSize.Value);
                                pScale = str2double(app.editAE_Scale.Value);
                                pMin = str2double(app.editAE_Min.Value);
                                pMax = str2double(app.editAE_Max.Value);

                                bins1 = str2double(app.editAE_BinSize_T1.Value);
                                pScale1 = str2double(app.editAE_Scale_T1.Value);
                                pMin1 = str2double(app.editAE_Min_T1.Value);
                                pMax1 = str2double(app.editAE_Max_T1.Value);

                                






                                if ((bins1 > bins) + (pScale1 > pScale) + (pMin1 > pMin)+(pMax1 > pMax)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (bins1 < bins) || (pScale1 < pScale) || (pMin1 < pMin) || (pMax1 < pMax)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end



                                %% using the pe defined in datasehare
                                %% mulitdimension check
                                %% using loop
                                %% here pe(currData,m,t) return single value for muldimension as well ???




                                %nRange = ceil(((m1-m+tau1-tau+scale1-scale+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pPScale=pScale:paramIncrement:pScale1
                                    for pBins=bins:paramIncrement:bins1
                                        for pPMin=pMin:paramIncrement:pMin1


                                            for pPMax=pMax:paramIncrement:pMax1




                                                tic
                                                %scale,bins,min,Max)
                                                [~,resultCol{xIndex,yIndex}] = EA(currData(isnan(currData(:,v))==0,v),pPScale,pBins,pPMin,pPMax);
                                                testRunTime=[testRunTime;toc];
                                                yIndex=yIndex+1;                                              
                                            end
                                        end
                                    end
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end






                        elseif(selData(STATISTIC_INDEX_TEST.Entropy_of_Entropy_EoE)==1)

                            try

                                cd('../com/ExternalPackages/EA')
                                bins = str2double(app.editEE_BinSize.Value);
                                pScale = str2double(app.editEE_Scale.Value);
                                pMin = str2double(app.editEE_Min.Value);
                                pMax = str2double(app.editEE_Max.Value);

                                bins1 = str2double(app.editEE_BinSize_T1.Value);
                                pScale1 = str2double(app.editEE_Scale_T1.Value);
                                pMin1 = str2double(app.editEE_Min_T1.Value);
                                pMax1 = str2double(app.editEE_Max_T1.Value);

                                 if ((bins1 > bins) + (pScale1 > pScale) + (pMin1 > pMin)+(pMax1 > pMax)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end


                                  if (bins1 < bins) || (pScale1 < pScale) || (pMin1 < pMin) || (pMax1 < pMax)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                  end



                                yIndex =1;
                                for pPScale=pScale:paramIncrement:pScale1
                                    for pBins=bins:paramIncrement:bins1
                                        for pPMin=pMin:paramIncrement:pMin1
                                            for pPMax=pMax:paramIncrement:pMax1
                                                tic
                                                %scale,bins,min,Max)
                                                resultCol{xIndex,yIndex} = EA(currData(isnan(currData(:,v))==0,v),pPScale,pBins,pPMin,pPMax);
                                                testRunTime=[testRunTime;toc];

                                                yIndex=yIndex+1;
    
                                            end
                                        end
                                    end
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value
                                    rethrow(e);
                                elseif  isError

                                    getReport(e)

                                end
                            end

                        elseif(selData(STATISTIC_INDEX_TEST.AmplitudeAware_PE)==1)

                            try

                                %cd('../com/ExternalPackages/EA')
                                cd('../com/ExternalPackages/DataShare')
                                m = str2double(app.editAAPEM.Value);
                                t = str2double(app.editAAPET.Value);
                                a = str2double(app.editAAPEA.Value);

                                m1 = str2double(app.editAAPEM_T1.Value);
                                t1 = str2double(app.editAAPET_T1.Value);
                                a1 = str2double(app.editAAPEA_T1.Value);





                                if ((t1 > t) + (m1 > m) + (a1 > a)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (m1 < m) || (t1 < t) || (a1 < a)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end




                                yIndex =1;

                                for pM=m:paramIncrement:m1
                                    for pT=t:paramIncrement:t1

                                        for pA=a:paramIncrement:a1

                                            tic
                                            %AAPE(y,m,varargin)
                                            resultCol{xIndex,yIndex} = AAPE_Corr(currData(isnan(currData(:,v))==0,v),pM,pT,pA);
                                            testRunTime=[testRunTime;toc];
                                            yIndex=yIndex+1;
                                        end                                      
                                    end                                   
                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                        elseif(selData(STATISTIC_INDEX_TEST.mFD_Maragos)==1)

                            try
                                tic

                                %cd('../com/ExternalPackages/EA')
                                cd('../com/ExternalPackages/MFD_NTUA');
                                scale=str2num(app.editMultiScaleFD_scale.Value);
                                window = str2num(app.editMultiScaleFD_M.Value);

                                scale1=str2num(app.editMultiScaleFD_scale_T1.Value);
                                window1 = str2num(app.editMultiScaleFD_M_T1.Value);




                                if ((scale1 > scale) + (window1 > window)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (scale1 < scale) || (window1 < window) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end






                                yIndex =1;

                                for pWindow=window:paramIncrement:window1
                                            myANS = frdimsigfmc1(currData(:,v),'maxscale',scale1,'window',pWindow);

                                            if scale1 > scale
                                                for val = myANS'
                                                    resultCol{xIndex,yIndex}=val;
                                                    yIndex=yIndex+1;
                                                end
                                            else
                                                resultCol{xIndex,yIndex}=myANS(end);
                                                yIndex=yIndex+1;
                                            end


                                   

                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end







                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                        elseif(selData(STATISTIC_INDEX_TEST.FuzzyEntropy_FE)==1)

                            try

                                cd('../com/ExternalPackages/FuzzyEntropy_Matlab-master');
                                m = str2double(app.editFE_M.Value);
                                t = str2double(app.editFE_T.Value);
                                mf = find(strcmp(app.pMenuFE_MF.Items,app.pMenuFE_MF.Value)) ;

                                local = find(strcmp(app.pMenuFE_L.Items,app.pMenuFE_L.Value)) ;
                                tau = str2double(app.editFE_Tau.Value);


                                m1 = str2double(app.editFE_M_T1.Value);
                                t1 = str2double(app.editFE_T_T1.Value);





                                if app.chkFE_MF.Value == 1
                                    mf=1;
                                    mf1 = size(properties(CONS_FUZZY_ENTROPY),1);
                                    paramIncrement= 1;
                                    app.editTestStepSize.Value='1';
                                else
                                    mf1=mf;
                                end
                                t1 = str2double(app.editFE_T_T1.Value);
                                %local1 = str2double(app.pMenuFE_L_T1.Value );

                                if app.chkFE_L.Value ==1
                                    local=1;
                                    local1 = 2;
                                    paramIncrement= 1;
                                    app.editTestStepSize.Value= '1';

                                else
                                    local1=local;
                                end


                                tau1 = str2double(app.editFE_Tau_T1.Value);



                                if ((t1 > t) + (m1 > m) + (local1 > local)+(tau1 > tau)+(mf1 > mf)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (m1 < m) || (t1 < t) ||  (local1 < local) || (tau1 < tau) || (mf1 < mf)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end



                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pMF=mf:paramIncrement:mf1
                                        for pT=t:paramIncrement:t1
                                            for pLocal=local:paramIncrement:local1
                                                for pTau=tau:paramIncrement:tau1                                                   
                                                    if app.chkFE_MF.Value ==1
                                                        tmpRn = CONS_FUZZY_ENTROPY.getRnValue(pMF)*nanstd(currData(:,v));
                                                    else
                                                        tmpRn=pT*nanstd(currData(:,v));
                                                    end
                                                    tic
                                                    %                           FuzEn_MFs(ts, m, mf, rn, local,tau)

                                                    %resultCol{xIndex,yIndex} = FuzEn_MFs(currData(isnan(currData(:,v))==0,v)',pM,CONS_FUZZY_ENTROPY.getMembershipFName(pMF),pThreshold,(pLocal-1)==1,pTau);
                                                    resultCol{xIndex,yIndex} = FuzEn_MFs(currData(isnan(currData(:,v))==0,v)',pM,CONS_FUZZY_ENTROPY.getMembershipFName(pMF),tmpRn,(pLocal-1)==1,pTau);
                                                    testRunTime=[testRunTime;toc];
                                                    yIndex=yIndex+1;
                                                end
                                            end
                                        end
                                    end
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                %format shortEng
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                            %^%%%55555


                        elseif(selData(STATISTIC_INDEX_TEST.FuzzyEntropy_CAFE)==1)

                            try

                                cd('../com/ExternalPackages/centered and averaged FE');
                                m = str2double(app.editFE_CAFE_M.Value);
                                %% threshold r and order n
                                r=str2double(app.editFE_CAFE_R.Value);
                                %% time delay
                                p=str2double(app.editFE_CAFE_P.Value);


                                m1 = str2double(app.editFE_CAFE_M_T1.Value);
                                %% threshold r and order n
                                r1=str2double(app.editFE_CAFE_R_T1.Value);
                                %% time delay
                                p1=str2double(app.editFE_CAFE_P_T1.Value);

                                TypeName = {'T','R','I','G'};
                                type = find(strcmp(app.pMenuFE_CAFE_Type.Items,app.pMenuFE_CAFE_Type.Value));

                                %local=0 and global=1
                                centering = find(strcmp(app.pMenuFE_CAFE_Centering.Items,app.pMenuFE_CAFE_Centering.Value)) -1;






                                if app.chkFE_CAFE_Type.Value == 1
                                    type=1;
                                    type1 = 4;
                                    paramIncrement= 1;
                                    app.editTestStepSize.Value='1';
                                else
                                    type1=type;
                                end

                                %local1 = str2double(app.pMenuFE_L_T1.Value );

                                if app.chkFE_CAFE_Centering.Value ==1
                                    centering=0;
                                    centering1 = 1;
                                    paramIncrement= 1;
                                    app.editTestStepSize.Value= '1';

                                else
                                    centering1=centering;
                                end



                                if ((p1 > p) + (m1 > m) + (r1 > r)+(centering1 > centering)+(type1 > type)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                 if (m1 < m) || (p1 < p) ||  (r1 < r) || (centering1 < centering) || (type1 < type)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                 end



                                yIndex =1;
                                for pM=m:paramIncrement:m1

                                    for pCentering=centering:paramIncrement:centering1
                                        for pR=r:paramIncrement:r1
                                            for pType=type:paramIncrement:type1
                                                for pP=p:paramIncrement:p1                                                   
                                                    tmpR = pR*nanstd(currData(:,v));
                                                    resultCol{xIndex,yIndex} = FuzzySampEnt_TRIG(currData(isnan(currData(:,v))==0,v),TypeName{pType},pM,tmpR,pP,pCentering);
                                                    testRunTime=[testRunTime;toc];
                                                    yIndex=yIndex+1;
                                                end                                                
                                            end                                           
                                        end                                    
                                    end
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                %format shortEng
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end





                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                        elseif(selData(STATISTIC_INDEX_TEST.RCmDE)==1)


                            try

                                cd('../com/ExternalPackages/DataShare')
                                m = str2double(app.editRCMDE_M.Value);
                                tau = str2double(app.editRCMDE_Tau.Value);
                                c = str2double(app.editRCMDE_NoC.Value);
                                scale = str2double(app.editRCMDE_Scale.Value);

                                m1 = str2double(app.editRCMDE_M_T1.Value);
                                tau1 = str2double(app.editRCMDE_Tau_T1.Value);
                                c1 = str2double(app.editRCMDE_NoC_T1.Value);
                                scale1 = str2double(app.editRCMDE_Scale_T1.Value);

                                if ((tau1 > tau) + (c1 > c) + (m1 > m)+(scale1 > scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end


                                 if (m1 < m) || (tau1 < tau) ||  (c1 < c) || (scale1 < scale)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                 end




                                yIndex =1;
                                for pC=c:paramIncrement:c1

                                    for pM=m:paramIncrement:m1
                                        for pTau=tau:paramIncrement:tau1


                                            tic
                                            %%Out_RCMDE=RCMDE(x,m,c,tau,Scale)
                                            %
                                            tmpVal = [RCMDE(currData(isnan(currData(:,v))==0,v)',pM,pC,pTau,scale1)];
                                            testRunTime=[testRunTime;toc];
                                            for pScale=scale:paramIncrement:scale1
                                                resultCol{xIndex,yIndex}=tmpVal(1,pScale);
                                                yIndex=yIndex+1;
                                            end
                                        end
                                    end                                   
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                        elseif(selData(STATISTIC_INDEX_TEST.RCmFE_SD)==1)

                            try

                                cd('../com/ExternalPackages/DataShare')
                                m = str2double(app.editRCMFEstdM.Value);
                                tau = str2double(app.editRCMFEstdTau.Value);
                                r = str2double(app.editRCMFEstdR.Value);
                                scale = str2double(app.editRCMFEstdScale.Value);
                                % n: fuzzy power (it is usually equal to 2)
                                n=str2double(app.editRCMFEstdN.Value);

                                m1 = str2double(app.editRCMFEstdM_T1.Value);
                                tau1 = str2double(app.editRCMFEstdTau_T1.Value);
                                r1 = str2double(app.editRCMFEstdR_T1.Value);
                                scale1 = str2double(app.editRCMFEstdScale_T1.Value);
                                % n: fuzzy power (it is usually equal to 2)
                                n1=str2double(app.editRCMFEstdN_T1.Value);

                                
                                if ((tau1 > tau) + (m1 > m) + (r1 > r)+(n1 > n)+(scale1>scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (m1 < m) || (tau1 < tau) ||  (r1 < r) || (scale1 < scale) || (n1 < n)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                                end



                                yIndex =1;
                                for pN=n:paramIncrement:n1
                                    for pR=r:paramIncrement:r1
                                        for pM=m:paramIncrement:m1
                                            for pTau=tau:paramIncrement:tau1
                                                tic

                                                tmpVal = [RCMFE_std(currData(isnan(currData(:,v))==0,v)',pM, pR*nanstd(currData(:,v)),pN,pTau,scale1)];
                                                testRunTime=[testRunTime;toc];
                                                for pScale=scale:paramIncrement:scale1
                                                    resultCol{xIndex,yIndex}=tmpVal(1,pScale);
                                                    yIndex=yIndex+1;                                                   
                                                end                                              
                                            end                                           
                                        end                                       
                                    end                                   
                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end





                        elseif(selData(STATISTIC_INDEX.KolmogorovSmirnovTest)==1)

                            alpha = str2double(app.editKSLevelOfSig.Value);
                            if alpha <=0 || alpha >=1
                                alpha = 0.05;
                                app.editKSLevelOfSig.Value = '0.05';
                            end

                            alpha1 = str2double(app.editKSLevelOfSig_T1.Value);
                            if alpha1 <0 || alpha1 >1
                                alpha1 = 0.05;
                                app.editKSLevelOfSig_T1.Value = '0.05';
                            end

                            if (alpha1 < alpha) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                            end






                            yIndex =1;
                            for pAlpha=alpha:paramIncrement:alpha1

                                tic
                                resultCol{xIndex,yIndex} = kstest(currData(isnan(currData(:,v))==0,v),'alpha',pAlpha);
                                testRunTime=[testRunTime;toc];
                                yIndex=yIndex+1;                                
                            end

                            try
                                isError=false;
                                throwME(aa);

                            catch

                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end

                            %% autocovernce

                        elseif(selData(STATISTIC_INDEX.AutoCovariance)==1)
                            cd('../com/algorithms');
                            lagK = str2double(app.editAutoCovLagK.Value);
                            lagK1 = str2double(app.editAutoCovLagK_T1.Value);

                            if (lagK1 < lagK) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                            end






                            yIndex =1;
                            for plagK=lagK:paramIncrement:lagK1


                                tic
                                resultCol{xIndex,yIndex} = getAutoCov(currData(isnan(currData(:,v))==0,v),plagK);

                                testRunTime=[testRunTime;toc];

                                yIndex=yIndex+1;
                            end


                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end

                        elseif(selData(STATISTIC_INDEX_TEST.MovingWindowTest)==1)
                            cd('../com/ExternalPackages/ECheynet-stationaryTests-af2a370/');

                            windowLength= str2double(app.editMWindowM.Value);
                            threshold1=str2double(app.editMWindowT1.Value);
                            threshold2=str2double(app.editMWindowT2.Value);


                            windowLength1= str2double(app.editMWindowM_T1.Value);
                            threshold11=str2double(app.editMWindowT1_T1.Value);
                            threshold21=str2double(app.editMWindowT2_T1.Value);




                            if ((windowLength1 > windowLength) + (threshold11 > threshold1) + (threshold21 > threshold2)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                            end

                            if (windowLength1 < windowLength) || (threshold11 < threshold1) || (threshold21 < threshold2)
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                            end




                            yIndex =1;
                            for pWindowLength=windowLength:paramIncrement:windowLength1
                                for pThreshold1=threshold1:paramIncrement:threshold11
                                    for pThreshold2=threshold2:paramIncrement:threshold21




                                        %MW_test(u,windowLength,threshold1,threshold2)
                                        tic
                                        resultCol{xIndex,yIndex}=MW_test(currData(isnan(currData(:,v))==0,v)',pWindowLength,pThreshold1,pThreshold2);

                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                    end
                                end
                            end
                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.PhaseEntropy_PhEn)==1)
                            cd('../com/algorithms');
                            lagK   =str2double(app.editPhEnK.Value);
                            lagK1 = str2double(app.editPhEnK_T1.Value);



                            if (lagK1 < lagK) 
                                    msgbox('Invalid Range.... '); 
                                    close(f);
                                    return
                            end

                            yIndex =1;
                            for plagK=lagK:paramIncrement:lagK1


                                tic
                                resultCol{xIndex,yIndex} = getPhEntropyV1_Corrected(currData(isnan(currData(:,v))==0,v),plagK);

                                testRunTime=[testRunTime;toc];
                                yIndex=yIndex+1;
                               
                            end


                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../scripts');
                                if isError & app.chkDebugMode.Value
                                    rethrow(e);
                                elseif  isError

                                    getReport(e);

                                end
                            end



                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%  Entropy Hub

                            %% attention Entroy


                        elseif(selData(STATISTIC_INDEX.Attention_AttnEn)==1)
                            cd('../com/ExternalPackages/EntropyHub');
                            lagK = str2double(app.editAttnE_Logx.Value);
                            lagK1 = str2double(app.editAttnE_Logx_T1.Value);

                            if (lagK1 < lagK) 
                                    msgbox('Invalid Range.... ');
                                    close(f);
                                    return
                            end



                            yIndex =1;
                            for plagK=lagK:paramIncrement:lagK1


                                tic
                                resultCol{xIndex,yIndex} = AttnEn(currData(isnan(currData(:,v))==0,v),'Logx',plagK);

                                testRunTime=[testRunTime;toc];
                                yIndex=yIndex+1;

                            end


                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                            %% cosinENtropy






                        elseif(selData(STATISTIC_INDEX_TEST.CosineSimilarity_CoSiEn)==1)

                            try

                                cd('../com/ExternalPackages/EntropyHub')

                                m = str2double(app.editCosiEN_M.Value);
                                tau = str2double(app.editCosiEN_Tau.Value);
                                r = str2double(app.editCosiEN_R.Value);
                                logx=str2double(app.editCosiEN_Logx.Value);

                                m1 = str2double(app.editCosiEN_M_T1.Value);
                                tau1 = str2double(app.editCosiEN_Tau_T1.Value);
                                r1 = str2double(app.editCosiEN_R_T1.Value);
                                logx1 = str2double(app.editCosiEN_Logx_T1.Value);
                               

                                if ((tau1 > tau) + (m1 > m) + (r1 > r)+(logx1 > logx)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (logx1 < logx) || (m1 < m) || (r1 < r) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end






                                yIndex =1;
                                for pLogx=logx:paramIncrement:logx1
                                    for pR=r:paramIncrement:r1
                                        for pM=m:paramIncrement:m1
                                            for pTau=tau:paramIncrement:tau1

                                                tic
                                                rVal = pR*std(currData(:,v));
                                                resultCol{xIndex,yIndex} = CoSiEn(currData(isnan(currData(:,v))==0,v),'m',pM,'tau',pTau,'r',rVal,'Logx',pLogx);
                                                testRunTime=[testRunTime;toc];
                                                yIndex=yIndex+1;
                                            end
                                        end
                                    end                             
                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                            %%% grid



                        elseif(selData(STATISTIC_INDEX_TEST.GriddedDistEn_GDistEn)==1)

                            try

                                cd('../com/ExternalPackages/EntropyHub')

                                m = str2double(app.editGridEN_M.Value);
                                tau = str2double(app.editGridEN_Tau.Value);
                                logx=str2double(app.editGridEN_Logx.Value);


                                m1 = str2double(app.editGridEN_M_T1.Value);
                                tau1 = str2double(app.editGridEN_Tau_T1.Value);
                                logx1=str2double(app.editGridEN_Logx_T1.Value);

                               



                                  if ((tau1 > tau) + (m1 > m) +(logx1 > logx)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end

                                if (logx1 < logx) || (m1 < m) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end





                                yIndex =1;
                                for pLogx=logx:paramIncrement:logx1
                                    for pM=m:paramIncrement:m1
                                        for pTau=tau:paramIncrement:tau1

                                            tic
                                            resultCol{xIndex,yIndex} = GridEn(currData(isnan(currData(:,v))==0,v),'m',pM,'tau',pTau,'Logx',pLogx)';
                                            testRunTime=[testRunTime;toc];
                                            yIndex=yIndex+1;
                                        end                                        
                                    end                                 
                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                            %% increment


                        elseif(selData(STATISTIC_INDEX_TEST.IncrementEntropy_IncrEn)==1)

                            try

                                cd('../com/ExternalPackages/EntropyHub')

                                m=str2double(app.editIncrEN_M.Value);
                                tau=str2double(app.editIncrEN_Tau.Value);
                                r=str2double(app.editIncrEN_R.Value);
                                logx=str2double(app.editIncrEN_Logx.Value);


                                m1=str2double(app.editIncrEN_M_T1.Value);
                                tau1=str2double(app.editIncrEN_Tau_T1.Value);
                                r1=str2double(app.editIncrEN_R_T1.Value);
                                logx1=str2double(app.editIncrEN_Logx_T1.Value);

                                if ((tau1 > tau) + (m1 > m) +(logx1 > logx)+(r1 > r)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (logx1 < logx) || (m1 < m) || (r1 < r) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end







                                % n: fuzzy power (it is usually equal to 2)



                                %% using the pe defined in datasehare
                                %% mulitdimension check
                                %% using loop
                                %% here pe(currData,m,t) return single value for muldimension as well ???




                                %nRange = ceil(((m1-m+tau1-tau+scale1-scale+r1-r+n1-n)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pLogx=logx:paramIncrement:logx1

                                    for pR=r:paramIncrement:r1

                                        for pM=m:paramIncrement:m1
                                            for pTau=tau:paramIncrement:tau1


                                                tic

                                                resultCol{xIndex,yIndex} = IncrEn(currData(isnan(currData(:,v))==0,v),'m',pM,'tau',pTau,'R',pR,'Logx',pLogx)';


                                                testRunTime=[testRunTime;toc];
                                                yIndex=yIndex+1;                                              
                                            end                                         
                                        end                                        
                                    end                                
                                end


                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                        elseif(selData(STATISTIC_INDEX_TEST.MultiscalePhEn_mPhEn)==1)
                            cd('../com/ExternalPackages/Ashis');
                            lagK   =str2double(app.editMPhEnK.Value);
                            lagK1 = str2double(app.editMPhEnK_T1.Value);

                            scale   =str2double(app.editMPhEnScale.Value);
                            scale1 = str2double(app.editMPhEnScale_T1.Value);

                            if ((lagK1 > lagK) + (scale1 > scale)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                            end

                            if (lagK1 < lagK) || (scale1 < scale)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end



                            yIndex =1;
                            for plagK=lagK:paramIncrement:lagK1
                                for pScale = scale:paramIncrement:scale1
                                    tic
                                    resultCol{xIndex,yIndex} = getMS_PhEntropy_CGData(currData(isnan(currData(:,v))==0,v),plagK,pScale);

                                    testRunTime=[testRunTime;toc];
                                    yIndex=yIndex+1;
                                end
                            end

                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




                        elseif(selData(STATISTIC_INDEX_TEST.ComplexCorrelation_CCM)==1)
                            cd('../com/ExternalPackages/DavidCornforth_HRV');
                            lagK   =str2double(app.editCCM_Lag.Value);
                            lagK1 = str2double(app.editCCM_Lag_T1.Value);

                            if (lagK1 < lagK)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end


                            yIndex =1;
                            for plagK=lagK:paramIncrement:lagK1


                                tic
                                [~,~,resultCol{xIndex,yIndex}] = djcCCM(currData(isnan(currData(:,v))==0,v),plagK);
                                testRunTime=[testRunTime;toc];
                                yIndex=yIndex+1;

                            end

                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                        elseif(selData(STATISTIC_INDEX_TEST.RenyiEntropy_RE )==1)
                            cd('../com/ExternalPackages/entropy');
                            q=str2double(app.editREntropyQ.Value);
                            q1=str2double(app.editREntropyQ_T1.Value);


                            if (q1 < q)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end

                            yIndex =1;
                            for pQ=q:paramIncrement:q1


                                tic
                                try
                                    resultCol{xIndex,yIndex}=renyi_entro(currData(isnan(currData(:,v))==0,v),pQ);
                                catch
                                    x=1;
                                end
                                %disp([xIndex yIndex])
                                testRunTime=[testRunTime;toc];


                                yIndex=yIndex+1;

                            end
                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end



                        elseif(selData(STATISTIC_INDEX_TEST.TsallisEntropy_TE )==1)
                            cd('../com/ExternalPackages/entropy');
                            tic
                            q=str2double(app.editTEntropyQ.Value);
                            q1=str2double(app.editTEntropyQ_T1.Value);


                            if (q1 < q)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end


                            yIndex =1;
                            for pQ=q:paramIncrement:q1


                                tic
                                resultCol{xIndex,yIndex}=Tsallis_entro(currData(isnan(currData(:,v))==0,v),pQ);
                                testRunTime=[testRunTime;toc];
                                %disp([xIndex yIndex])


                                yIndex=yIndex+1;

                            end
                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end






                        elseif(selData(STATISTIC_INDEX_TEST.BubbleEntropy_BE)==1)
                            cd('../com/algorithms/bubbleEntropy');
                            m = str2double(app.editBubbleEnM.Value);
                            m1 = str2double(app.editBubbleEnM_T1.Value);

                            if (m1 < m) 
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end




                            yIndex =1;
                            for pM=m:paramIncrement:m1


                                tic
                                resultCol{xIndex,yIndex}=getBubbleEn(currData(isnan(currData(:,v))==0,v)',pM, false);
                                testRunTime=[testRunTime;toc];
                                %disp([xIndex yIndex])

                              
                                yIndex=yIndex+1;
                                

                            end


                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.DFA)==1)

                            cd('../com/ExternalPackages/DFA')
                            m =  str2double(app.editDFAEmbededDim.Value);
                            k =  str2double(app.editDFAOrder.Value);



                            m1 =  str2double(app.editDFAEmbededDim_T1.Value);
                            k1 =  str2double(app.editDFAOrder_T1.Value);

                            if ((k1 > k) + (m1 > m)) > 1
                                msgbox('Please choose only one range in parameters')
                                return;
                            end

                            if (m1 < m) || (k1 < k)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                            end







                            %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                            %nRange = ceil(((m1-m+k1-k)/paramIncrement))+1;

                            %resultCol = nan(nPlots,nRange);


                            yIndex=1;
                            for pM=m:paramIncrement:m1
                                for pK=k:paramIncrement:k1
                                    tic
                                    [A,~] = DFA_fun(currData(isnan(currData(:,v))==0,v),pM,pK);

                                    resultCol{xIndex,yIndex}=A(1);
                                    testRunTime=[testRunTime;toc];
                                    yIndex=yIndex+1;
                                end
                            end

                            try
                                isError=false;
                                throwME(aa);

                            catch
                                cd('../../../scripts');
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                        elseif(selData(STATISTIC_INDEX_TEST.RQA)==1)

                            try
                                cd('../com/ExternalPackages/RecurrencePlot_ToolBox');
                                %%linepara=str2num(app.editRQA_M.Value);
                                %%linepara1=str2num(app.editRQA_M_T1.Value);
                                m=str2num(app.editRQA_M.Value);
                                tau=str2num(app.editRQA_Tau.Value);
                                r=str2double(app.editRQA_R.Value);
                                minLine=str2num(app.editRQA_Minline.Value);

                                m1=str2num(app.editRQA_M_T1.Value);
                                tau1=str2num(app.editRQA_Tau_T1.Value);
                                r1=str2double(app.editRQA_R_T1.Value);
                                minLine1=str2num(app.editRQA_Minline_T1.Value);



                                if ((tau1 > tau) + (m1 > m) + (r1 > r)+(minLine1 > minLine)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (minLine1 < minLine) || (m1 < m) || (r1 < r) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end






                                outputIndex = find(strcmp(app.pMenuRQAOutput.Items,app.pMenuRQAOutput.Value)) ;
                                yIndex =1;
                                yInfo = strcat("RQA Statistic:-  ",app.pMenuRQAOutput.Value);
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1
                                        for pR=r:paramIncrement:r1
                                            for pMinLine=minLine:paramIncrement:minLine1

                                                tic

                                                outputs = getRecurrentStatitic(currData(:,v),pM,pTau,pR*nanstd(currData(:,v)),pMinLine);
                                                resultCol{xIndex,yIndex}=outputs(outputIndex);
                                                testRunTime=[testRunTime;toc];
                                                yIndex=yIndex+1;

                                            end
                                        end
                                    end
                                end



                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end





                        elseif(selData(STATISTIC_INDEX_TEST.LargestLyapunovExp_LLE)==1)

                            try

                                m=str2num(app.editLLE_M.Value);
                                tau=str2double(app.editLLE_Tau.Value);
                                meanperiod=str2double(app.editLLE_MeanPeriod.Value);
                                maxiter=str2double(app.editLLE_Maxiter.Value);


                                m1=str2num(app.editLLE_M_T1.Value);
                                tau1=str2num(app.editLLE_Tau_T1.Value);
                                meanperiod1=str2double(app.editLLE_MeanPeriod_T1.Value);
                                maxiter1=str2double(app.editLLE_Maxiter_T1.Value);

                                paramDiff = (m1>m)+(tau1>tau)+(maxiter1>maxiter)+(meanperiod1 > meanperiod);

                                if paramDiff>1
                                    msgbox('Please enter only range of one parameter');
                                    return
                                end

                                 if (maxiter1 < maxiter) || (m1 < m) || (meanperiod1 < meanperiod) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                 end


                                cd('../com/ExternalPackages/LLE_WithRosensteinAlgo_Mirwais');
                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pTau=tau:paramIncrement:tau1
                                        for pMeanPeriod=meanperiod:paramIncrement:meanperiod1


                                            tic

                                            allResults =lyarosenstein(currData(isnan(currData(:,v))==0,v),pM,pTau,pMeanPeriod,maxiter1);
                                            for kk = maxiter:maxiter1
                                                resultCol{xIndex,yIndex}=allResults(kk);
                                                yIndex = yIndex+1;
                                            end
                                            testRunTime=[testRunTime;toc];
                                        end
                                    end
                                end



                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.ExtendedPoincare_EPP)==1)

                            try

                                k =  str2double(app.editEPPLag.Value);
                                k1 = str2double(app.editEPPLag_T1.Value);

                                 if (k1 < k) 
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end





                                %                             if diffParam >1
                                %                                 msgbox('Please provide the range in only one parameter ');
                                %                                 close(f)
                                %                                 return
                                %                             else
                                %                             if (diffCases+(k1>1)) > 1 && STATISTIC_INDEX.isTimeSeriesMeasure(selIndex)
                                %                                 msgbox('This is time series data so choose only one range');
                                %                                 close(f)
                                %                                 return
                                %                             end
                                cd('../com/ExternalPackages/ExtendedPoincarePlot_ReemSatti');
                                yIndex =1;
                                % for pK=k:paramIncrement:k1

                                tic
                                [r{xIndex,1},P{xIndex,1},SD1{xIndex,1},SD2{xIndex,1}] = extPoinc(currData(isnan(currData(:,v))==0,v),k1);
                                testRunTime=[testRunTime;toc];



                                %    end



                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                            %%%%%%%%%%%%%%%%%%%%%%%









                        elseif(selData(STATISTIC_INDEX_TEST.Multiscale_LZC)==1)

                            try
                                cd('../com/ExternalPackages/LZC');
                                strScals=app.editMLZCScal.Value;
                                strScals=strsplit(strScals,',');
                                scals=[];
                                try

                                    for ii=1:size(strScals,2)
                                        scals=[scals  str2num(strScals{ii})];
                                    end
                                catch
                                    msgbox('Invalid Input');
                                    app.editMLZCScal.Value = '1,3,5';
                                    scals=[1 3 5];
                                end
                                scals=sort(scals);


                                tic
                                tmpResult = getMultiscaleLZ(currData(~isnan(currData(:,v)),v),scals) ;
                                testRunTime=[testRunTime;toc];
                                for yIndex=1:size(tmpResult,2)
                                    resultCol{xIndex,yIndex}=tmpResult(1,yIndex);
                                end



                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end


                        elseif(selData(STATISTIC_INDEX_TEST.FalseNearestNeighbours_FNN)==1)

                            try
                                cd('../com/ExternalPackages/RecurrencePlot_ToolBox')
                                mindim=str2double(app.editFracFNN_MinDim.Value);                              
                                tau=str2double(app.editFracFNN_Tau.Value);
                                rt=str2double(app.editFracFNN_Rt.Value);

                                maxdim=str2double(app.editFracFNN_MaxDim.Value);
                                tau1=str2double(app.editFracFNN_Tau.Value);
                                rt1=str2double(app.editFracFNN_Rt.Value);



                                if ((tau1 > tau) + (maxdim > mindim) + (rt1 > rt)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                 if (tau1 < tau) || (maxdim < mindim) || (rt1 < rt)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                  end





                               


                                yIndex =1;
                                for pDim=mindim:paramIncrement:maxdim

                                    for pTau=tau:paramIncrement:tau1
                                        for pRT=rt:paramIncrement:rt1





                                            % tmpR=pR*nanstd(currData(:,v))
                                            tic

                                            amiVal= false_nearest(currData(isnan(currData(:,v))==0,v)',pDim,pTau,pRT);
                                            resultCol{xIndex,yIndex} =amiVal(1);
                                            %%approx_entropy('window length','similarity measure','data set')


                                            %resultCol{xIndex,yIndex}=getapprox_entropy(m,r,currData(isnan(currData(:,v))==0,v)')

                                            %disp([xIndex yIndex])
                                            testRunTime=[testRunTime;toc];
                                            yIndex=yIndex+1;




                                            
                                        end

                                       

                                       

                                    end


                                end

                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end




                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  distribution


                        elseif(selData(STATISTIC_INDEX_TEST.DistributionEntropy_DistEn)==1)

                            try
                                cd('../com/ExternalPackages/DistEn')


                                m = str2double(app.editDE_M.Value);
                                tau=str2double(app.editDE_Tau.Value);
                                B =str2num(app.editDE_B.Value);



                                m1 = str2double(app.editDE_M_T1.Value);
                                tau1=str2double(app.editDE_Tau_T1.Value);
                                B1  = str2num(app.editDE_B_T1.Value);



                                if ((tau1 > tau) + (m1 > m) + (B1 > B)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                  end
                                
                                if (m1 < m) || (tau1 < tau) || (B1 < B)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end




                                yIndex =1;
                                for pM=m:paramIncrement:m1

                                    for pTau=tau:paramIncrement:tau1
                                        for pB=B:paramIncrement:B1





                                            % tmpR=pR*nanstd(currData(:,v))
                                            tic

                                            resultCol{xIndex,yIndex} = disten(currData(isnan(currData(:,v))==0,v), pM, pTau, pB);
                                            yIndex = yIndex+1;
                                            testRunTime=[testRunTime;toc];

                                        end
                                    end
                                end

                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end







                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                            %% autocorrelation


                        elseif(selData(STATISTIC_INDEX_TEST.AutoCorrelation)==1)

                            try


                                numLags =  str2double(app.editAutoCorrNumLags.Value);
                                if numLags > (size(currData,1)-1)
                                    numLags = size(currData,1)-1;
                                    app.editAutoCorrNumLags.Value=numLags;
                                end

                                numLags1 =  str2double(app.editAutoCorrNumLags_T1.Value);

                               if (numLags1 < numLags) 
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end
                                cd('../com/ExternalPackages/acf');
                                tic

                                % for i=1:size(currData,2)
                                %tmpVal(:,i) = autocorr(currData(isnan(currData(:,i))==0,i),'NumLags',numLags,'NumSTD',numSTD);
                                % end
                                %% working
                                %tmpAns =    autocorr(currData(isnan(currData(:,v))==0,v),'NumLags',numLags,'NumSTD',numSTD);
                                tmpAns = acf(currData(isnan(currData(:,v))==0,v),numLags1);
                                for ii=numLags:numLags1
                                    resultCol{xIndex,ii-numLags+1} = tmpAns(ii,1);

                                end

                               
                                testRunTime=[testRunTime;toc];
                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back

                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end

                            cd('../../../scripts')





                        elseif(selData(STATISTIC_INDEX_TEST.ApEn)==1)

                            try

                                cd('../com/ExternalPackages/Entropy_measures')
                                m =  str2double(app.editApEnM.Value);
                                r=str2double(app.editApEnR.Value);



                                m1 =  str2double(app.editApEnM_T1.Value);
                                r1=str2double(app.editApEnR_T1.Value);

                                if ((m1 > m) + (r1 > r)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (r1 < r) || (m1 < m)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end



                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pR=r:paramIncrement:r1
                                        tic
                                        tmpR=pR*nanstd(currData(:,v));
                                        resultCol{xIndex,yIndex} =    ApEn(currData(isnan(currData(:,v))==0,v),pM,tmpR);                                        
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;
                                       
                                    end                                 
                                end
                                isError=false;
                                throwME(aa);
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value
                                    rethrow(e);
                                elseif  isError
                                    getReport(e);

                                end
                            end


                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                        elseif(selData(STATISTIC_INDEX_TEST.ApEn_LightWeight)==1)

                            try

                                cd('../com/ExternalPackages/Manish_ApproxEn')
                                m =  str2double(app.editApLWEnM.Value);
                                r=str2double(app.editApLWEnR.Value);



                                m1 =  str2double(app.editApLWEnM_T1.Value);
                                r1=str2double(app.editApLWEnR_T1.Value);

                                if ( (m1 > m) + (r1 > r)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                 if (r1 < r) || (m1 < m)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                  end


                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pR=r:paramIncrement:r1
                                        tic
                                        tmpR=pR*nanstd(currData(:,v));
                                        resultCol{xIndex,yIndex} =    Approximate_entropy_lightweight_win(currData(isnan(currData(:,v))==0,v),pM,tmpR);
                                       
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;                                       
                                    end                         
                                end
                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end






                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                        elseif(selData(STATISTIC_INDEX_TEST.AutoMutualInformation_AMI)==1)

                            try

                                cd('../com/ExternalPackages/RecurrencePlot_ToolBox')
                                partitions=str2num(app.editMI_Partitions.Value);
                                tau=str2double(app.editMI_TMax.Value);



                                partitions1=str2num(app.editMI_Partitions_T1.Value);
                                tau1=str2double(app.editMI_TMax_T1.Value);

                                



                                if ( (partitions1 > partitions) + (tau1 > tau)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                 if (partitions1 < partitions) || (tau1 < tau)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                 end


                                %nPlots = ceil(toFile-fromFile+toEpoch-fromEpoch+fromScale-toScale+fromDimension-toDimension+1);
                                %nRange = ceil(((m1-m+r1-r)/paramIncrement))+1;

                                %resultCol = nan(nPlots,nRange);


                                yIndex =1;
                                for pPartitions=partitions:paramIncrement:partitions1
                                    for pTau=tau:paramIncrement:tau1
                                        tic
                                        tmpAns=mutual(currData(isnan(currData(:,v))==0,v),pPartitions,pTau);
                                        
                                        resultCol{xIndex,yIndex} =    tmpAns(end);
                                       
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;                                       
                                    end                         
                                end
                                isError=false;
                                throwME(aa);


                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end









                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




                        elseif(selData(STATISTIC_INDEX_TEST.ConditionalEntropy_CE)==1)

                            try
                                cd('../com/ExternalPackages/Entropy_measures')

                                m =  str2double(app.editCE_M.Value);
                                numInt=str2double(app.editCE_NumInt.Value);



                                m1 =  str2double(app.editCE_M_T1.Value);
                                numInt1=str2double(app.editCE_NumInt_T1.Value);


                                if ((numInt1 > numInt) + (m1 > m)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                end

                                if (m1 < m) || (numInt1 < numInt)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                end



                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pNumInt=numInt:paramIncrement:numInt1

                                        tic
                                        %CondEn(series,L,numInt)
                                        resultCol{xIndex,yIndex} =    CondEn(currData(isnan(currData(:,v))==0,v)',pM,pNumInt);
                                       
                                        testRunTime=[testRunTime;toc];

                                        yIndex=yIndex+1;
                                        
                                    end                               
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct


                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end












                        elseif(selData(STATISTIC_INDEX_TEST.CorrectedConditionalEntropy_CCE)==1)

                            try
                                cd('../com/ExternalPackages/Entropy_measures')

                                m =  str2double(app.editCorrectedCE_M.Value);
                                numInt=str2double(app.editCorrectedCE_NumInt.Value);



                                m1 =  str2double(app.editCorrectedCE_M_T1.Value);
                                numInt1=str2double(app.editCorrectedCE_NumInt_T1.Value);

                                 if ((numInt1 > numInt) + (m1 > m)) > 1
                                    msgbox('Please choose only one range in parameters')
                                    return;
                                 end

                                 if (m1 < m) || (numInt1 < numInt)
                                    msgbox('Invalid Range.... '); close(f);
                                    return
                                 end








                                yIndex =1;
                                for pM=m:paramIncrement:m1
                                    for pNumInt=numInt:paramIncrement:numInt1
                                        %CondEn(series,L,numInt)
                                        tic
                                        resultCol{xIndex,yIndex} =    CorrecCondEn(currData(isnan(currData(:,v))==0,v)',pM,pNumInt);


                                        %disp([xIndex yIndex])
                                        testRunTime=[testRunTime;toc];
                                        yIndex=yIndex+1;                                        
                                    end                                
                                end

                                isError = false;
                                throwME(MException("Go To Finally","Finally"));
                            catch e %e is an MException struct

                                % more error handling...

                                %% moving back
                                cd('../../../scripts')
                                if isError & app.chkDebugMode.Value

                                    rethrow(e);


                                elseif  isError

                                    getReport(e);

                                end
                            end














                            %% if selected measurement
                        end



                        xIndex = xIndex+1;
                        %
                        %                         if toEpoch > fromEpoch
                        %                             xIndex=xIndex+1;
                        %                         end

                        FileName=FileNameList{fIndex};
                        progressTxt = strcat(num2str(fIndex),'/',FileName);

                        try
                            f = waitbar(currRunCount/totalCount,f,progressTxt,'Name','Processing statistic calculation .....');
                        catch
                            f = waitbar(currRunCount/totalCount,progressTxt);
                        end



                    end

                    %                     if toDimension>fromDimension
                    %                         xIndex = xIndex+1;
                    %                     end
                end
                %                 if toFile>fromFile
                %                     xIndex=xIndex+1;
                %                     currRunCount=currRunCount+1;
                %                 end
                currRunCount=currRunCount+1;

            end

            close(f);

            %% when no range xIndex will be only 1 so make it two

            try
                %                 if toFile==fromFile & fromEpoch==toEpoch & fromDimension==toDimension & scale1==scale
                %                     xIndex=2;
                %                 end

            catch %% if scale is not defined
                %                 if toFile==fromFile & fromEpoch==toEpoch & fromDimension==toDimension
                %                     xIndex=2;
                %                 end
            end


            if ~isempty(testRunTime)
                app.txtInfoProcessing.Text = strcat('Computation Time (s) :',num2str(mean(testRunTime)));
            else
                app.txtInfoProcessing.Text = strcat('Computation Time (s) :XXXXXXXX');
            end




            %%change 3
            xRange=[];
            yRange=[];
            tColumnNames={};
            plotName={};
            if selData(STATISTIC_INDEX_TEST.SampEn_DS)==1
                yInfo = "Sample Entropy(Datashare)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Lag (Tau)";
                    tColumnNames= strcat('Tau-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Threshold (r)";
                    tColumnNames= strcat('r-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.SampEn_Richman)==1
                yInfo = "Sample Entropy(Richmond)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Threshold (r)";
                    tColumnNames= strcat('r-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.Permutation_JS_Complexity_PJSC )==1
                yInfo = "Permutation JS Complexity(PJSC)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.AutoMutualInformation_AMI )==1
                yInfo = "Auto Mutual Information (AMI)";
                if partitions1>partitions
                    xRange = partitions:paramIncrement:partitions1
                    xInfo = "Bin Size(B)";
                    tColumnNames= strcat('B-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Delay";
                    tColumnNames= strcat('d-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.TsallisPE_TPE)==1
                yInfo = "Tsallis Permutation Entropy(TPE)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif k1>k
                    xRange = k:paramIncrement:k1;
                    xInfo = "Tsallis Order(k)";
                    tColumnNames= strcat('k-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.RenyiPE_RPE)==1
                yInfo = "Renyi Permutation Entropy(TPE)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif k1>k
                    xRange = k:paramIncrement:k1;
                    xInfo = "Renyi Order(k)";
                    tColumnNames= strcat('k-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.Edge_PE)==1
                yInfo = "Edge Permutation Entropy(Edge_PE)";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif t1>t
                    xRange = t:paramIncrement:t1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Sensitivity(s)";
                    tColumnNames= strcat('s-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.CosEn_And_QSE)==1
                yInfo = "Coeff Sample Entropy�";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Lag (Tau)";
                    tColumnNames= strcat('Tau-',string(xRange));
                elseif cosR1>cosR
                    xRange = cosR:paramIncrement:cosR1;
                    xInfo = "Coeff Sample Entropy Threshold(cosR)";
                    tColumnNames= strcat('cosR-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.mSE)==1
                yInfo = "Multiscale Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Pattern Length(m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Radius Of Similarity(r)";
                    tColumnNames= strcat('R-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Maximum No. of Coarse-grainings (Tau)";
                    tColumnNames= strcat('Tau-',string(xRange));

                end

            elseif selData(STATISTIC_INDEX_TEST.DistributionEntropy_DistEn)==1
                yInfo = "Distribution Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif B1>B
                    xRange = B:paramIncrement:B1;
                    xInfo = "Bin Number";
                    tColumnNames= strcat('BN-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay(Tau)";
                    tColumnNames= strcat('Tau-',string(xRange));

                end

            elseif   selData(STATISTIC_INDEX_TEST.Higuchi_FD)==1
                yInfo = "Higuchi FD";
                if kMax1>kMax
                    xRange = kMax:paramIncrement:kMax1
                    xInfo = "kMax";
                    tColumnNames= strcat('kMax-',string(xRange));
                end

            elseif   selData(STATISTIC_INDEX_TEST.AlanFactor_AF)==1
                yInfo = "Alan Factor AF";
                if nWindow1>nWindow
                    xRange = nWindow:paramIncrement:nWindow1
                    xInfo = "nWindow";
                    tColumnNames= strcat('nWindow-',string(xRange));
                end
            elseif selData(STATISTIC_INDEX_TEST.ImPE)==1
                yInfo = "ImPE";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Order (m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif t1>t
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = t:paramIncrement:t1;
                    xInfo = "Time Delay (t)";
                    tColumnNames= strcat('t-',string(xRange));
                elseif scale1>scale
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('scale-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.MultiscalePE_mPE)==1
                yInfo = "Mulitscale PE";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif t1>t
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = t:paramIncrement:t1;
                    xInfo = "Time Lag (tau)";
                    tColumnNames= strcat('t-',string(xRange));
                elseif scale1>scale
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('scale-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.ShapiroWilkTest)==1
                
                yInfo = strcat("SW Test - ",app.pMenuSW_Measures.Value);
                xInfo = "alpha";
                xRange = [alpha:paramIncrement:alpha1];
                tColumnNames=strcat('alpha-',string(xRange));



            elseif selData(STATISTIC_INDEX_TEST.KolmogorovSmirnovTest)==1
                yInfo = "Kolmogorov Smironov Test";
                xInfo = "Level of Significance";
                xRange = [alpha:paramIncrement:alpha1];
                tColumnNames=strcat('alpha-',string(xRange));


            elseif selData(STATISTIC_INDEX_TEST.AvgApEn_Profile)==1
                yInfo = "Average Approximation Entropy Profile";
                xInfo = "Embedding Dimension (m)";
                xRange = [m:paramIncrement:m1];
                tColumnNames=strcat('m-',string(xRange));


            elseif selData(STATISTIC_INDEX_TEST.AvgSampEn_Profile)==1
                yInfo = "Average Sample Entropy Profile";
                xInfo = "Embedding Dimension (m)";
                xRange = [m:paramIncrement:m1];
                tColumnNames=strcat('m-',string(xRange));

            elseif selData(STATISTIC_INDEX_TEST.ReverseA_Test)==1
                yInfo = "Reverse Arrangement Test";
                xInfo = "Methods";
                xRange = [method:paramIncrement:method1];
                tColumnNames=strcat('M-',string(xRange));



                %% autocoveriance

            elseif(selData(STATISTIC_INDEX_TEST.AutoCovariance)==1)
                yInfo = "Auto Covariance";
                xInfo = "Time Lag";
                xRange = [lagK:paramIncrement:lagK1];
                tColumnNames=strcat('tLag-',string(xRange));

            elseif(selData(STATISTIC_INDEX_TEST.PhaseEntropy_PhEn)==1)
                yInfo = "Phase Entropy";
                xInfo = "Number of Sector";
                xRange = [lagK:paramIncrement:lagK1];
                tColumnNames=strcat('nSector-',string(xRange));


            elseif(selData(STATISTIC_INDEX_TEST.ComplexCorrelation_CCM)==1)
                yInfo = "CCM";
                xInfo = "Lag";
                xRange = [lagK:paramIncrement:lagK1];
                tColumnNames=strcat('Lag-',string(xRange));


            elseif selData(STATISTIC_INDEX_TEST.AutoCorrelation)==1
                yInfo = "Autocorrelation";
                xRange = numLags:numLags1;
                xInfo = "Num Lags";
                tColumnNames= strcat('#lag-',string(xRange));


            elseif selData(STATISTIC_INDEX_TEST.MovingWindowTest)==1
                yInfo = "Moving Window";
                if windowLength1>windowLength
                    xRange = windowLength:paramIncrement:windowLength1
                    xInfo = "Window Length";
                    tColumnNames= strcat('WL-',string(xRange));
                elseif threshold11>threshold1
                    xRange = threshold1:paramIncrement:threshold11
                    xInfo = "Threshold 1";
                    tColumnNames= strcat('r1--',string(xRange));
                elseif threshold21>threshold2
                    xRange =threshold2:paramIncrement:threshold21
                    xInfo = "Threshold 2";
                    tColumnNames= strcat('t2-',string(xRange));
                end


            elseif   selData(STATISTIC_INDEX_TEST.RenyiEntropy_RE)==1
                yInfo = "Renyi Entropy";
                if q1>q
                    xRange = q:paramIncrement:q1
                    xInfo = "q";
                    tColumnNames= strcat('q-',string(xRange));
                end



            elseif   selData(STATISTIC_INDEX_TEST.TsallisEntropy_TE)==1
                yInfo = "Tsallis Entropy";
                if q1>q
                    xRange = q:paramIncrement:q1
                    xInfo = "q";
                    tColumnNames= strcat('q-',string(xRange));
                end



            elseif   selData(STATISTIC_INDEX_TEST.BubbleEntropy_BE)==1
                yInfo = "Bubble Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('m-',string(xRange));
                end




                % elseif   selData(STATISTIC_INDEX_TEST.EmbeddingDimension)==1
                %     yInfo = "Embedding Dimension";
                %     if m1>m
                %         xRange = m:paramIncrement:m1
                %         xInfo = "m";
                %         tColumnNames= strcat('m-',string(xRange));
                %     end
                %
                % elseif   selData(STATISTIC_INDEX_TEST.FirstCriterionNN)==1
                %     yInfo = "First CriterionNN";
                %     if m1>m
                %         xRange = m:paramIncrement:m1
                %         xInfo = "m";
                %         tColumnNames= strcat('m-',string(xRange));
                %     end


                % elseif   selData(STATISTIC_INDEX_TEST.SecondCriterionNN)==1
                %     yInfo = " Second CriterionNN";
                %     if m1>m
                %         xRange = m:paramIncrement:m1
                %         xInfo = "m";
                %         tColumnNames= strcat('m-',string(xRange));
                %     end

            elseif selData(STATISTIC_INDEX_TEST.CorrDim_D2)==1
                yInfo = "Correlation Dimension_D2";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif tau1>tau
                    xRange =tau:paramIncrement:tau1;
                    xInfo = "Time Lag(Tau)";
                    tColumnNames= strcat('Tau',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.DFA)==1
                yInfo = "DFA";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif k1>k
                    xRange = k:paramIncrement:k1;
                    xInfo = "Order (k)";
                    tColumnNames= strcat('K-',string(xRange));
                end



                %%Harikala................


            elseif selData(STATISTIC_INDEX_TEST.LargestLyapunovExp_LLE)==1
                yInfo = "Largest Lyapunov Exponent ";
                if (m1>m) || (tau1>tau) ||(meanperiod1>meanperiod) ||(maxiter1>maxiter)
                    if m1>m
                        xRange = m:paramIncrement:m1

                        xInfo = "Embedding Dimension (m)";
                        tColumnNames= strcat('m-',string(xRange));
                        % tColumnNames= strcat('m-',string(xRange));
                    elseif tau1>tau
                        %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                        xRange = tau:paramIncrement:tau1;
                        xInfo = "tau";
                        tColumnNames= strcat('tau-',string(xRange));
                        %tColumnNames= strcat('Tau-',string(xRange));
                    elseif meanperiod1>meanperiod
                        xRange = meanperiod:paramIncrement:meanperiod1;
                        xInfo = "MP";
                        tColumnNames= strcat('meanP-',string(xRange));
                        %tColumnNames= strcat('MP',string(xRange));
                    elseif maxiter1>maxiter
                        xRange = maxiter:paramIncrement:maxiter1;
                       
                        %tColumnNames= strcat('maxiter',string(xRange));

                        xRange = maxiter:paramIncrement:maxiter1;
                        xInfo = "maxiter";
                        tColumnNames= strcat('maxiter-',string(xRange));



                    end

                    


                else
                  yInfo = 'LLE';
                  %plotName = strcat(yInfo,'-',string(plotRange));
                end
                    
                
                
                %plotName = strcat('I-',string(xRange));

%                 xInfo = "Iteration";
% 
%                 tmpResultCol={};
%                 xRange=1:size(resultCol{1,1},2);
%                 tColumnNames= strcat('I-',string(xRange));
%                 for ii=1:size(resultCol,1)
%                     tmpval= resultCol{ii,1}
%                     for j=1:size(tmpval,2)
%                         tmpResultCol{ii,j}=tmpval(1,j);
%                     end
%                 end
%                 x=1;
%                 resultCol=tmpResultCol



            elseif selData(STATISTIC_INDEX_TEST.RQA)==1
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "threshold (r)";
                    tColumnNames= strcat('r-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "time delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif minLine1>minLine
                    xRange = minLine:paramIncrement:minLine1;
                    xInfo = "minimal limit of vert and Horzt line pattern";
                    tColumnNames= strcat('minLine-',string(xRange));
                end

                %xRange=[linepara:paramIncrement:linepara1];
                outputsName ={ 'REC (%)','DET (%)', 'Lmax', 'ENT', 'LAM' ,'TT'};
                yInfo = outputsName{1,outputIndex};
                xInfo="RQA Statatistic ";
                % tColumnNames= strcat('linepara-',string(xRange));
                %[r{xIndex},P{xIndex}, SD1{xIndex}, SD2{xIndex}]



            elseif selData(STATISTIC_INDEX_TEST.ExtendedPoincare_EPP)==1
                %resultCol={};
                if find(strcmp(app.pMenuEEPOutput.Items,app.pMenuEEPOutput.Value)) ==1
                    yInfo = "Pearson's Correlation Coefficient(r)";
                    paramVal = r;

                elseif find(strcmp(app.pMenuEEPOutput.Items,app.pMenuEEPOutput.Value))  ==2
                    yInfo = "P Value of r (P)";
                    paramVal = P;
                elseif find(strcmp(app.pMenuEEPOutput.Items,app.pMenuEEPOutput.Value)) ==3
                    yInfo = "Standard Deviation 1 (SD1)";
                    paramVal = SD1;
                else
                    yInfo = "Standard Deviation 2(SD2)";
                    paramVal = SD2;
                end
                xRange=k:k1;
                xInfo = "maximum steps/lags (k)";
                tColumnNames= strcat('k-',string(xRange));
                %[r{xIndex},P{xIndex}, SD1{xIndex}, SD2{xIndex}]

                for ii=1:size(paramVal,1)
                    tmpVal = paramVal{ii,1};
                    for j=1:size(tmpVal,1)
                        resultCol{ii,j}=tmpVal(j,1);
                    end
                end


            elseif selData(STATISTIC_INDEX_TEST.Multiscale_LZC)==1


                yInfo = "Multiscale LZC";

                xRange=scals;

                xInfo = "scal";
                tColumnNames= strcat('scal-',string(scals))
                %[r{xIndex},P{xIndex}, SD1{xIndex}, SD2{xIndex}]



            elseif selData(STATISTIC_INDEX_TEST.ApEn)==1
                yInfo = "Approximate Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Similarity Measure (r)";
                    tColumnNames= strcat('R-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.Continious_CS)==1
                yInfo = "Continuous Complexity Measures ";
                if minValue1>minValue
                    xRange = minValue:paramIncrement:minValue1
                    xInfo = "Min Value";
                    tColumnNames= strcat('minV-',string(xRange));
                elseif maxValue1>maxValue
                    xRange = maxValue:paramIncrement:maxValue1
                    xInfo = "Max Value";
                    tColumnNames= strcat('maxV-',string(xRange));
                elseif distSS1>distSS
                    xRange = maxValue:paramIncrement:maxValue1
                    xInfo = "Dist Sample Size";
                    tColumnNames= strcat('dss-',string(xRange));

                end

            elseif selData(STATISTIC_INDEX_TEST.ConditionalEntropy_CE)==1
                yInfo = "Conditional Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif numInt1>numInt
                    xRange = numInt:paramIncrement:numInt1;
                    xInfo = "Number of Uniform Intervals (numInt)";
                    tColumnNames= strcat('NumInt-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.ShannonEntropy_SE)==1
                yInfo = "Shannon Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif numInt1>numInt
                    xRange = numInt:paramIncrement:numInt1;
                    xInfo = "Number of Uniform Intervals (numInt)";
                    tColumnNames= strcat('NumInt-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.ToneEntropy_T_E)==1
                if outputIndex==1
                    yInfo = "Tone Entropy (entropy)";
                else
                    yInfo = "Tone Entropy (tone)";
                end
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Time Lag (tau)";
                    tColumnNames= strcat('tau-',string(xRange));

                end

                %%work01



                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                %%%  Shannon Extrony
            elseif selData(STATISTIC_INDEX_TEST.ShannonExtropy_SEx)==1
                yInfo = "Shannon Extropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding D(m) ";
                    tColumnNames= strcat('m-',string(xRange));
                elseif numInt1>numInt
                    xRange = numInt:paramIncrement:numInt1
                    xInfo = "Num Int";
                    tColumnNames= strcat('nInt-',string(xRange));


                end

                %% HRM

            elseif selData(STATISTIC_INDEX_TEST.HRA_PI_GI_AI_SI)==1
                yInfo = app.pMenuHRM.Value;
                if tau1>tau
                    xRange = tau:paramIncrement:tau1
                    xInfo = "Tau ";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif methodID==1
                    xRange =1:4;
                    xInfo = "Methods";
                    tColumnNames = ["PI" "GI" "SI" "AI"];

                end


                %%app.pMenuFDNldwan.Value

            elseif selData(STATISTIC_INDEX_TEST.FD_nldwan)==1
                yInfo = strcat("Nldwan ","(",app.pMenuFDNldwan.Value,")");
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Moving Window Length ";
                    tColumnNames= strcat('minV-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1
                    xInfo = "Moving Window Steps";
                    tColumnNames= strcat('maxV-',string(xRange));


                end


            elseif selData(STATISTIC_INDEX_TEST.FD_nldian)==1
                yInfo = strcat("Nldian ","(",app.pMenuFDNldian.Value,")");
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Moving Window Length ";
                    tColumnNames= strcat('minV-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1
                    xInfo = "Moving Window Steps";
                    tColumnNames= strcat('maxV-',string(xRange));


                end


            elseif selData(STATISTIC_INDEX_TEST.mFD_Maragos)==1
                yInfo = "mFD Maragos ";
                if window1>window
                    xRange = window:paramIncrement:window1;
                    xInfo = "window ";
                    tColumnNames= strcat('w-',string(xRange));
                elseif scale1>scale
                   % xRange = scale:paramIncrement:scale1
                   xRange = window:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('s-',string(xRange));


                end





                %%%%%%%%%%%%%%%%%


                %            elseif selData(STATISTIC_INDEX_TEST.ImPE)==1
                %                 yInfo = "Amplitude Aware Permutation Entropy";
                %                 if a1>a
                %                     xRange = a:paramIncrement:a1
                %                     xInfo = "adjusting coefficient(A)";
                %                     tColumnNames= strcat('max-',string(xRange));
                %                 elseif t1>t
                %                     %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                %                     xRange = t:paramIncrement:t1;
                %                     xInfo = "time delay of AAPE";
                %                     tColumnNames= strcat('tau-',string(xRange));
                %                 elseif m1>m
                %                     xRange = m:paramIncrement:m1;
                %                     xInfo = "order of AAPE";
                %                     tColumnNames= strcat('m-',string(xRange));
                %
                %                 end




            elseif selData(STATISTIC_INDEX_TEST.CPEI_olofsen)==1

                yInfo = "CPEI olofsen";

                if epz1>epz
                    xRange = epz:paramIncrement:epz1
                    xInfo = "epz";
                    tColumnNames= strcat('epz-',string(xRange));

                end






            elseif selData(STATISTIC_INDEX_TEST.EntropyOfDifference_EoD)==1
                yInfo = "Entropy of Difference";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif shift1>shift
                    xRange = shift:paramIncrement:shift1;
                    xInfo = "Shift(s)";
                    tColumnNames= strcat('shift-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.KullbachLeiblerDivergence_KLD)==1
                yInfo = "Kullbach Leibler Divergence";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif shift1>shift
                    xRange = shift:paramIncrement:shift1;
                    xInfo = "Shift by Number (shift)";
                    tColumnNames= strcat('shift-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.CorrectedConditionalEntropy_CCE)==1
                yInfo = "Corrected Condition En";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('M-',string(xRange));
                elseif numInt1>numInt
                    xRange = numInt:paramIncrement:numInt1;
                    xInfo = "Number of Uniform Intervals (numInt)";
                    tColumnNames= strcat('NumInt-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.AmplitudeAware_PE)==1
                yInfo = "Amplitude Aware Permutation Entropy";
                if a1>a
                    xRange = a:paramIncrement:a1
                    xInfo = "adjusting coefficient(A)";
                    tColumnNames= strcat('max-',string(xRange));
                elseif t1>t
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = t:paramIncrement:t1;
                    xInfo = "time delay of AAPE";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "order of AAPE";
                    tColumnNames= strcat('m-',string(xRange));

                end



                %% M_PME
            elseif selData(STATISTIC_INDEX_TEST.mPM_E)==1
                yInfo = "Multiscale Permutation Min-Entropy";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif t1>t
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = t:paramIncrement:t1;
                    xInfo = "Time Delay (t)";
                    tColumnNames= strcat('t-',string(xRange));
                    %                 elseif scale1>scale
                    %                     xRange = scale:paramIncrement:scale1;
                    %                     xInfo = "Scale";
                    %                     tColumnNames= strcat('scale-',string(xRange));
                end


            elseif selData(STATISTIC_INDEX_TEST.MultiscalePhEn_mPhEn)==1
                yInfo = "Multiscale Phase Entropy";
                if lagK1>lagK
                    xRange = lagK:paramIncrement:lagK1;
                    xInfo = "Lag (k)";
                    tColumnNames= strcat('k-',string(xRange));
                elseif scale1>scale
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale (s)";
                    tColumnNames= strcat('s-',string(xRange));
                    %                 elseif scale1>scale
                    %                     xRange = scale:paramIncrement:scale1;
                    %                     xInfo = "Scale";
                    %                     tColumnNames= strcat('scale-',string(xRange));
                end






            elseif selData(STATISTIC_INDEX_TEST.RCmSE_SD)==1
                yInfo = "RCMSE SIGMA";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension (m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif tau1>tau
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Delay Time (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif scale1>scale
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('scale-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "r * std";
                    tColumnNames= strcat('r-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.AverageEntropy_AE)==1
                yInfo = "Average Entropy";
                if pMax1>pMax
                    xRange = pMax:paramIncrement:pMax1
                    xInfo = "self-setting max value(max)";
                    tColumnNames= strcat('max-',string(xRange));
                elseif pMin1>pMin
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = pMin:paramIncrement:pMin1;
                    xInfo = "self-setting min value (min)";
                    tColumnNames= strcat('min-',string(xRange));
                elseif bins1>bins
                    xRange = bins:paramIncrement:bins1;
                    xInfo = "range between min to max";
                    tColumnNames= strcat('bins-',string(xRange));
                elseif pScale1>pScale
                    xRange = pScale:paramIncrement:pScale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('pScale-',string(xRange));
                end






            elseif selData(STATISTIC_INDEX_TEST.Entropy_of_Entropy_EoE)==1
                yInfo = "Entropy Of Entropy";
                if pMax1>pMax
                    xRange = pMax:paramIncrement:pMax1
                    xInfo = "self-setting max value(max)";
                    tColumnNames= strcat('max-',string(xRange));
                elseif pMin1>pMin
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = pMin:paramIncrement:pMin1;
                    xInfo = "self-setting min value (min)";
                    tColumnNames= strcat('min-',string(xRange));
                elseif bins1>bins
                    xRange = bins:paramIncrement:bins1;
                    xInfo = "range between min to max";
                    tColumnNames= strcat('bins-',string(xRange));
                elseif pScale1>pScale
                    xRange = pScale:paramIncrement:pScale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('pScale-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.RCmFE_SD)==1
                yInfo = "RCMFE SIGMA";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif tau1>tau
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Delay Time (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif scale1>scale
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('scale-',string(xRange));
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "r * std";
                    tColumnNames= strcat('r-',string(xRange));
                elseif n1>n
                    xRange = n:paramIncrement:n1;
                    xInfo = "Fuzzy Power ";
                    tColumnNames= strcat('n-',string(xRange));
                end



            elseif selData(STATISTIC_INDEX_TEST.RCmDE)==1
                yInfo = "RCMDE ";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif tau1>tau
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Delay Time (tau)";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif scale1>scale
                    xRange = scale:paramIncrement:scale1;
                    xInfo = "Scale";
                    tColumnNames= strcat('scale-',string(xRange));
                elseif c1>c
                    xRange = c:paramIncrement:c1;
                    xInfo = "Number of Classes";
                    tColumnNames= strcat('c-',string(xRange));
                end

            elseif selData(STATISTIC_INDEX_TEST.SlopeEntropy_SlopeEn)==1
                yInfo = "Slope Entropy ";
                if m1>m
                    xRange = m:paramIncrement:m1
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif gamma1>gamma
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = gamma:paramIncrement:gamma1;
                    xInfo = "Gamma";
                    tColumnNames= strcat('g-',string(xRange));
                elseif delta1>delta
                    xRange = delta:paramIncrement:delta1;
                    xInfo = "Delta";
                    tColumnNames= strcat('d-',string(xRange));
                end




            elseif selData(STATISTIC_INDEX_TEST.FuzzyEntropy_FE)==1
                yInfo = "Fuzzy Entropy ";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif mf1>mf
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = mf:paramIncrement:mf1;
                    xInfo = "Membership Function";
                    tColumnNames= strcat('mf-',string(xRange));
                elseif t1>t
                    xRange = t:paramIncrement:t1;
                    xInfo = "Threshold r & Order n";
                    tColumnNames= strcat('t-',string(xRange));

                elseif local1>local
                    xRange = local:paramIncrement:local1;
                    xInfo = "Local";
                    tColumnNames= strcat('l-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay";
                    tColumnNames= strcat('tau-',string(xRange));

                end






            elseif selData(STATISTIC_INDEX_TEST.FuzzyEntropy_CAFE)==1
                yInfo = "Fuzzy Entropy CAFE";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));
                elseif centering1>centering
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;

                    xInfo = "Pattern";
                    tColumnNames= ["non-centering","centering"];
                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "amplitude of the tolerance r";
                    tColumnNames= strcat('r-',string(xRange));

                elseif type1>type
                    xRange = type:paramIncrement:type1;
                    xInfo = "Isometry Type";
                    tColumnNames= ["Translation","Vertical R","Inversion","Glide R"];
                elseif p1>p
                    xRange = p:paramIncrement:p1;
                    xInfo = "Power(Membership Fun.)";
                    tColumnNames= strcat('p-',string(xRange));

                end


                %%%%b entropy hub







                %%Cosin
            elseif selData(STATISTIC_INDEX_TEST.CosineSimilarity_CoSiEn)==1
                yInfo = "Cosine Similarity Entropy (CoSi)";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));

                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Angular Threshold (r)*std";
                    tColumnNames= strcat('r-',string(xRange));

                elseif logx1>logx
                    xRange = logx:paramIncrement:logx1;
                    xInfo = "Logarithm base (logx)";
                    tColumnNames= strcat('log-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));

                end


                %%Grid
            elseif selData(STATISTIC_INDEX_TEST.GriddedDistEn_GDistEn)==1
                yInfo = "Gridded distribution entropy (GridEn)";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));



                elseif logx1>logx
                    xRange = logx:paramIncrement:logx1;
                    xInfo = "Logarithm base (logx)";
                    tColumnNames= strcat('log-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));

                end


                %%Incr
            elseif selData(STATISTIC_INDEX_TEST.IncrementEntropy_IncrEn)==1
                yInfo = "Increment entropy (Incr)";
                if m1>m
                    xRange = m:paramIncrement:m1;
                    xInfo = "Embedding Dimension(m)";
                    tColumnNames= strcat('m-',string(xRange));

                elseif r1>r
                    xRange = r:paramIncrement:r1;
                    xInfo = "Quantifying resolution (R)";
                    tColumnNames= strcat('R-',string(xRange));

                elseif logx1>logx
                    xRange = logx:paramIncrement:logx1;
                    xInfo = "Logarithm base (logx)";
                    tColumnNames= strcat('log-',string(xRange));
                elseif tau1>tau
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay (tau)";
                    tColumnNames= strcat('tau-',string(xRange));

                end







            elseif selData(STATISTIC_INDEX_TEST.FalseNearestNeighbours_FNN)==1
                yInfo = "fraction of false nearest neighbors ";
                if maxdim> mindim
                    xRange = mindim:paramIncrement:maxdim;
                    xInfo = "Dimension of delay(dim)";
                    tColumnNames= strcat('dim-',string(xRange));
                elseif tau1>tau
                    %xRange = tau:paramIncrement:nRange*paramIncrement+tau;
                    xRange = tau:paramIncrement:tau1;
                    xInfo = "Time Delay";
                    tColumnNames= strcat('tau-',string(xRange));
                elseif rt1>rt
                    xRange = rt:paramIncrement:rt1;
                    xInfo = "Ratio Factor";
                    tColumnNames= strcat('rt-',string(xRange));

                end
            end







            %%defining legand

            myLegend={};
            if ~isempty(plotName)
                myLegend=plotName;
                tabularData=[cellstr(plotName') resultCol];
                %elseif fromFile<toFile
            elseif size(fileList,2)>1
                %yRange=[fromFile :toFile];
                yRange = fileList;
                %  myLegend= FileNameList(fromFile:toFile) ;%strcat('File ',string(yRange));
                myLegend = FileNameList(fileList);
                %tabularData = [FileNameList(fromFile:toFile) resultCol];
               
                tabularData = [FileNameList(fileList) resultCol];
                tColumnNames=['' tColumnNames];
            elseif size(allEpochList,2)>1

                yRange=allEpoch;
                myLegend=strcat('Epoch ',string(yRange(1,1:size(resultCol,1))));
                tabularData = cellstr([myLegend' resultCol]);
                tColumnNames=['' tColumnNames];
                %elseif fromDimension<toDimension
            elseif size(columnList ,2)> 1
                %yRange=[fromDimension :toDimension];
                yRange = columnList;
                myLegend=strcat('Dimension ',string(yRange(1,1:size(resultCol,1))));
                try
                    tabularData = cellstr([myLegend' resultCol]);
                catch
                    tabularData= cellstr([myLegend' cell2mat(resultCol)]);
                end
                tColumnNames=['' tColumnNames];
            else
                tabularData=resultCol;
            end

            tInfo={};
            for ii=1:size(tabularData,1)
                for j=1:size(tabularData,2)
                    tInfo{ii,j}=tabularData(ii,j);
                end
            end
            x=1

            displayResult=cell2mat(resultCol);
            %% set the first panel (hidden ) in display

            app.TabGroupTestParameters.SelectedTab=app.TabGroupTestParameters.Children(1);

            % app.TabGroupMiddle.SelectedTab=app.TabGroupMiddle.Children(1);
            %             global fig3
            %             try
            %                 %% close if exist
            %                 close(fig3);
            %             catch
            %             end
            %fig3 = figure(3);
            % hold(fig3)
            %% adjustment of xRange based on displayResult
            %xRange=xRange(:,1:size(displayResult,2));
            %myColorList={};
            %% in case xRange is empty, means parameters range is same, so display along the file, epoch or dimension or scale range...



            app.axisNoEvent.Visible=true;
            cla(app.axisNoEvent)
            if    size(displayResult,1)>1 && size(displayResult,2)>1

                %fig = uifigure;
                %app.axisNoEvent=app.uiaxis(fig,'XLabel',xInfo,'YLabel',yInfo);
                try
                    app.axisNoEvent.XLabel.String=xInfo;
                catch
                end
                try
                    app.axisNoEvent.YLabel.String =yInfo;
                catch
                end
                hold(app.axisNoEvent,'on')
                for k=1:size(displayResult,1)

                    %h1=plot(xRange,displayResult(k,:),'--o');
                    try
                        plot(app.axisNoEvent,xRange,displayResult(k,:),'--o');
                    catch
                        plot(app.axisNoEvent,displayResult(k,:),'--o');
                    end
                    hold(app.axisNoEvent,'on');
                    % myColorList=get(h1, 'Color');
                end
                legend( app.axisNoEvent,myLegend );
                % app.axisNoEvent.Legend=myLegend;
            elseif  size(displayResult,2)>1


                try
                    plot(app.axisNoEvent,xRange,displayResult,'--o');
                catch
                    plot(app.axisNoEvent,displayResult,'--o');
                end
                %h1=plot(xRange,displayResult,'--o');
                % myColorList=get(h1, 'Color');

                %                 xlabel(xInfo);
                %                 ylabel(yInfo);
                %                 legend(myLegend);
                try
                    app.axisNoEvent.XLabel.String=xInfo;
                catch
                end
                try
                    app.axisNoEvent.YLabel.String =yInfo;
                catch
                end
                legend( app.axisNoEvent,myLegend );
                %app.axisNoEvent.Legend=myLegend;

            elseif size(displayResult,1)>1
                %plot(displayResult,'--o');
                xRange = yRange;
                plot(app.axisNoEvent,displayResult,'--o');
                %ylabel(yInfo);
                app.axisNoEvent.YLabel.String =yInfo;

                if size(fileList,2)>1
                    %if toFile > fromFile
                    %xlabel("File Number");
                    app.axisNoEvent.XLabel.String="File Number";
                elseif size(allEpochList,2)>1
                    %elseif toEpoch >fromEpoch
                    %xlabel("Epoch Number");
                    app.axisNoEvent.XLabel.String="Epoch Number";
                elseif size(dimensionList,2)>1
                    %elseif toDimension>fromDimension
                    %xlabel("Dimension Number")
                    app.axisNoEvent.XLabel.String="Dimension Number";
                end
                legend( app.axisNoEvent,myLegend );
            else
                %plot(displayResult,'X')
                plot(app.axisNoEvent,displayResult,'X');
                %ylabel(yInfo);
                try
                    app.axisNoEvent.YLabel.String =yInfo;
                catch
                end
                legend( app.axisNoEvent,myLegend );
            end

            % for k=1:size(displayResult,1)
            %     h1=plot(xRange,displayResult(k,:),'*','color',myColorList{k})
            %
            % end


            %fig4=figure(4);
            %  f=uipanel();
            %hTable = uitable(,'Data',displayResult,'ColumnName',tColumnNames);
            try
                app.tableNoEvent.Data = tabularData;
            catch
                app.tableNoEvent.Data = cell2mat(tabularData);
            end
            try
                app.tableNoEvent.ColumnName=tColumnNames;
            catch
            end

            %                 hTableExtent = get(hTable,'Extent');
            %                 hTablePosition = get(hTable,'Position');
            %                 set(hTable,'position',[10 10 round(hTableExtent(3)) round(hTableExtent(4))]);
            %                 set(fig4,'position',[5 5 round(hTableExtent(3)) round(hTableExtent(4))]);

            app.tableNoEvent.Visible=true;
            flagOK = true;

        end



    end

end

