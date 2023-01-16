classdef UTIL_RUN_PIPELINE
    %UTIL_RUN_PIPELINE Summary of this class goes here
    %   Detailed explanation goes here



    methods(Static)
        function runPipeline(app)
            % hObject    handle to pbRunExperiment (see GCBO)
            % eventdata  reserved - to be defined in a future version of MATLAB
            % handles    structure with handles and user data (see GUIDATA)
            global f
            global ALL_StatisticCol
            global ALL_ScaleHeadingCol
            global epochList
            global PreprocessedDataSet
            %global fileNameList
            %epochList=[];
            %%get directory file
            %dbDirectoryPath=app.editDataDir.Value;
            %% all constrants are stored in com/constants folder
            addpath('../com/Constants');

            global FileNameList

            %% read sample rate, epoch time(in second) ,data frame start time and timing unit (second/
            SAMPLING_RATE = str2double(app.editSampleR.Value);
            EPOCH_TIME_IN_SECOND =  str2double(app.editEpochT.Value);
            %START_TIME_IND_SECOND =  str2double(app.editStartT.Value);
            %MAX_DATA_LENGTH_SECOND = str2double(app.editMaxLength.Value);
            %TOTAL_OBSEVATION_TIME_SECOND =  str2double(app.editTObservationT.Value);




            %%STATISTIC_INDEX contains all the statistic properties we are going to measure
            %% StatisticCol contains STATISTIC_INDEX.PropertyList
            %%create the meta.class object using the ? operator with the class name
            mc = ?STATISTIC_INDEX;

            %% total number of statitistics we going to calculate
            totalNumStatistics = size(mc.PropertyList,1);
            %% load all of the data files from the data directory



            %allExt = app.pMenuDbFileExtension.Value;
            %selectedIndex = app.pMenuDbFileExtension.Value ;
            %selExt = char(strtrim(allExt(selectedIndex,:)));
            %dbFilesCols  = dir(strcat(dbDirectoryPath,'/*.',selExt));


            %% get selected statistic
            %chkSelMeasures = app.uitableSMeasures.Data;
            %selData = cell2mat(chkSelMeasures(:,2));

            selData = UTIL_GUI.getStatisticSelData(app);
            %dbFilesCols=dir(strcat(dbDirectoryPath,'\*.',app.editDbFileExtension.Value););
            %% start index points to first data entity in the data file

            %% for each data files apply the statistical calculation
            ALL_StatisticCol={};
            ALL_ScaleHeadingCol={};
            f= waitbar(0,'0','Name','Processing statistic calculation .....');
            epochList=cell(size(FileNameList,1),1);


            strMessage={};
            epochWidth = SAMPLING_RATE*EPOCH_TIME_IN_SECOND;
            msgCount=1;
            for fIndex=1:size(PreprocessedDataSet,1)
                data=PreprocessedDataSet{fIndex,1};
                %%define epoch for file
                if app.chkSingleData.Value ==1
                    epochWidth=size(data,1);
                    epochList{fIndex,1}=1;

                elseif app.chkAllEpoch.Value==1
                    epochList{fIndex,1}=1:floor(size(data,1)/epochWidth);
                elseif app.chkSelEpoch.Value==1
                    eList = UTIL_GUI.getIdListFromString(app.editSelEpochList.Value);
                    maxLimit = floor(size(data,1)/epochWidth);
                    if max(eList)>maxLimit
                        strMessage{msgCount}=strcat('Maximum Number of epoch in file: ',FileNameList{fIndex},' can be :',num2str(maxLimit));
                        msgCount=msgCount+1;
                    end
                    epochList{fIndex,1}=sort(find(eList<=maxLimit));
                end
            end

            if ~isempty(strMessage)
                msgbox(strMessage);
            end



            %for fIndex  = 1:size(dbFilesCols,1)
            for fIndex=1:size(PreprocessedDataSet,1)
                FileName=FileNameList{fIndex};
                progressTxt = strcat(num2str(fIndex),'/',FileName);

                try
                    f = waitbar(fIndex/size(FileNameList,1),f,progressTxt,'Name','Processing statistic calculation .....');
                catch
                    f = waitbar(0.1,progressTxt);
                end
                %change1 30/05/2020
                %sample rate is input from user
                %% all batch process have same sample rate.
                %SAMPLING_RATE = getSamplingRate(dbFilesCols(fIndex).name);
                %startIndex = (START_TIME_IND_SECOND-1)*SAMPLING_RATE+1;
                %% width of the epoch is the sampling rate times epoch time in second.

                % epochWidth = SAMPLING_RATE*EPOCH_TIME_IN_SECOND;


                %data=loadData(handles,dbFilesCols,dbDirectoryPath,fIndex)  ;
                data=PreprocessedDataSet{fIndex,1};
                %data = truncateDataBeyondRange(handles,data,MAX_DATA_LENGTH_SECOND,SAMPLING_RATE);
                %startIndex=1;
                %                 if app.chkSingleData.Value ==1
                %                     epochWidth=size(data,1);
                %                     epochList{fIndex,1}=1;
                %                 elseif app.chkAllEpoch.Value==1
                %                     epochList{fIndex,1}=1:floor(size(data,1)/epochWidth);
                %                 elseif app.chkSelEpoch.Value==1
                %                    epochList{fIndex,1}=UTIL_GUI.getIdListFromString(app.editSelEpochList)
                %                 end



                %[~,FileName,~]=fileparts(dbFilesCols(fIndex).name);

                %%Check there


                N = size(data,1);

                %[data,OutlierInfo] = removeOutliersAllData(handles,data);

                %totalEpoch = floor(N /epochWidth);
                totalEpoch = size(epochList{fIndex,1},2);

                %   UTIL_GUI.setEpochList(app,data,epochWidth,fIndex);


                currIndex=1;
                %kMaxHiguchiFD=nan(totalEpoch,size(data,2));
                StatisticCol = cell(totalEpoch,totalNumStatistics);
                ComputationTime=cell(totalEpoch,totalNumStatistics);


                FastLombCol=cell(totalEpoch,1);
                FFTCol=cell(totalEpoch,1);
                SpectralEntropyCol=cell(totalEpoch,1);
                %NonLinearityGLCCol=cell(totalEpoch,1);
                for epochID = epochList{fIndex,1}



                    %strInfo = strcat('File # ',num2str(fIndex),' / ', FileName,'  Epoch # ',num2str(epochID),' / ',num2str(totalEpoch),' in progress ....');

                    currSIndex = (epochID-1)*epochWidth+1;

                    try
                        endIndex = min(currSIndex+epochWidth-1,size(data,1));
                        currData = data(currSIndex:endIndex,:);
                    catch

                        msgbox('Data Index out of range');
                        break
                    end

                    %epochInfo{currIndex,1}=[epochID,currSIndex,endIndex];
                    %epochInfo{currIndex,2}=currData;

                    % [OutlierInfo,data]=removeOutlierEpoch(handles,data,currData,currSIndex,endIndex,OutlierInfo);





                    if(selData(STATISTIC_INDEX.Nonlinearity_VM)==1)
                        tic

                        isError = true;
                        try



                            cd('../com/ExternalPackages/NonLinearityTest');
                            tmpResult={};
                            for v=1:size(currData,2)
                                fprintf('Working with feature %d',v);
                                outputs = getNonLinearityGLC(currData(:,v));
                                tmpResult{1,v}=outputs(:,1);
                                tmpResult{2,v}=outputs(:,2);
                                tmpResult{3,v}=outputs(:,3);
                                %                                 NonLinearityGLC{epochID,1}(:,v)=outputs(:,1);
                                %                                 NonLinearityGLC{epochID,2}(:,v)=outputs(:,2);
                                %                                 NonLinearityGLC{epochID,3}(:,v)=outputs(:,3);
                            end

                            %%??? add comment ...
                            StatisticCol{currIndex,STATISTIC_INDEX.Nonlinearity_VM*10+1}=cell2mat(tmpResult(1,:));
                            StatisticCol{currIndex,STATISTIC_INDEX.Nonlinearity_VM*10+2}=cell2mat(tmpResult(2,:));
                            StatisticCol{currIndex,STATISTIC_INDEX.Nonlinearity_VM*10+3}=cell2mat(tmpResult(3,:));

                            %nonLinearityGLC{epochID,1}(:,v)=

                            ComputationTime{currIndex,STATISTIC_INDEX.Nonlinearity_VM}=toc;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpValue
                            cd('../../../scripts')
                        end
                    end


                    if(selData(STATISTIC_INDEX.Mean)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Mean} = nanmean(currData,1);
                    end
                    %%% median
                    if(selData(STATISTIC_INDEX.Median)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Median} = nanmedian(currData,1);
                    end
                    %% mode
                    if(selData(STATISTIC_INDEX.Mode)==1)
                        %% check if max and mode is equivaluent
                        StatisticCol{currIndex,STATISTIC_INDEX.Mode} =mode(currData);
                    end
                    %% min
                    if(selData(STATISTIC_INDEX.Min)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Min} = nanmin(currData);
                    end
                    %% max
                    if(selData(STATISTIC_INDEX.Max)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Max} = nanmax(currData);
                    end
                    %%range
                    if(selData(STATISTIC_INDEX.Range)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Range} = range(currData);
                    end
                    %%Q3
                    if(selData(STATISTIC_INDEX.Q3)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Q3} = quantile(currData,0.75);
                    end
                    %% Q1
                    if(selData(STATISTIC_INDEX.Q1)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Q1} = quantile(currData,0.25);
                    end
                    %% IQR
                    if(selData(STATISTIC_INDEX.IQR)==1)
                        tic
                        StatisticCol{currIndex,STATISTIC_INDEX.IQR} = iqr(currData);
                        ComputationTime{currIndex,STATISTIC_INDEX.IQR}=toc;
                    end


                    %% SD
                    if(selData(STATISTIC_INDEX.SD)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.SD} = nanstd(currData);
                    end
                    %         %% Variance
                    %         if(selData(STATISTIC_INDEX.Variance)==1)
                    %             StatisticCol{currIndex,STATISTIC_INDEX.Variance} = nanvar(currData,1);
                    %         end

                    %% CV coefficient of variation
                    %% getCV is defined by third part
                    %%multidimension .. loop
                    if(selData(STATISTIC_INDEX.CV)==1)
                        tic
                        isError = true;
                        try



                            cd('../com/ExternalPackages');



                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                % can work with nan values
                                tmpVal(1,i)=getCV(currData(isnan(currData(:,i))==0,i));
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.CV} = tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.CV}=toc;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../scripts')
                        end

                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





                    %    Discrete_CS = 29
                    %                     function [ emergence, selfOrganization, complexity, varargout ] = ...
                    %                         DiscreteComplexityMeasures( pmfSample, varargin )



                    if(selData(STATISTIC_INDEX.Discrete_CS)==1)
                        tic
                        isError = true;




                        try
                            cd('../com/ExternalPackages/Santamaria code');

                            %SWTEST Shapiro-Wilk parametric hypothesis test of composite normality.
                            %   [H, pValue, SWstatistic] = SWTEST(X, ALPHA)
                            %% check multidimension .. loop
                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(1,i)= DiscreteComplexityMeasures(currData(isnan(currData(:,i))==0,i));
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Discrete_CS } = tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.Discrete_CS }=toc;



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



                    end

                    %%  Continious_CS = 29+1
                    %                     function [emergence, selfOrganization, complexity, varargout ] = ...
                    %                         ContinuousComplexityMeasures(pdfSample, varargin )
                    %                             minVal  = varargin{1};
                    %                             maxVal  = varargin{2};
                    %                             distSampleSize = varargin{3};


                    if(selData(STATISTIC_INDEX.Continious_CS)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Santamaria code');



                            minValue = str2double(app.editCCM_Min.Value);
                            maxValue= str2double(app.editCCM_Max.Value);
                            distSS= str2double(app.editCCM_DistSS.Value);


                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)


                                [emergency,selfOrganization,complexity,Entropy]= ContinuousComplexityMeasures(currData(isnan(currData(:,i))==0,i),minValue,maxValue,distSS);
                                results = [emergency,selfOrganization,complexity,Entropy];
                                ind = find(app.pMenuCM_Methods.Items,app.pMenuCM_Methods.Value);
                                tmpVal(1,i)= results(1,ind);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Continious_CS } = tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.Continious_CS }=toc;



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



                    end




                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                    %    RoCV
                    %    Robust CV (RoCV) = median absolute deviation from the median (MADM) / median
                    %    MADM = median (|xi?median(x)|)
                    if(selData(STATISTIC_INDEX.RoCV)==1)
                        cd('../com/algorithms');

                        tic

                        tmpVal = nan(1,size(currData,2));
                        for i=1:size(currData,2)
                            tmpVal(1,i)=getRoCV(currData(isnan(currData(:,i))==0,i));
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.RoCV} = tmpVal;

                        ComputationTime{currIndex,STATISTIC_INDEX.RoCV}=toc;
                        cd('../../scripts');
                    end

                    % not sure why this calculation was done
                    %         %    Length
                    %         if(selData(STATISTIC_INDEX.Length)==1)
                    %
                    %             StatisticCol{currIndex,STATISTIC_INDEX.Length} = ones(1,size(currData,2))*size(currData,1);
                    %         end
                    if(selData(STATISTIC_INDEX.Length)==1)
                        %%total length of data points minus sum of NaN value
                        StatisticCol{currIndex,STATISTIC_INDEX.Length}  = size(currData,1)-sum(isnan(currData),1);
                    end


                    %    Slope      ??? CHECK 1
                    if(selData(STATISTIC_INDEX.Slope)==1)

                        %% created a function getSlope based on % https://uk.mathworks.com/help/stats/robustfit.html
                        %% check if it work with multidimension data or not
                        %% loop used
                        cd('../com/algorithms');
                        RobustSlope = zeros(1,size(currData,2));
                        RobustIntercept = zeros(1,size(currData,2));
                        RegSlope = zeros(1,size(currData,2));
                        for i=1:size(currData,2)
                            [ RobustSlope(1,i),RobustIntercept(1,i),RegSlope(1,i) ] = getSlope( currData(isnan(currData(:,i))==0,i) );
                        end
                        %[ RobustSlope,RobustIntercept,RegSlope ] =  getSlope( currData);



                        StatisticCol{currIndex,STATISTIC_INDEX.Slope}=RegSlope;
                        cd('../../scripts');

                    end

                    %    Intercept   Initial value   ??? NOT COMPLETE 2
                    if(selData(STATISTIC_INDEX.Intercept)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Intercept} = currData(1,:);
                    end

                    %    Slope      ??? CHECK 1
                    % deepak
                    if(selData(STATISTIC_INDEX.RobustIntercept)==1)

                        %% created a function getSlope based on % https://uk.mathworks.com/help/stats/robustfit.html
                        %% check if it work with multidimension data or not
                        %% loop used
                        cd('../com/algorithms');
                        RobustSlope = zeros(1,size(currData,2));
                        RobustIntercept = zeros(1,size(currData,2));
                        RegSlope = zeros(1,size(currData,2));
                        for i=1:size(currData,2)
                            [ RobustSlope(1,i),RobustIntercept(1,i),RegSlope(1,i) ] = getSlope( currData(isnan(currData(:,i))==0,i) );

                        end
                        cd('../../scripts');
                        %[ RobustSlope,RobustIntercept,RegSlope ] =  getSlope( currData);



                        StatisticCol{currIndex,STATISTIC_INDEX.RobustIntercept}=RobustIntercept;


                    end

                    %    Slope      ??? CHECK 1
                    if(selData(STATISTIC_INDEX.RobustSlope)==1)

                        %% created a function getSlope based on % https://uk.mathworks.com/help/stats/robustfit.html
                        %% check if it work with multidimension data or not
                        %% loop used
                        cd('../com/algorithms');
                        RobustSlope = zeros(1,size(currData,2));
                        RobustIntercept = zeros(1,size(currData,2));
                        RegSlope = zeros(1,size(currData,2));
                        for i=1:size(currData,2)
                            [ RobustSlope(1,i),RobustIntercept(1,i),RegSlope(1,i) ] = getSlope( currData(isnan(currData(:,i))==0,i) );
                        end
                        %[ RobustSlope,RobustIntercept,RegSlope ] =  getSlope( currData);


                        StatisticCol{currIndex,STATISTIC_INDEX.RobustSlope}=RobustSlope;
                        cd('../../scripts');


                    end




                    % Skewness
                    % S = skewness(X) returns the sample skewness of the values in X
                    %% matlab inbuild function
                    tic
                    if(selData(STATISTIC_INDEX.Skewness)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Skewness} = skewness(currData);
                    end
                    ComputationTime{currIndex,STATISTIC_INDEX.Skewness}=toc;

                    %    Standard error of skewness   ??? NOT COMPLETE 1
                    %% http://www-01.ibm.com/support/docview.wss?uid=swg21481716
                    %The variance (squared standard error) of the skewness statistic is computed as:
                    %V_skew = 6*N*(N-1) / ((N-2)*(N+1)*(N+3))
                    %where N is the sample size.
                    %The variance of the kurtosis statistic is:
                    if(selData(STATISTIC_INDEX.StdErrSkewness)==1)
                        V_skew = 6*epochWidth*(epochWidth-1) / ((epochWidth-2)*(epochWidth+1)*(epochWidth+3));
                        StatisticCol{currIndex,STATISTIC_INDEX.StdErrSkewness} =ones(1,size(currData,2))*sqrt(V_skew);



                        % IsSkewness = 24
                        %''1' if Absolute ratio of Sk/SE Sk < 1.96, '0' if >= 1.96
                        % ??? chk formula not l
                        %% check how to define for multidimension

                        %StatisticCol{currIndex,STATISTIC_INDEX.IsSkewness} = StatisticCol{currIndex,STATISTIC_INDEX.StdErrSkewness} < 1.96;
                    end


                    if(selData(STATISTIC_INDEX.IsSkewness)==1)
                        V_skew = 6*epochWidth*(epochWidth-1) / ((epochWidth-2)*(epochWidth+1)*(epochWidth+3));
                        %StatisticCol{currIndex,STATISTIC_INDEX.StdErrSkewness} =ones(1,size(currData,2))*sqrt(V_skew);

                        tmpSkewness = skewness(currData);

                        tmpStdError = ones(1,size(currData,2))*sqrt(V_skew);

                        % IsSkewness = 24
                        %''1' if Absolute ratio of Sk/SE Sk < 1.96, '0' if >= 1.96
                        % ??? chk formula not l
                        %% check how to define for multidimension
                        %stdErrSkewness = ones(1,size(currData,2))*sqrt(V_skew);
                        StatisticCol{currIndex,STATISTIC_INDEX.IsSkewness} = abs(tmpSkewness./tmpStdError)<1.96;
                        %chkVal= abs(tmpSkewness/tmpStdError)<1.96
                    end



                    %    Kurtosis
                    % K = kurtosis(X) returns the sample kurtosis of the values in X
                    % matlab inbuild function
                    if(selData(STATISTIC_INDEX.Kurtosis)==1)
                        StatisticCol{currIndex,STATISTIC_INDEX.Kurtosis} = kurtosis(currData);
                    end
                    % Standard error of kurtosis
                    % %V_kur = 4*(N^2-1)*V_skew / ((N-3)*(N+5))
                    if(selData(STATISTIC_INDEX.StdErrKurtosis)==1)
                        V_skew = 6*epochWidth*(epochWidth-1) / ((epochWidth-2)*(epochWidth+1)*(epochWidth+3));

                        tmpVSkew = sqrt( 4*(epochWidth^2-1)*V_skew / ((epochWidth-3)*(epochWidth+5)));
                        StatisticCol{currIndex,STATISTIC_INDEX.StdErrKurtosis} =ones(1,size(currData,2))*tmpVSkew;

                        %% IsKurtosis

                        %StatisticCol{currIndex,STATISTIC_INDEX.IsKurtosis} = StatisticCol{currIndex,STATISTIC_INDEX.StdErrKurtosis}<1.96;
                    end



                    if(selData(STATISTIC_INDEX.IsKurtosis)==1)
                        V_skew = 6*epochWidth*(epochWidth-1) / ((epochWidth-2)*(epochWidth+1)*(epochWidth+3));
                        tmpKurtosis= kurtosis(currData);
                        tmpVSkew = sqrt( 4*(epochWidth^2-1)*V_skew / ((epochWidth-3)*(epochWidth+5)));
                        stdErrKurtosis =ones(1,size(currData,2))*tmpVSkew;

                        %% IsKurtosis

                        % StatisticCol{currIndex,STATISTIC_INDEX.IsKurtosis} = stdErrKurtosis<1.96;
                        StatisticCol{currIndex,STATISTIC_INDEX.IsKurtosis} = abs(tmpKurtosis./stdErrKurtosis)<1.96;
                    end




                    %    Kolmogorov-Smirnov test
                    % kstest Single sample Kolmogorov-Smirnov goodness-of-fit hypothesis test.
                    % using matlab inbuild function

                    if(selData(STATISTIC_INDEX.KolmogorovSmirnovTest)==1)
                        tic
                        alpha = str2double(app.editKSLevelOfSig.Value);
                        if alpha <=0 || alpha >=1
                            alpha = 0.05;
                            app.editKSLevelOfSig.Value = '0.05';
                        end
                        tmpVal = nan(1,size(currData,2));
                        for i=1:size(currData,2)
                            tmpVal(1,i)=kstest(currData(isnan(currData(:,i))==0,i),'alpha',alpha);
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.KolmogorovSmirnovTest} = tmpVal;
                        ComputationTime{currIndex,STATISTIC_INDEX.KolmogorovSmirnovTest}=toc;

                    end
                    
                    
                    
                    
                    
                    %%%%% NAI                    
                                     
                    
                    if(selData(STATISTIC_INDEX.NormalizedAsymmetricIndex_NAI)==1)
                        tic
                        try
                            cd('../com/ExternalPackages/Kalauzi_GPP');
                            minOrder = str2double(app.editNAI_minOrder.Value);
                            maxOrder = str2double(app.editNAI_maxOrder.Value);
                            steps = str2double(app.editNAI_steps.Value);
                           
                            
                            tmpVal= nan(1,size(currData,2));


                            for i=1:size(currData,2)
                                %tmpVal(1,i)=kstest(currData(isnan(currData(:,i))==0,i),'alpha',alpha);
                             
                                
                                
                                tmpVal(1,i)=getGPPAsymIndex(currData(isnan(currData(:,i))==0,i),minOrder, steps, maxOrder);
                                
                                
                                
                            end

                            % deepak
                            StatisticCol{currIndex,STATISTIC_INDEX.NormalizedAsymmetricIndex_NAI}=tmpVal;
                           



                            
                            ComputationTime{currIndex,STATISTIC_INDEX.NormalizedAsymmetricIndex_NAI}=toc;
                            
    
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


                    end

                    
                    
                    %%% FRP
                    
                    
                    
                     %%%%% NAI                    
                                     
                    
                    if(selData(STATISTIC_INDEX.FuzzyRecurrentPlot_FRP)==1)
                        tic
                        try
                            cd('../com/ExternalPackages/FRE-matlab');
                            set(0,'DefaultFigureVisible','off');
                            dim = str2double(app.editFRP_dim.Value);
                            tau = str2double(app.editFRP_tau.Value);
                            cluster = str2double(app.editFRP_cluster.Value);
                           
                            
                            tmpVal= nan(1,size(currData,2));


                            for i=1:size(currData,2)
                                %tmpVal(1,i)=kstest(currData(isnan(currData(:,i))==0,i),'alpha',alpha);
                             
                                
                               
                                tmpVal(1,i)=fuzzyEntropy_frp(currData(isnan(currData(:,i))==0,i),dim, tau, cluster);
                                
                                
                                
                            end

                            % deepak
                            StatisticCol{currIndex,STATISTIC_INDEX.FuzzyRecurrentPlot_FRP}=tmpVal;
                           



                            
                            ComputationTime{currIndex,STATISTIC_INDEX.FuzzyRecurrentPlot_FRP}=toc;
                            
    
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../../scripts')
                            set(0,'DefaultFigureVisible','on');
                        end


                    end

                    
                    
                    
                    
                    
                 
                    




              
                    if(selData(STATISTIC_INDEX.ShapiroWilkTest)==1)
                        tic
                        try
                            cd('../com/ExternalPackages/swtest');
                            alpha = str2double(app.editSW_P.Value);
                            if alpha <=0 || alpha >=1
                                alpha = 0.05;
                                app.editSW_P.Value = '0.05';
                            end
                            
                            scaleInfo='H; pValue;SWstatistic';
                            tmpVal= nan(3,size(currData,2));


                            for i=1:size(currData,2)
                                %tmpVal(1,i)=kstest(currData(isnan(currData(:,i))==0,i),'alpha',alpha);
                                [H, pValue, SWstatistic] = swtest(currData(isnan(currData(:,i))==0,i), alpha);
                                tmpVal(:,i)=[H, pValue, SWstatistic]';
                                
                            end

                            % deepak
                            StatisticCol{currIndex,STATISTIC_INDEX.ShapiroWilkTest}=tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.ShapiroWilkTest,1}=scaleInfo;



                            
                            ComputationTime{currIndex,STATISTIC_INDEX.ShapiroWilkTest}=toc;
                            
    
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


                    end



%                     %%%%%%%%%%%% HRA symmetric
% 
% 
% 
%                     if(selData(STATISTIC_INDEX.HRA_PI_GI_AI_SI)==1)
%                         tic
%                         try
%                             cd('../com/ExternalPackages/Ashis');
%                             tau   =str2double(app.editHRM_Tau.Value);
%                             
% 
%                             scaleInfo='PI; GI;SI;AI';
%                             tmpVal= nan(4,size(currData,2));
% 
% 
%                             for v=1:size(currData,2)
%                                 %tmpVal(1,i)=kstest(currData(isnan(currData(:,i))==0,i),'alpha',alpha);
%                                 hrm = hrasymm(currData(~isnan(currData(:,v)),v),tau) ;
%                                 tmpVal(:,v)=[hrm.PI, hrm.GI, hrm.SI, hrm.AI]';
%                                 
%                             end
% 
%                             % deepak
%                             StatisticCol{currIndex,STATISTIC_INDEX.HRA_PI_GI_AI_SI}=tmpVal;
%                             ALL_ScaleHeadingCol{STATISTIC_INDEX.HRA_PI_GI_AI_SI,1}=scaleInfo;
% 
% 
% 
%                             
%                             ComputationTime{currIndex,STATISTIC_INDEX.HRA_PI_GI_AI_SI}=toc;
%                             
%     
%                             isError = false;
%                             throwME(MException("Go To Finally","Finally"));
%                         catch e %e is an MException struct
%                             if isError
%                                 getReport(e)
% 
%                             end
%                             % more error handling...
% 
%                             %% moving back
%                             cd('../../../scripts')
%                         end
%                     end







                    %    Average Approximation Entropy Profile
                    if(selData(STATISTIC_INDEX.AvgApEn_Profile)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Chanda/Entropy-Codes-master/Approximate entropy');
                            m = str2double(app.editAvgApEn_Profile_M.Value);
                            %SWTEST Shapiro-Wilk parametric hypothesis test of composite normality.
                            %   [H, pValue, SWstatistic] = SWTEST(X, ALPHA)
                            %% check multidimension .. loop
                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpV= apEnProfiling(currData(isnan(currData(:,i))==0,i),m);

                                profile = tmpV(~isinf(tmpV(:,2)),2);
                                tmpVal(1,i)=nanmean(profile);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.AvgApEn_Profile} = tmpVal;
                            % back to script
                            ComputationTime{currIndex,STATISTIC_INDEX.AvgApEn_Profile}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../../../../scripts')
                        end



                    end



                    %    Average Approximation Entropy Profile
                    if(selData(STATISTIC_INDEX.AvgSampEn_Profile )==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Chanda/Entropy-Codes-master/Sample entropy');
                            m = str2double(app.editAvgApEn_Profile_M.Value);
                            %SWTEST Shapiro-Wilk parametric hypothesis test of composite normality.
                            %   [H, pValue, SWstatistic] = SWTEST(X, ALPHA)
                            %% check multidimension .. loop
                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpV= sampEnProfiling(currData(isnan(currData(:,i))==0,i),m);

                                profile = tmpV(~isinf(tmpV(:,2)),2);
                                tmpVal(1,i)=nanmean(profile);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.AvgSampEn_Profile} = tmpVal;
                            % back to script
                            ComputationTime{currIndex,STATISTIC_INDEX.AvgSampEn_Profile}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../../../../scripts')
                        end



                    end




                    %   RMS  Root-mean-square amplitude
                    %% matlab inbuild function
                    if(selData(STATISTIC_INDEX.RMS)==1)
                        % since rms cannot work with nan values, we check if currData
                        % contains any nan values, if so we just run only for data with
                        % no nan values
                        cd('../com/ExternalPackages');
                        tic
                        if sum(sum(isnan(currData)))==0
                            StatisticCol{currIndex,STATISTIC_INDEX.RMS} = rms(currData);
                        else
                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(1,i)=rms(currData(isnan(currData(:,i))==0,i));
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.RMS} = tmpVal;
                        end
                        ComputationTime{currIndex,STATISTIC_INDEX.RMS}=toc;
                        cd('../../scripts')
                    end

                    if(selData(STATISTIC_INDEX.RMSSD)==1)
                        tic
                        cd('../com/algorithms');
                        tmpVal = nan(1,size(currData,2));
                        for i=1:size(tmpVal,2)
                            kk=currData(:,i);
                            kk(isnan(kk),:)=[];
                            tmpVal(1,i)=getRMSSD(kk);
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.RMSSD}=tmpVal;
                        ComputationTime{currIndex,STATISTIC_INDEX.RMSSD}=toc;
                        cd('../../scripts');
                    end


                    %%%%%%%%%%%%%%%%%%--deepak

                    isError = true;
                    try
                        if(selData(STATISTIC_INDEX.HjorthMobility)==1) || (selData(STATISTIC_INDEX.HjorthComplexity)==1) || (selData(STATISTIC_INDEX.HjorthActivity)==1)
                            cd('../com/ExternalPackages/Hjorth');
                            %% to calculate Hjorth satistics we are using code given by Firgan Feradov
                            if(selData(STATISTIC_INDEX.HjorthMobility)==1)

                                %%multidimension
                                %% using loop

                                %    Hjorth_Mobility
                                tic
                                tmpVal = nan(1,size(currData,2));
                                for i=1:size(currData,2)
                                    %tmpVal(i,:)= f_hjorth_m(currData(isnan(currData(:,i))==0,i)');
                                    tmpVal(1,i)= f_hjorth_m(currData(isnan(currData(:,i))==0,i)');
                                end
                                StatisticCol{currIndex,STATISTIC_INDEX.HjorthMobility}=tmpVal;
                                ComputationTime{currIndex,STATISTIC_INDEX.HjorthMobility}=toc;
                            end
                            if(selData(STATISTIC_INDEX.HjorthComplexity)==1)
                                tic
                                %StatisticCol{currIndex,STATISTIC_INDEX.HjorthMobility}=f_hjorth_m(currData');
                                %    Hjorth_Complexity
                                tmpVal = nan(1,size(currData,2));
                                for i=1:size(currData,2)
                                    %tmpVal(i,:)= f_hjorth_c(currData(isnan(currData(:,i))==0,i)');
                                    tmpVal(1,i)= f_hjorth_c(currData(isnan(currData(:,i))==0,i)');
                                end
                                StatisticCol{currIndex,STATISTIC_INDEX.HjorthComplexity}=tmpVal;
                                ComputationTime{currIndex,STATISTIC_INDEX.HjorthComplexity}=toc;
                            end
                            if(selData(STATISTIC_INDEX.HjorthActivity)==1)
                                %StatisticCol{currIndex,STATISTIC_INDEX.HjorthComplexity}=f_hjorth_c(currData');
                                %    Hjorth_Activity
                                tic
                                tmpVal = nan(1,size(currData,2));
                                for i=1:size(currData,2)
                                    tmpVal(1,i)= f_hjorth_a(currData(isnan(currData(:,i))==0,i)');
                                end
                                StatisticCol{currIndex,STATISTIC_INDEX.HjorthActivity}=tmpVal;
                                ComputationTime{currIndex,STATISTIC_INDEX.HjorthActivity}=toc;
                                %StatisticCol{currIndex,STATISTIC_INDEX.HjorthActivity}=f_hjorth_a(currData');

                            end

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        end
                    catch e %e is an MException struct
                        if isError
                            getReport(e)

                        end
                        % more error handling...

                        %% moving back
                        clear tmpVal
                        cd('../../../scripts')
                    end




                    %LombScarglePeriodogram
                    %https://uk.mathworks.com/help/signal/ref/plomb.html
                    if(selData(STATISTIC_INDEX.FastLomb)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Lomb-Scargle');

                            t = linspace(1,1+(size(currData,1)*(1/SAMPLING_RATE)),size(currData,1));
                            %StatisticCol{currIndex,STATISTIC_INDEX.FastLomb}=fastlomb(currData,t);
                            for v =1:size(currData,2)
                                FastLombCol{currIndex,v}=fastlomb(currData(:,v),t);
                            end




                            ComputationTime{currIndex,STATISTIC_INDEX.FastLomb}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end


                    if(selData(STATISTIC_INDEX.FFT)==1)
                        tic

                        %StatisticCol{currIndex,STATISTIC_INDEX.FastLomb}=fastlomb(currData,t);
                        for v =1:size(currData,2)
                            FFTCol{currIndex,v}=fft(currData(:,v));
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.FFT}=toc;
                    end


                    %% ??? CHECK
                    %% corr(currData(1:end-1,1),currData(2:end,1))
                    %    Autocorrelation
                    %% calling matlab build in fuction autocorr
                    %%% autocorr(currData) return a vector of lags from 0,1, min[20,length(y)-1].
                    %%ResultAutoCorr{epochID,1} = autocorr(currData);
                    if(selData(STATISTIC_INDEX.AutoCorrelation)==1)
                        cd('../com/ExternalPackages/acf');
                        tic

                        numLags  = str2double(app.editAutoCorrNumLags.Value);
                        if numLags > (size(currData,1)-1)
                            numLags = size(currData,1)-1;
                            app.editAutoCorrNumLags.Value=numLags;
                        end

                        %numSTD   = str2double(app.editAutoCorrNumSTD.Value);
                        tmpVal = zeros(numLags,size(currData,2));
                        for i=1:size(currData,2)
                            %tmpVal(:,i) = autocorr(currData(isnan(currData(:,i))==0,i),'NumLags',numLags,'NumSTD',numSTD);
                            tmpVal(:,i) = acf(currData(isnan(currData(:,i))==0,i),numLags);
                        end
                        scaleInfo='';
                        for i=1:numLags
                            scaleInfo=strcat(scaleInfo,'Lag-',num2str(i),';');
                        end



                        StatisticCol{currIndex,STATISTIC_INDEX.AutoCorrelation}= tmpVal;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.AutoCorrelation,1}=scaleInfo;
                        ComputationTime{currIndex,STATISTIC_INDEX.AutoCorrelation}=toc;
                        clear tmpVal
                        cd('../../../scripts')
                    end


                    %    Autocovariance    crude assessment of nonstationarity   ?? CHECK 2
                    %% get lagK parameter (defined in xml file
                    if(selData(STATISTIC_INDEX.AutoCovariance)==1)
                        tic
                        cd('../com/algorithms')
                        lagK = str2double(app.editAutoCovLagK.Value);

                        % The function getAutoCov is created based on  https://www.mathstat.dal.ca/~stat5390/Section_3_ACF.pdf
                        tmpVal = nan(1,size(currData,2));
                        for i=1:size(currData,2)
                            tmpVal(1,i)=getAutoCov(currData(isnan(currData(:,i))==0,i),lagK);
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.AutoCovariance} = tmpVal;

                        ComputationTime{currIndex,STATISTIC_INDEX.AutoCovariance}=toc;
                        cd('../../scripts')
                    end



                    if(selData(STATISTIC_INDEX.ReverseA_Test)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/ECheynet-stationaryTests-af2a370');
                            %method = app.combbox_RA_Test
                            %  method = get(han
                            method = find(strcmp(app.pMenuRAMethod.Items,app.pMenuRAMethod.Value ));
                            StatisticCol{currIndex,STATISTIC_INDEX.ReverseA_Test}=RA_test(currData,method);

                            ComputationTime{currIndex,STATISTIC_INDEX.ReverseA_Test}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end

                    % MW_test(u,windowLength,threshold1,threshold2)
                    if(selData(STATISTIC_INDEX.MovingWindowTest)==1)
                        tic

                        isError = true;
                        try
                            cd('../com/ExternalPackages/ECheynet-stationaryTests-af2a370/');
                            %method = app.combbox_RA_Test

                            windowLength= str2double(app.editMWindowM.Value);
                            threshold1=str2double(app.editMWindowT1.Value);
                            threshold2=str2double(app.editMWindowT2.Value);




                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                %tmpVal(i,:)= MW_test(currData(isnan(currData(:,i))==0,i)',windowLength,threshold1,threshold2);
                                tmpVal(1,i)= MW_test(currData(isnan(currData(:,i))==0,i)',windowLength,threshold1,threshold2);
                            end


                            StatisticCol{currIndex,STATISTIC_INDEX.MovingWindowTest}=tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.MovingWindowTest}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end



                    %    HFD
                    %% remain to work with it
                    %Kmax: maximum number of sub-series composed from the original. To    determine its values, we have followed the recommendation of Doyle et
                    %al at "Discriminating between elderly and young using a fractal     dimension analysis of centre of pressure".
                    %% need to check how to defind kMax




                    if(selData(STATISTIC_INDEX.Higuchi_FD)==1)
                        tic
                        kMax = str2double(app.editHiguchiFD_KMax.Value);

                        %% mulitvariate re check..
                        tmpVal = nan(1,size(currData,2));

                        %allHFD_Vals=[];

                        %                 cd('../com/ExternalPackages/Fractal_dimension_measures');
                        %                 for kkMax=1:100
                        %                     allHFD_Vals = [allHFD_Vals;Higuchi_FD(currData(isnan(currData(:,i))==0,i)',kkMax)];
                        %                 end
                        %                 clear tmpValcd('../../../scripts');
                        %                 try
                        %                     if app.chkFetchFrmPlatue.Value ==1
                        %                         cd('../com/ExternalPackages');
                        %                         kMax = getPlatueIndex(currData,false);
                        %
                        %                     end
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Fractal_dimension_measures');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= Higuchi_FD(currData(isnan(currData(:,i))==0,i)',kMax);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Higuchi_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Higuchi_FD}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end





                        %                    tmpKIndex(1,i)=kMax;
                        %                 catch
                        %                     disp('Error in calling Higuchi FD')
                        %                 end



                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fd = AmplitudeFD(data, mind, maxd)
%  fd = DistanceFD(data, n)
% fd = LintersectFD(data)
% fd = PintersectFD(data, order)
% fd = SignFD(data)

                    if(selData(STATISTIC_INDEX.Amplitude_FD)==1)
                        tic


                      
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Kizlaitiene_FD');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= AmplitudeFD(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Amplitude_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Amplitude_FD}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end


                if(selData(STATISTIC_INDEX.Sign_FD)==1)
                        tic

                        isError = true;
                        try
                            cd('../com/ExternalPackages/Kizlaitiene_FD');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= SignFD(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Sign_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Sign_FD}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
 end



                if(selData(STATISTIC_INDEX.Pintersect_FD)==1)
                        tic

                        isError = true;
                        try
                            cd('../com/ExternalPackages/Kizlaitiene_FD');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= PintersectFD(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Pintersect_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Pintersect_FD}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                end




                    if(selData(STATISTIC_INDEX.Lintersect_FD)==1)
                        tic

                        isError = true;
                        try
                            cd('../com/ExternalPackages/Kizlaitiene_FD');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= LintersectFD(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Lintersect_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Lintersect_FD}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end






                    if(selData(STATISTIC_INDEX.Distance_FD)==1)
                        tic

                        isError = true;
                        try
                            cd('../com/ExternalPackages/Kizlaitiene_FD');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= DistanceFD(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Distance_FD} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.Distance_FD}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    if(selData(STATISTIC_INDEX.FD_Moisy_Box)==1)
                        tic


                        %allHFD_Vals=[];

                        %                 cd('../com/ExternalPackages/Fractal_dimension_measures');
                        %                 for kkMax=1:100
                        %                     allHFD_Vals = [allHFD_Vals;Higuchi_FD(currData(isnan(currData(:,i))==0,i)',kkMax)];
                        %                 end
                        %                 clear tmpValcd('../../../scripts');
                        %                 try
                        %                     if app.chkFetchFrmPlatue.Value ==1
                        %                         cd('../com/ExternalPackages');
                        %                         kMax = getPlatueIndex(currData,false);
                        %
                        %                     end
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Fractal_dimension_measures/BoxCountFD');
                            for i=1:size(currData,2)
                                [~,~,tmpVal(1,i)]= getBoxCount_FMoisy(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.FD_Moisy_Box} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.FD_Moisy_Box}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end
                    end



                    if(selData(STATISTIC_INDEX.FD_Linden_Box)==1)
                        tic


                        %allHFD_Vals=[];

                        %                 cd('../com/ExternalPackages/Fractal_dimension_measures');
                        %                 for kkMax=1:100
                        %                     allHFD_Vals = [allHFD_Vals;Higuchi_FD(currData(isnan(currData(:,i))==0,i)',kkMax)];
                        %                 end
                        %                 clear tmpValcd('../../../scripts');
                        %                 try
                        %                     if app.chkFetchFrmPlatue.Value ==1
                        %                         cd('../com/ExternalPackages');
                        %                         kMax = getPlatueIndex(currData,false);
                        %
                        %                     end
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Fractal_dimension_measures/BoxCountFD');
                            for i=1:size(currData,2)
                                [~,~,tmpVal(1,i)]= boxcount_Gwendolyn(currData(isnan(currData(:,i))==0,i));
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.FD_Linden_Box} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.FD_Linden_Box}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end
                    end


                    if(selData(STATISTIC_INDEX.AlanFactor_AF)==1)
                        tic
                        nWindow = str2double(app.editAlanFactor_nWindow.Value);

                        %% mulitvariate re check..
                        tmpVal = nan(1,size(currData,2));


                        isError = true;
                        try
                            cd('../com/ExternalPackages/DavidCornforth_HRV');
                            for i=1:size(currData,2)
                                tmpVal(1,i)= getAllanFactor(currData(isnan(currData(:,i))==0,i),nWindow);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.AlanFactor_AF} = tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.AlanFactor_AF}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end





                        %                    tmpKIndex(1,i)=kMax;
                        %                 catch
                        %                     disp('Error in calling Higuchi FD')
                        %                 end



                    end




                    if(selData(STATISTIC_INDEX.CorrDim_D2)==1)
                        cd('../com/ExternalPackages/matlabToolBox/Predictive Maintenance');
                        tic

                        try
                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)
                                m=str2num(app.editCorrDimM.Value);
                                lag =str2num(app.editCorrDimLag.Value);

                                tmpVal(1,i)= correlationDimension(currData(isnan(currData(:,i))==0,i),m,lag);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.CorrDim_D2} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.CorrDim_D2}=toc;
                        catch e
                            getReport(e)
                        end
                        cd('../../../../scripts')
                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%     Remove this block             %%%%%%%%%%%%%%%%%%%%%%%%%%%     %%%%%%%%%%%%%%%













                    %                      if(selData(STATISTIC_INDEX.Farara_D2)==1)
                    %                         cd('Farada_CorrDim');
                    %                         tic
                    %
                    %                         try
                    %                             tmpVal = zeros(1,size(currData,2));
                    %                             for i=1:size(currData,2)
                    %                                kk=currData(isnan(currData(:,i))==0,i);
                    %
                    %                                 tmpVal(1,i)= extremal_Sueveges(kk,0.99);
                    %                             end
                    %
                    %                             StatisticCol{currIndex,STATISTIC_INDEX.Farara_D2} = tmpVal;
                    %                             %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                    %                             ComputationTime{currIndex,STATISTIC_INDEX.Farara_D2}=toc;
                    %                         catch e
                    %                             getReport(e)
                    %                         end
                    %                         cd('../')
                    %                      end
                    %
                    %
                    %
                    %
                    %
                    %                       if(selData(STATISTIC_INDEX.Farara_D2_Log)==1)
                    %                         cd('Farada_CorrDim');
                    %                         tic
                    %
                    %                         try
                    %                             tmpVal = zeros(1,size(currData,2));
                    %                             for i=1:size(currData,2)
                    %                                kk=-log(abs(currData(isnan(currData(:,i))==0,i)));
                    %
                    %                                 tmpVal(1,i)= extremal_Sueveges(kk,0.99);
                    %                             end
                    %
                    %                             StatisticCol{currIndex,STATISTIC_INDEX.Farara_D2_Log} = tmpVal;
                    %                             %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                    %                             ComputationTime{currIndex,STATISTIC_INDEX.Farara_D2_Log}=toc;
                    %                         catch e
                    %                             getReport(e)
                    %                         end
                    %                         cd('../')
                    %                       end
                    %
                    %
                    %
                    %
                    %
                    %
                    %
                    %                       if(selData(STATISTIC_INDEX.Farara_D2__lag1)==1)
                    %                         cd('Farada_CorrDim');
                    %                         tic
                    %
                    %                         try
                    %                             tmpVal = zeros(1,size(currData,2));
                    %                             for i=1:size(currData,2)
                    %
                    %                                kk=currData(isnan(currData(:,i))==0,i);
                    %                                kk1=kk(2:end)-kk(1:end-1);
                    %                                %kk1=-log(abs(kk1));
                    %
                    %                                 tmpVal(1,i)= extremal_Sueveges(kk1,0.99);
                    %                             end
                    %
                    %                             StatisticCol{currIndex,STATISTIC_INDEX.Farara_D2__lag1} = tmpVal;
                    %                             %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                    %                             ComputationTime{currIndex,STATISTIC_INDEX.Farara_D2__lag1}=toc;
                    %                         catch e
                    %                             getReport(e)
                    %                         end
                    %                         cd('../')
                    %                      end
                    %
                    %
                    %                     if(selData(STATISTIC_INDEX.Farara_D2__lag1_Log)==1)
                    %                         cd('Farada_CorrDim');
                    %                         tic
                    %
                    %                         try
                    %                             tmpVal = zeros(1,size(currData,2));
                    %                             for i=1:size(currData,2)
                    %
                    %                                kk=currData(isnan(currData(:,i))==0,i);
                    %                                kk1=-log(abs(kk(2:end)-kk(1:end-1)));
                    %                                %kk1=-log(abs(kk1));
                    %
                    %                                 tmpVal(1,i)= extremal_Sueveges(kk1,0.99);
                    %                             end
                    %
                    %                             StatisticCol{currIndex,STATISTIC_INDEX.Farara_D2__lag1_Log} = tmpVal;
                    %                             %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                    %                             ComputationTime{currIndex,STATISTIC_INDEX.Farara_D2__lag1_Log}=toc;
                    %                         catch e
                    %                             getReport(e)
                    %                         end
                    %                         cd('../')
                    %                      end
                    %


                    %%%%%%%%%%%%%%%%%%%% Remove this %%%%%%%%%%%%%%%%%%%% block......................

                    % The Hurst exponent

                    if(selData(STATISTIC_INDEX.HurstExponent_H)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/hurst_exponent');
                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)


                                tmpVal(1,i)= estimate_hurst_exponent(currData(isnan(currData(:,i))==0,i)');
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.HurstExponent_H} = tmpVal;
                            %kMaxHiguchiFD(epochID,:) = tmpKIndex;
                            ComputationTime{currIndex,STATISTIC_INDEX.HurstExponent_H}=toc;






                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end





                        %                    tmpKIndex(1,i)=kMax;
                        %                 catch
                        %                     disp('Error in calling Higuchi FD')
                        %                 end
                    end


                    %% to calculate DFA we are using the code given by Martin Magris


                    if(selData(STATISTIC_INDEX.DFA)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/DFA');
                            %%deepak
                            %%[bs, Fq1, Fq2] = FMFDFA(currData, -5:1:5, 6, 4, 0);


                            m=str2double(app.editDFAEmbededDim.Value);
                            k=str2double(app.editDFAOrder.Value);

                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                [A,F] = DFA_fun(currData(isnan(currData(:,i))==0,i),m,k);

                                tmpVal(1,i)=A(1);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.DFA}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.DFA}=toc;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %% DFA by MATS
                    %% dfa=DetrendedFluctuation(xV) → return single value
                    if(selData(STATISTIC_INDEX.DFA_MATS)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/MATS');




                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                tmpVal(1,i) = DetrendedFluctuation(currData(isnan(currData(:,i))==0,i));


                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.DFA_MATS}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.DFA_MATS}=toc;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                    if selData(STATISTIC_INDEX.RQA)==1
                        tic
                        cd('../com/ExternalPackages/RecurrencePlot_ToolBox');

                        m=str2num(app.editRQA_M.Value);
                        tau=str2num(app.editRQA_Tau.Value);
                        r=str2double(app.editRQA_R.Value);
                        minLine=str2num(app.editRQA_Minline.Value);

                        %r=r*nanstd(currData)



                        %%deepak
                        scaleInfo='REC (%); DET (%);Lmax;ENT;LAM;TT';
                        tmpVal= nan(6,size(currData,2));
                        for v=1:size(currData,2)
                            % tmpVal(:,v)  = get([[1:size(currData,1)]' currData(:,v)],linepara)' ;
                            tmpR = r*nanstd(currData(:,v));
                            tmpVal(:,v)=getRecurrentStatitic(currData(:,v),m,tau,tmpR,minLine);

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.RQA}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.RQA,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.RQA}=toc;


                        clear tmpVal
                        cd('../../../scripts')
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                 
                    if selData(STATISTIC_INDEX.RQA_marwan)==1
                        tic
                        cd('../com/ExternalPackages/SymmetricalRecurrences');

                       

                        %r=r*nanstd(currData)


                        % RQA.RR    = y(1);%      Y(1) = RR     (recurrence rate)
                        % RQA.DET   = y(2);%      Y(2) = DET    (determinism)
                        % RQA.Lmoy  = y(3);%      Y(3) = <L>    (mean diagonal line length)
                        % RQA.Lmax  = y(4);%      Y(4) = Lmax   (maximal diagonal line length)
                        % RQA.ENTR  = y(5);%      Y(5) = ENTR   (entropy of the diagonal line lengths)
                        % RQA.LAM   = y(6);%      Y(6) = LAM    (laminarity)
                        % RQA.TT    = y(7);%      Y(7) = TT     (trapping time)
                        % RQA.Vmax  = y(8);%      Y(8) = Vmax   (maximal vertical line length)
                        % RQA.RTmax = y(9);%      Y(9) = RTmax  (maximal white vertical line length)
                        % RQA.T2    = y(10);%     Y(10) = T2     (recurrence time of 2nd type)
                        % RQA.RTE   = y(11);%     Y(11) = RTE    (recurrence time entropy, i.e., RPDE)
                        % RQA.Clust = y(12);%     Y(12) = Clust  (clustering coefficient)
                        % RQA.Trans = y(13);%     Y(13) = Trans  (transitivity)






                        %%deepak
                        scaleInfo='RR;DET;Lmoy;Lmax;ENTR;LAM;TT;Vmax;RTmax;T2;RTE;Clust;Trans';
                        tmpVal= nan(13,size(currData,2));
                        for v=1:size(currData,2)
                            % tmpVal(:,v)  = get([[1:size(currData,1)]' currData(:,v)],linepara)' ;
                           
                            RQA=getRQA_marwan(currData(:,v));

                            tmpVal(1,v) = RQA.RR;%   = y(1);%      Y(1) = RR     (recurrence rate)
                            tmpVal(2,v) = RQA.DET;%   = y(2);%      Y(2) = DET    (determinism)
                            tmpVal(3,v) = RQA.Lmoy;%  = y(3);%      Y(3) = <L>    (mean diagonal line length)
                            tmpVal(4,v) = RQA.Lmax;%  = y(4);%      Y(4) = Lmax   (maximal diagonal line length)
                            tmpVal(5,v) = RQA.ENTR;%  = y(5);%      Y(5) = ENTR   (entropy of the diagonal line lengths)
                            tmpVal(6,v) = RQA.LAM;%   = y(6);%      Y(6) = LAM    (laminarity)
                            tmpVal(7,v) = RQA.TT;%    = y(7);%      Y(7) = TT     (trapping time)
                            tmpVal(8,v) = RQA.Vmax;%  = y(8);%      Y(8) = Vmax   (maximal vertical line length)
                            tmpVal(9,v) = RQA.RTmax;% = y(9);%      Y(9) = RTmax  (maximal white vertical line length)
                            tmpVal(10,v) = RQA.T2;%    = y(10);%     Y(10) = T2     (recurrence time of 2nd type)
                            tmpVal(11,v) = RQA.RTE;%   = y(11);%     Y(11) = RTE    (recurrence time entropy, i.e., RPDE)
                            tmpVal(12,v) = RQA.Clust;% = y(12);%     Y(12) = Clust  (clustering coefficient)
                            tmpVal(13,v) = RQA.Trans;% = y(13);%     Y(13) = Trans  (transitivity)
                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.RQA_marwan}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.RQA_marwan,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.RQA_marwan}=toc;


                        clear tmpVal
                        cd('../../../scripts')
                    end
                    




                    
                    
                    %%[jitta,jitt,RAP,PPQ5]=jitter(T)

                    %%% [Shim,ShdB,apq3,apq5]=Shimmer(A)



                      if selData(STATISTIC_INDEX.Shimmer_Measures)==1
                        tic
                        cd('../com/ExternalPackages/Jitter_Shimmer');

                      
                        %r=r*nanstd(currData)

                        %%deepak
                        scaleInfo='Shim;ShdB;apq3;apq5';
                         
                        tmpVal= nan(4,size(currData,2));
                        for v=1:size(currData,2)
                           
                            [Shim,ShdB,apq3,apq5]=Shimmer(currData(isnan(currData(:,v))==0,v) );
                            tmpVal(:,v)=[ Shim,ShdB,apq3,apq5 ]';

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.Shimmer_Measures}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.Shimmer_Measures,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.Shimmer_Measures}=toc;


                        clear tmpVal
                        cd('../../../scripts')
                    end







%%% Jitter Measure
                    if selData(STATISTIC_INDEX.Jitter_Measures)==1
                        tic
                        cd('../com/ExternalPackages/Jitter_Shimmer');

                      
                        %r=r*nanstd(currData)

                        %%deepak
                        scaleInfo='jitta;jitt;RAP;PPQ5';
                         
                        tmpVal= nan(4,size(currData,2));
                        for v=1:size(currData,2)
                           
                            [jitta,jitt,RAP,PPQ5]=jitter(currData(isnan(currData(:,v))==0,v) );
                            tmpVal(:,v)=[ jitta,jitt,RAP,PPQ5 ]';

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.Jitter_Measures}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.Jitter_Measures,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.Jitter_Measures}=toc;


                        clear tmpVal
                        cd('../../../scripts')
                    end







                    %%% point care new
                    if selData(STATISTIC_INDEX.HRA_Accel_Decel)==1
                        tic
                        cd('../com/ExternalPackages/Ashis');

                      
                        %r=r*nanstd(currData)



                        %%deepak
                        scaleInfo='SD1up;SD1dn;SD2up;SD2dn;SDNNup;SDNNdn;C1a;C1d;C2a;C2d';
                         
                        tmpVal= nan(10,size(currData,2));
                        for v=1:size(currData,2)
                           
                            [ SD1up,SD1dn,SD2up,SD2dn,SDNNup,SDNNdn,C1a,C1d,C2a,C2d ]  = poincareNew( currData(isnan(currData(:,v))==0,v) );
                            tmpVal(:,v)=[ SD1up,SD1dn,SD2up,SD2dn,SDNNup,SDNNdn,C1a,C1d,C2a,C2d ]';

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.HRA_Accel_Decel}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.HRA_Accel_Decel,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.HRA_Accel_Decel}=toc;


                        clear tmpVal
                        cd('../../../scripts')
                    end

                    %%%

                    %%deepak EEP
                    if selData(STATISTIC_INDEX.ExtendedPoincare_EPP)==1
                        tic
                        cd('../com/ExternalPackages/ExtendedPoincarePlot_ReemSatti');

                        k=str2num(app.editEPPLag.Value);
                        tmpVal= nan(4*k,size(currData,2));
                        %%deepak
                        scaleInfo='';
                        for v=1:size(currData,2)
                            [r,P, SD1, SD2] = extPoinc(currData(~isnan(currData(:,v)),v),k) ;


                            for i=1:k
                                if v==1
                                    scaleInfo=strcat(scaleInfo,'r-',num2str(i),';');
                                end
                                tmpVal(i,v)=r(i);
                            end


                            for i=1:k
                                if v==1
                                    scaleInfo=strcat(scaleInfo,'P-',num2str(i),';');
                                end
                                tmpVal(k+i,v)=P(i);
                            end

                            for i=1:k
                                if v==1
                                    scaleInfo=strcat(scaleInfo,'SD1-',num2str(i),';');
                                end
                                tmpVal(2*k+i,v)=SD1(i);
                            end


                            for i=1:k
                                if v==1
                                    scaleInfo=strcat(scaleInfo,'SD2-',num2str(i),';');
                                end
                                tmpVal(3*k+i,v)=SD2(i);
                            end
                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.ExtendedPoincare_EPP}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.ExtendedPoincare_EPP,1}=scaleInfo;
                        ComputationTime{currIndex,STATISTIC_INDEX.ExtendedPoincare_EPP}=toc;

                        clear tmpVal
                        cd('../../../scripts')
                    end





                    %%deepak HRA_Symmetrics
                    if selData(STATISTIC_INDEX.HRA_PI_GI_AI_SI)==1
                        tic
                        cd('../com/ExternalPackages/Ashis');

                        

                        tau=str2num(app.editHRM_Tau.Value);
                        tmpVal= nan(4,size(currData,2));
                        %%deepak
                        scaleInfo='PI;GI;SI;AI';
                        for v=1:size(currData,2)
                            hrm = hrasymm(currData(~isnan(currData(:,v)),v),tau) ;
                            


                            
                               
                                tmpVal(1,v)=hrm.PI;
                                tmpVal(2,v)=hrm.GI;
                                tmpVal(3,v)=hrm.SI;
                                tmpVal(4,v)=hrm.AI;
                            

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.HRA_PI_GI_AI_SI}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.HRA_PI_GI_AI_SI,1}=scaleInfo;
                        ComputationTime{currIndex,STATISTIC_INDEX.HRA_PI_GI_AI_SI}=toc;

                        clear tmpVal
                        cd('../../../scripts')
                    end







                    %%%%%%%%%%%%%%%%%%%%%%%%%%

                    if(selData(STATISTIC_INDEX.AsymmetryIndex_ASI)==1)

                        tic

                        isError = true;
                        try


                            %% use from Ashis

                            cd('../com/ExternalPackages/Ashis');




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)=asi(tmpData);

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.AsymmetryIndex_ASI}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%% EhlerIndex_EI

                    if(selData(STATISTIC_INDEX.EhlerIndex_EI)==1)

                        tic

                        isError = true;
                        try


                            %% use from Ashis

                            cd('../com/algorithms');




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)= getEhlersIndex(tmpData);

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.EhlerIndex_EI}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../scripts')
                        end


                    end





                    if selData(STATISTIC_INDEX.LZC)==1
                        tic
                        cd('../com/ExternalPackages/LZC');




                        tmpVal= nan(1,size(currData,2));
                        %%deepak

                        for v=1:size(currData,2)

                            %%calc_lz_complexity(B(j,:), 'exhaustive', 1);


                            tmpVal(1,v)  = calc_lz_complexity(currData(~isnan(currData(:,v)),v), 'exhaustive', 1);

                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.LZC}=tmpVal   ;


                        ComputationTime{currIndex,STATISTIC_INDEX.LZC}=toc;

                        clear tmpVal
                        cd('../../../scripts')
                    end



                    %%%%%%%%%%%%%%%    Modified_mSE_MmSE


                    if selData(STATISTIC_INDEX.Modified_mSE_MmSE)==1
                        tic
                        cd('../com/ExternalPackages/Wu_MMSE');

                        try
                            scale=str2num(app.editMMSE_scale.Value);


                            tmpVal= nan(scale,size(currData,2));
                            %%deepak
                            scaleInfo='';
                            for v=1:size(currData,2)
                                tmpVal(:,v)  = MMSE(currData(:,v),scale)' ;

                                %% chk if we can do this out of for v loop...deepak
                                for i=1:scale
                                    if v==1
                                        scaleInfo=strcat(scaleInfo,'s-',num2str(i),';');
                                    end

                                end



                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.Modified_mSE_MmSE}=tmpVal   ;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.Modified_mSE_MmSE,1}=scaleInfo;

                            ComputationTime{currIndex,STATISTIC_INDEX.Modified_mSE_MmSE}=toc;
                            throwME(MException("Go To Finally","Finally"));
                        catch

                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end






                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                    %CompositeMsE_CmSE



                    if selData(STATISTIC_INDEX.CompositeMsE_CmSE)==1
                        tic
                        cd('../com/ExternalPackages/Wu_MMSE');

                        try
                            scale=str2num(app.editCMSE_scale.Value);


                            tmpVal= nan(scale,size(currData,2));
                            %%deepak
                            scaleInfo='';
                            for v=1:size(currData,2)
                                tmpVal(:,v)  = CCME(currData(:,v),scale)' ;

                                %% chk if we can do this out of for v loop...deepak
                                for i=1:scale
                                    if v==1
                                        scaleInfo=strcat(scaleInfo,'s-',num2str(i),';');
                                    end

                                end



                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.CompositeMsE_CmSE}=tmpVal   ;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.CompositeMsE_CmSE,1}=scaleInfo;

                            ComputationTime{currIndex,STATISTIC_INDEX.CompositeMsE_CmSE}=toc;
                            throwME(MException("Go To Finally","Finally"));
                        catch

                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end






                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




                    if selData(STATISTIC_INDEX.Multiscale_LZC)==1
                        tic
                        cd('../com/ExternalPackages/LZC');

                        strScals=app.editMLZCScal.Value;
                        strScals=strsplit(strScals,',');
                        scals=[];
                        try

                            for ii=1:size(strScals,2)
                                scals=[scals  str2num(strScals{ii})];
                            end
                        catch
                            msgbox('Invalid Input')
                            app.editMLZCScal.Value = {'1,3,5'};
                            scals=[1 3 5];
                        end
                        scals=sort(scals);
                        tmpVal= nan(size(scals,2),size(currData,2));
                        %%deepak
                        scaleInfo='';
                        for v=1:size(currData,2)
                            tmpVal(:,v)  = getMultiscaleLZ(currData(:,v),scals)' ;

                            %% chk if we can do this out of for v loop...deepak
                            for i=1:size(scals,2)
                                if v==1
                                    scaleInfo=strcat(scaleInfo,'s-',num2str(scals(i)),';');
                                end

                            end



                        end

                        StatisticCol{currIndex,STATISTIC_INDEX.Multiscale_LZC}=tmpVal   ;
                        ALL_ScaleHeadingCol{STATISTIC_INDEX.Multiscale_LZC,1}=scaleInfo;

                        ComputationTime{currIndex,STATISTIC_INDEX.Multiscale_LZC}=toc;

                        clear tmpVal
                        cd('../../../scripts')
                    end


                    %       function [SE,unique] = ShannonEn(series,L,num_int)
                    %{
            Function which computes the Shannon Entropy (SE) of a time series of length
            'N' using an embedding dimension 'L' and 'Num_int' uniform intervals of
            quantification. The algoritm presented by Porta et al. at "Measuring
            regularity by means of a corrected conditional entropy in sympathetic
            outflow" (PMID: 9485587) has been followed.
            
            INPUT:
                    series: the time series.
                    L: the embedding dimension.
                    num_int: the number of uniform intervals used in the quantification
                    of the series.
            
            OUTPUT:
                    SE: the SE value.
                    unique: the number of patterns which have appeared only once. This
                    output is only useful for computing other more complex entropy
                    measures such as Conditional Entorpy or Corrected Conditional
                    Entorpy. If you do not want to use it, put '~' in the call of the
function.
            
            
            
                    %%%deepak
                    %}

                    if(selData(STATISTIC_INDEX.ShannonEntropy_SE)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/Entropy_measures');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.
                            m = str2double(app.editShEn_M.Value);
                            numInt = str2double(app.editShEn_numInt.Value);
                            % [SE,unique] = ShannonEn(series,L,num_int)
                            tmpValue=nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpValue(1,i)=ShannonEn(currData(~isnan(currData(:,i)),i),m,numInt);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ShannonEntropy_SE}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.ShannonEntropy_SE}=toc;

                    end



                    if(selData(STATISTIC_INDEX.Permutation_JS_Complexity_PJSC)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/Luciano Zunino');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.
                            m = str2double(app.editPJSC_M.Value);
                            tau = str2double(app.editPJSC_Tau.Value);
                            % [SE,unique] = ShannonEn(series,L,num_int)
                            tmpValue=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                tmpValue(1,v)=JS_complexity(currData(isnan(currData(:,v))==0,v),m,tau);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Permutation_JS_Complexity_PJSC}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.Permutation_JS_Complexity_PJSC}=toc;

                    end


                    %% Tsallis Permutation Entropy
                    if(selData(STATISTIC_INDEX.TsallisPE_TPE )==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/Luciano Zunino');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.
                            m = str2double(app.editPTE_M.Value);
                            tau = str2double(app.editPTE_Tau.Value);
                            k= str2double(app.editPTE_TO.Value);
                            % [SE,unique] = ShannonEn(series,L,num_int)
                            tmpValue=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                tmpValue(1,v)=Tsallis_perm_entropy(currData(isnan(currData(:,v))==0,v),m,tau,k);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.TsallisPE_TPE}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.TsallisPE_TPE }=toc;

                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                    %% Renyi Permutation Entropy


                    if(selData(STATISTIC_INDEX.RenyiPE_RPE )==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/Luciano Zunino');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.
                            m = str2double(app.editRPE_M.Value);
                            tau = str2double(app.editRPE_Tau.Value);
                            k= str2double(app.editRPE_RO.Value);
                            % [SE,unique] = ShannonEn(series,L,num_int)
                            tmpValue=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                tmpValue(1,v)=Renyi_perm_entropy(currData(isnan(currData(:,v))==0,v),m,tau,k);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.RenyiPE_RPE}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.RenyiPE_RPE }=toc;

                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%     edge entropy




                    if(selData(STATISTIC_INDEX.Edge_PE )==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/edgePE');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.
                            m = str2double(app.editEdgePE_M.Value);
                            t = str2double(app.editEdgePE_T.Value);
                            r= str2double(app.editEdgePE_R.Value);
                            % [SE,unique] = ShannonEn(series,L,num_int)
                            tmpValue=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                tmpValue(1,v)=edgePE(currData(isnan(currData(:,v))==0,v)',m,t,r);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Edge_PE}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.Edge_PE }=toc;

                    end


                    %%%%%%%%%%%%Harikala%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if(selData(STATISTIC_INDEX.EntropyOfDifference_EoD)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/algorithms/EntropyOfDiff');
                            m = str2double(app.editEoD_M.Value);
                            shift = str2num(app.editEoD_Shift.Value);
                            %%EDm = getEntropyOfDiff(data,m,shiftN)

                            tmpValue=nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpValue(1,i)=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);
                                %[~,tmpValue(1,i)]=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.EntropyOfDifference_EoD}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.EntropyOfDifference_EoD}=toc;

                    end


                    %%%%%%%%%%%%Harikala%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if(selData(STATISTIC_INDEX.ShannonExtropy_SEx)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/Giuseppse_Extropies');
                            m = str2double(app.editSEx_M.Value);
                            numInt = str2num(app.editSEx_NumInt.Value);
                            %%EDm = getEntropyOfDiff(data,m,shiftN)

                            tmpValue=nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpValue(1,i)=ShannonExtropy(currData(~isnan(currData(:,i)),i),m,numInt);
                                %[~,tmpValue(1,i)]=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ShannonExtropy_SEx}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.ShannonExtropy_SEx}=toc;

                    end



                    

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if(selData(STATISTIC_INDEX.KullbachLeiblerDivergence_KLD)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/algorithms/EntropyOfDiff');
                            m = str2num(app.editKLD_M.Value);
                            shift = str2num(app.editKLD_Shift.Value);
                            %%EDm = getEntropyOfDiff(data,m,shiftN)

                            tmpValue=nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpValue(1,i)=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);
                                %[~,tmpValue(1,i)]=getEntropyOfDiff(currData(~isnan(currData(:,i)),i),m,shift);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.KullbachLeiblerDivergence_KLD}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.EntropyOfDifference_EoD}=toc;

                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






                    if(selData(STATISTIC_INDEX.Entropy_MC)==1)
                        tic
                        isError = true;
                        try


                            %cd('../com/ExternalPackages/entropy');
                            cd('../com/ExternalPackages/InfoTheory/InfoTheory');
                            % L: the embedding dimension.
                            %numInt: the number of uniform intervals used in the quantificationof the series.

                            for i=1:size(currData,2)
                                tmpValue(1,i)=entropy(currData(:,i));
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Entropy_MC}=tmpValue;




                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.Entropy_MC}=toc;

                    end






                    if(selData(STATISTIC_INDEX.RenyiEntropy_RE)==1)
                        tic
                        q=str2double(app.editREntropyQ.Value);

                        isError = true;
                        try

                            cd('../com/ExternalPackages/entropy');
                            tmpVal=nan(1,size(currData,2));
                            for v=1:size(tmpVal,2)
                                tmpData=currData(:,v);
                                tmpData(isnan(tmpData),:)=[];
                                tmpVal(1,v)=renyi_entro(tmpData,q);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.RenyiEntropy_RE}=tmpVal;
                            clear tmpVal;
                            ComputationTime{currIndex,STATISTIC_INDEX.RenyiEntropy_RE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end

                    if(selData(STATISTIC_INDEX.TsallisEntropy_TE)==1)
                        q=str2double(app.editTEntropyQ.Value);
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/entropy');






                            tmpVal=nan(1,size(currData,2));
                            for v=1:size(tmpVal,2)
                                tmpData=currData(:,v);
                                tmpData(isnan(tmpData),:)=[];
                                tmpVal(1,v)=Tsallis_entro(tmpData,q);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.TsallisEntropy_TE}=tmpVal;




                            ComputationTime{currIndex,STATISTIC_INDEX.TsallisEntropy_TE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end




                    if(selData(STATISTIC_INDEX.AverageEntropy_AE)==1)
                        bins = str2double(app.editAE_BinSize.Value);
                        pScale = str2double(app.editAE_Scale.Value);
                        pMin = str2double(app.editAE_Min.Value);
                        pMax = str2double(app.editAE_Max.Value);
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/EA');
                            tmpVal=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                [~,tmpVal(1,v)]=EA(currData(isnan(currData(:,v))==0,v),pScale,bins,pMin,pMax);
                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.AverageEntropy_AE}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.AverageEntropy_AE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end





                    if(selData(STATISTIC_INDEX.Entropy_of_Entropy_EoE)==1)
                        bins = str2double(app.editEE_BinSize.Value);
                        pScale = str2double(app.editEE_Scale.Value);
                        pMin = str2double(app.editEE_Min.Value);
                        pMax = str2double(app.editEE_Max.Value);
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/EA');
                            tmpVal=nan(1,size(currData,2));
                            for v=1:size(currData,2)
                                tmpVal(1,v)=EA(currData(isnan(currData(:,v))==0,v),pScale,bins,pMin,pMax);

                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Entropy_of_Entropy_EoE}=tmpVal;
                            ComputationTime{currIndex,STATISTIC_INDEX.Entropy_of_Entropy_EoE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end





                    if(selData(STATISTIC_INDEX.MultiscalePE_mPE)==1)
                        tic


                        isError = true;
                        try



                            cd('../com/ExternalPackages/MPerm');


                            m = str2double(app.editPEM.Value);
                            t = str2double(app.editPET.Value);
                            scale=str2double(app.editPEScale.Value);


                            tmpVal = zeros(scale,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(:,i)=MPerm(currData(isnan(currData(:,i))==0,i),m,t,scale)';

                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.MultiscalePE_mPE} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.MultiscalePE_mPE}=toc;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal;
                            cd('../../../scripts')
                        end
                    end






                    if(selData(STATISTIC_INDEX.AmplitudeAware_PE)==1)
                        tic


                        isError = true;
                        try



                            cd('../com/ExternalPackages/DataShare');


                            m = str2double(app.editAAPEM.Value);
                            t = str2double(app.editAAPET.Value);
                            a = str2double(app.editAAPEA.Value);

                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(1,i)=AAPE_Corr(currData(isnan(currData(:,i))==0,i),m,t,a);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.AmplitudeAware_PE} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.AmplitudeAware_PE}=toc;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal;
                            cd('../../../scripts')
                        end
                    end





                    %  Input:AAPE(y,m,varargin)
                    % y: univariate signal
                    % m: order of AAPE
                    % t: delay time of AAPE (the defulat value of t is 1)
                    % A: adjusting coefficient related to the mean value and difference between
                    % consecutive samples (the defulat value of A is 0.5)
                    %
                    %
                    % Output:
                    %Out_AAPE: amplitude-aware permutation entropy (AAPE)
                    %
                    %% ??? CHECK how to define t
                    if(selData(STATISTIC_INDEX.ImPE)==1)
                        tic

                        isError = true;
                        try



                            cd('../com/ExternalPackages/DataShare');


                            m = str2double(app.editImPEM.Value);
                            t = str2double(app.editImPET.Value);
                            scale = str2double(app.editImPEScale.Value);

                            %% using the pe defined in datasehare
                            %% mulitdimension check
                            %% using loop
                            %% here pe(currData,m,t) return single value for muldimension as well ???

                            tmpVal = zeros(scale,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(:,i)=impe(currData(isnan(currData(:,i))==0,i),m,t,scale);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ImPE} = tmpVal;
                            %StatisticCol{currIndex,STATISTIC_INDEX.PE} = pe(currData,m,t);

                            ComputationTime{currIndex,STATISTIC_INDEX.ImPE}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal;
                            cd('../../../scripts')
                        end


                    end

                    %    (M)PME
                    %(Multiscale) Permutation min-entropy (PME)
                    % https://uk.mathworks.com/matlabcentral/fileexchange/37288-multiscale-permutation-entropy-mpe


                    %  Calculate the Multiscale Permutation Entropy (MPE)

                    %  Input:   X: time series;
                    %           m: order of permuation entropy
                    if(selData(STATISTIC_INDEX.mPM_E)==1)

                        isError = true;
                        try




                            %cd('../com/ExternalPackages/MPerm');
                            cd('../com/ExternalPackages')

                            tic
                            m=str2double(app.editMPeM.Value);
                            %           t: delay time of permuation entropy,
                            t=str2double(app.editMPeT.Value);
                            %           Scale: the scale factor
                            %scale=str2double(app.editMPeScale.Value);

                            % Output:
                            %           MPE: multiscale permuation entropy
                            %ResultMPerm(epochID,:)=MPerm(currData,m,t,scale);
                            %% we are using the one defined by Gaoxiang

                            %% check multidimension
                            %% MPerm with multidimension give just the value equivalent to first dimension only
                            %% using loop

                            %                            tmpVal = zeros(scale,size(currData,2))
                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                %% change to permMinEntropy

                                %tmpVal(:,i)= [MPerm(currData(isnan(currData(:,i))==0,i)',m,t,scale)]';
                                tmpVal(1,i)=perm_min_entropy(currData(isnan(currData(:,i))==0,i),m,t);
                            end
                            %StatisticCol{currIndex,STATISTIC_INDEX.M_PME}=MPerm(currData,m,t,scale);
                            StatisticCol{currIndex,STATISTIC_INDEX.mPM_E}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.mPM_E}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            %clear tmpValcd('../../../scripts')
                            cd('../../scripts')
                        end

                    end





                    %% Petrosian_FD = 46+1
                    if(selData(STATISTIC_INDEX.Petrosian_FD)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/PetrosianFD');





                            %% Code for computing approximate entropy for a time series: Approximate
                            % Entropy is a measure of complexity. It quantifies the unpredictability of
                            %
                            %  PREFORMATTED
                            %  TEXT
                            %
                            % fluctuations in a time series

                            % To run this function- type: approx_entropy('window length','similarity measure','data set')

                            % i.e  approx_entropy(5,0.5,a)





                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                % tmpVal(1,i)=    approx_entropy(m,tmpR,currData(isnan(currData(:,i))==0,i)');
                                tmpVal(1,i)=    PetrosianFD(currData(isnan(currData(:,i))==0,i))
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.Petrosian_FD} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.Petrosian_FD}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                fprintf(1,'The identifier was:\n%s',e.identifier);
                                fprintf(1,'There was an error! The message was:\n%s',e.message);
                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end








                    if(selData(STATISTIC_INDEX. ApEn_LightWeight)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Manish_ApproxEn');


                            m =  str2double(app.editApLWEnM.Value);
                            r=str2double(app.editApLWEnR.Value);
                            %function [apen] = approx_entropy(n,r,a)


                            %% Code for computing approximate entropy for a time series: Approximate
                            % Entropy is a measure of complexity. It quantifies the unpredictability of
                            % fluctuations in a time series

                            % To run this function- type: approx_entropy('window length','similarity measure','data set')

                            % i.e  approx_entropy(5,0.5,a)





                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpR=r*nanstd(currData(isnan(currData(:,i))==0,i));

                                % tmpVal(1,i)=    approx_entropy(m,tmpR,currData(isnan(currData(:,i))==0,i)');
                                tmpVal(1,i)=    Approximate_entropy_lightweight_win(currData(isnan(currData(:,i))==0,i),m,tmpR)
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ApEn_LightWeight} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.ApEn_LightWeight}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                fprintf(1,'The identifier was:\n%s',e.identifier);
                                fprintf(1,'There was an error! The message was:\n%s',e.message);
                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end



                    %% not sure why this is here ??
                    if(selData(STATISTIC_INDEX.ApEn)==1)
                        tic
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Entropy_measures');


                            m =  str2double(app.editApEnM.Value);
                            r=str2double(app.editApEnR.Value);
                            %function [apen] = approx_entropy(n,r,a)


                            %% Code for computing approximate entropy for a time series: Approximate
                            % Entropy is a measure of complexity. It quantifies the unpredictability of
                            % fluctuations in a time series

                            % To run this function- type: approx_entropy('window length','similarity measure','data set')

                            % i.e  approx_entropy(5,0.5,a)





                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpR=r*nanstd(currData(isnan(currData(:,i))==0,i));

                                % tmpVal(1,i)=    approx_entropy(m,tmpR,currData(isnan(currData(:,i))==0,i)');
                                tmpVal(1,i)=    ApEn(currData(isnan(currData(:,i))==0,i),m,tmpR)
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ApEn} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.ApEn}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                fprintf(1,'The identifier was:\n%s',e.identifier);
                                fprintf(1,'There was an error! The message was:\n%s',e.message);
                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end


                    if(selData(STATISTIC_INDEX.ConditionalEntropy_CE)==1)
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Entropy_measures');

                            tic
                            m =  str2double(app.editCE_M.Value);
                            numInt=str2double(app.editCE_NumInt.Value);
                            %function [apen] = approx_entropy(n,r,a)


                            %% Code for computing approximate entropy for a time series: Approximate
                            % Entropy is a measure of complexity. It quantifies the unpredictability of
                            % fluctuations in a time series

                            % To run this function- type: approx_entropy('window length','similarity measure','data set')

                            % i.e  approx_entropy(5,0.5,a)





                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(1,i)=   CondEn(currData(isnan(currData(:,i))==0,i)',m,numInt);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.ConditionalEntropy_CE} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.ConditionalEntropy_CE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)
                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end






                    if(selData(STATISTIC_INDEX.CorrectedConditionalEntropy_CCE)==1)
                        isError = true;
                        try
                            cd('../com/ExternalPackages/Entropy_measures');

                            tic
                            m =  str2double(app.editCE_M.Value);
                            numInt=str2double(app.editCE_NumInt.Value);
                            %function [apen] = approx_entropy(n,r,a)


                            %% Code for computing approximate entropy for a time series: Approximate
                            % Entropy is a measure of complexity. It quantifies the unpredictability of
                            % fluctuations in a time series

                            % To run this function- type: approx_entropy('window length','similarity measure','data set')

                            % i.e  approx_entropy(5,0.5,a)





                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                tmpVal(1,i)=   CorrecCondEn(currData(isnan(currData(:,i))==0,i)',m,numInt);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.CorrectedConditionalEntropy_CCE} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.CorrectedConditionalEntropy_CCE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)
                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end



                    %    SampEn_DS
                    %% m = 1 or 2 [Ronak: 2]; r = 0.15 or 0.25 x SD [Ronak: 2]; ? = 1 (?MAX = 12), N > 750
                    %% sflag= 1 default
                    %sflag = str2double(Param.SAMPLE_ENTROPY.sFlag.Text;
                    %% set cflag = 0 for using SampEn_DS.m instead of cmatches.dll
                    %cflag = str2double(Param.SAMPLE_ENTROPY.cFlag.Text;
                    %% set m = 1 or 2
                    if(selData(STATISTIC_INDEX.SampEn_DS)==1)
                        tic
                        isError = true;
                        try



                            cd('../com/ExternalPackages/DataShare');


                            m =  str2double(app.editSE_M.Value);
                            tau =  str2double(app.editSE_TAU.Value);
                            r=str2double(app.editSE_R.Value);


                            %r=r*nanstd(currData)

                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                tmpR = r*nanstd(currData(isnan(currData(:,i))==0,i)');


                                tmpVal(1,i)=SampEn(currData(isnan(currData(:,i))==0,i)',m,tmpR,tau);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.SampEn_DS} = tmpVal;
                            %%% alternative
                            %%https://uk.mathworks.com/matlabcentral/fileexchange/35784-sample-entropy


                            ComputationTime{currIndex,STATISTIC_INDEX.SampEn_DS}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end





                    if(selData(STATISTIC_INDEX.SampEn_Richman)==1)
                        tic
                        isError = true;
                        try



                            cd('../com/ExternalPackages/SampEn');


                            m =  str2double(app.editSE_M.Value);

                            r=str2double(app.editSE_R.Value);


                            %r=r*nanstd(currData)

                            tmpVal = nan(1,size(currData,2));
                            for i=1:size(currData,2)

                                tmpR = r*nanstd(currData(isnan(currData(:,i))==0,i)');
                                tmpVal(1,i)=sampen(currData(isnan(currData(:,i))==0,i)',m,tmpR,'chebychev');
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.SampEn_Richman} = tmpVal;
                            %%% alternative
                            %%https://uk.mathworks.com/matlabcentral/fileexchange/35784-sample-entropy


                            ComputationTime{currIndex,STATISTIC_INDEX.SampEn_Richman}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end





                    %    CosEn
                    %% coefficient of sample entropy
                    %% cosR
                    if(selData(STATISTIC_INDEX.CosEn_And_QSE)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/DataShare');
                            tic
                            cosR = str2num(app.editCosEn_cosR.Value);



                            m =  str2double(app.editCosEn_M.Value);
                            tau =  str2double(app.editCosEn_TAU.Value);


                            tmpSampEn_DS = nan(1,size(currData,2));
                            for i=1:size(currData,2)
                                r =  cosR * nanstd(currData(:,i));
                                try
                                    tmpSampEn_DS(1,i)=SampEn(currData(isnan(currData(:,i))==0,i)',m,r,tau);
                                catch
                                    x=1;
                                end
                            end


                            %= 0.25  ?? para
                            %r = 0.25;
                            % ???? CHECK
                            %% not sure how to calculate IBI -> Interbeat Interval
                            %r = 0.25;
                            %StatisticCol{currIndex,STATISTIC_INDEX.CosEn} = StatisticCol{currIndex,STATISTIC_INDEX.SampEn_DS}+ log(2*r)-log(mean(currData,1));
                            %StatisticCol{currIndex,STATISTIC_INDEX.CosEn} = StatisticCol{currIndex,STATISTIC_INDEX.SampEn_DS}+ log(2*r)-log(mean(currData,1));
                            StatisticCol{currIndex,STATISTIC_INDEX.CosEn_And_QSE} = tmpSampEn_DS + log(2*r) - log(mean(currData)); %[where xi = IBI or etc.]  r

                            ComputationTime{currIndex,STATISTIC_INDEX.CosEn_And_QSE}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end


%%%%%%%%%%%%%%%%%%%%%%%%   FD Nldwan


                   if(selData(STATISTIC_INDEX.FD_nldwan)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/Fractal_dimension_measures')
                            
                            m   =str2double(app.editFDnldwanWL.Value);

                            tau   =str2double(app.editFDnldwanWS.Value);

                            tic

                            tmpVal = nan(4,size(currData,2));
                            for v=1:size(currData,2)

                                [meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldwan(currData(isnan(currData(:,v))==0,v),m,tau,[]);
                                tmpVal(:,v)= [meanFDiml,stdFDiml,meanFImp,stdFImp]';
                            end


                            scaleInfo='meanFDiml;stdFDiml;meanFImp;stdFImp';


                            StatisticCol{currIndex,STATISTIC_INDEX.FD_nldwan}= tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.FD_nldwan,1}=scaleInfo;
                            ComputationTime{currIndex,STATISTIC_INDEX.FD_nldwan}=toc;



                            clear tmpVal



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
                        ComputationTime{currIndex,STATISTIC_INDEX.FD_nldwan}=toc;
                    end




                               







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                   if(selData(STATISTIC_INDEX.FD_nldian)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/Fractal_dimension_measures')
                            
                            m   =str2double(app.editFDnldianWL.Value);

                            tau   =str2double(app.editFDnldianWS.Value);

                            tic

                            tmpVal = nan(4,size(currData,2));
                            for v=1:size(currData,2)

                                [meanFDiml,stdFDiml,meanFImp,stdFImp] = getNldian(currData(isnan(currData(:,v))==0,v),m,tau,[]);
                                tmpVal(:,v)= [meanFDiml,stdFDiml,meanFImp,stdFImp]';
                            end


                            scaleInfo='meanFDiml;stdFDiml;meanFImp;stdFImp';


                            StatisticCol{currIndex,STATISTIC_INDEX.FD_nldian}= tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.FD_nldian,1}=scaleInfo;
                            



                            clear tmpVal



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
                        ComputationTime{currIndex,STATISTIC_INDEX.FD_nldian}=toc;
                    end







                    %%%%%%%%%%Harikala
                    if(selData(STATISTIC_INDEX.FixedSampEn_fSampEn)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/Fixed SampEn');
                            tic

                            nWindow= str2num(app.editFSampEn_nWindow.Value);
                            factorNSteps= str2double(app.editFSampEn_fNumStep.Value);


                            m =  str2double(app.editFSampEn_M.Value);

                            rFact =  str2double(app.editFSampEn_R.Value);



                            tmpVal = nan(size(currData));
                            for v=1:size(currData,2)

                                tmpData = currData(isnan(currData(:,v))==0,v);
                                rThreshold = rFact*nanstd(tmpData);
                                pSD = nanstd(tmpData);
                                %% floor or ceil ?????
                                pNStep=ceil(factorNSteps*nWindow);
                                kk=fSampEn(tmpData,nWindow,pNStep,m,rThreshold,pSD);
                                tmpVal(1:size(kk,1),v)=fSampEn(tmpData,nWindow,pNStep,m,rThreshold,pSD);
                            end



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
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end

                    %%%%%%%Harikala






                    %%Multiscale Entropy
                    if(selData(STATISTIC_INDEX.mSE)==1)
                        isError = true;
                        try
                            % function mse = ComputeMultiscaleEntropy(data, m, r, maxTau, maxVecSize,cg_moment,cg_method,constant_r)

                            % mse = ComputeMultiscaleEntropy(data, m, r, max_tau,cg_moment)
                            %
                            % Overview
                            %	Calculates multiscale entropy on a vector of input data.
                            %
                            % Input
                            %	data        - data to analyze; vector of doubles
                            %   m           - pattern length; int
                            %   r           - radius of similarity (% of std); double
                            %   maxTau      - maximum number of coarse-grainings; int

                            %cd('../com/ExternalPackages/DataShare');
                            cd('../com/ExternalPackages/PhysioNet-Cardiovascular-Signal-Toolbox-1.0.2/Tools/Entropy_Tools')
                            tic

                            m =  str2num(app.editMSE_M.Value);
                            r = str2double(app.editMSE_R.Value);
                            tau =  str2num(app.editMSE_Tau.Value);





                            tmpVal = nan(tau,size(currData,2));
                            for i=1:size(currData,2)
                                %ComputeMultiscaleEntropy(data, m, r, maxTau, maxVecSize,cg_moment,cg_method,constant_r)
                                tempR=r*nanstd(currData(isnan(currData(:,i))==0,i))

                                tmpVal(:,i)=ComputeMultiscaleEntropy(currData(isnan(currData(:,i))==0,i)',m,tempR,tau);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.mSE} = tmpVal;
                            %%% alternative
                            %%https://uk.mathworks.com/matlabcentral/fileexchange/35784-sample-entropy


                            ComputationTime{currIndex,STATISTIC_INDEX.mSE}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../../../../scripts')
                        end


                    end




                    %function entr = FuzEn_MFs(ts, m, mf, rn, local,tau)
                    % This function calculates fuzzy entropy (FuzEn) of a univariate
                    % signal ts, using different fuzzy membership functions (MFs)%
                    %       Inputs:
                    %               ts     --- time-series  - a vector of size 1 x N (the number of sample points)
                    %               m      --- embedding dimension
                    %               mf     --- membership function, chosen from the follwing
                    %                          'Triangular', 'Trapezoidal', 'Z_shaped', 'Bell_shaped',
                    %                          'Gaussian', 'Constant_Gaussian', 'Exponential'
                    %               rn      --- threshold r and order n (scalar or vector based upon mf)
                    %                          scalar: threshold
                    %                          vector: [threshold r, order n]
                    %               local  --- local similarity (1) or global similarity (0)
                    %               tau    --- time delay
                    %
                    %  Ref.:
                    %  [1]  	H. Azami, P. Li, S. Arnold, J. Escudero, and A. Humeau-Heurtier, "Fuzzy Entropy Metrics for the Analysis
                    %       of Biomedical  Signals: Assessment and Comparison", IEEE ACCESS, 2019.
                    %
                    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    % If you use the code, please make sure that you cite Reference [1]
                    % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    %
                    % Authors:      Peng Li and Hamed Azami
                    %  Emails: pli9@bwh.harvard.edu and hmd.azami@gmail.com
                    %
                    %
                    % For Cr=0.1, the threshold r and order n should be selected as follows:
                    %
                    % 'Triangular'------      rn=0.3
                    % 'Trapezoidal'------     rn=0.1286
                    % 'Z_shaped'------      rn=-2.8691
                    % 'Bell_shaped'------    rn=[0.1414 2] % means r=0.1414 and n=2
                    % 'Bell_shaped'------     rn=[0.1732 3] % means r=0.1732 and n=3
                    % 'Gaussian'------         rn=0.1253
                    % 'Constant_Gaussian'------ rn=0.0903
                    % Exponential------        rn=[0.0077 3] % means r=0.0077 and n=3
                    % Exponential------       rn=[0.0018 4] % means r=0.0018 and n=4
                    %
                    %
                    % Example x=rand(1,1000);FuzEn_MFs(x, 2, 'Bell_shaped', [0.1414*std(x) 2], 0,1)



                    if(selData(STATISTIC_INDEX.FuzzyEntropy_FE)==1)


                        isError = true;
                        try
                            cd('../com/ExternalPackages/FuzzyEntropy_Matlab-master');

                            tic
                            m = str2double(app.editFE_M.Value);
                            % membership function
                            mf = find(strcmp(app.pMenuFE_MF.Items,app.pMenuFE_MF.Value)) ;
                            %% threshold r and order n
                            t=str2double(app.editFE_T.Value);

                            %%local=0 and global=1
                            local = find(strcmp(app.pMenuFE_L.Items,app.pMenuFE_L.Value)) -1;

                            %% time delay
                            tau=str2double(app.editFE_Tau.Value);


                            %% returns vector so stored in seperate variable
                            %ResultRCMSE_STD(epochID,:) = RCMSE_std(currData',m,r,n,tau,scale);
                            %%check multidimensional
                            %% using loop
                            %% there are multidimensional version as well..
                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpRn = t*nanstd(currData(:,i));
                                %FuzEn_MFs(ts, m, mf, rn, local,tau)
                                tmpVal(1,i)= FuzEn_MFs(currData(isnan(currData(:,i))==0,i),m,CONS_FUZZY_ENTROPY.getMembershipFName(mf),tmpRn,local==1,tau);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.FuzzyEntropy_FE} = tmpVal;
                            %StatisticCol{currIndex,STATISTIC_INDEX.RCMSE_SIGMA}  = RCMSE_std(currData',m,r,n,tau,scale);

                            ComputationTime{currIndex,STATISTIC_INDEX.FuzzyEntropy_FE}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end


                    %function [FuzSampEn_trig,Nm]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering)
                    %% Inputs:
                    % data: data to be analyzed. Example: data=wfbm(0.5,1000);
                    % type: kind of isometry ('T': Translation, 'R': vertical Reflexion:, 'I': Inversion, 'G': Glide reflexion.
                    % m: size of the pattern (m-motif). m must be >1.
                    % r: amplitude of the tolerance.
                    % p: power of the membership function. p=2 for gaussian function, p>1000 for rectangular function (classical case).
                    % Centering: Centering=1 for centered patterns and Centering=0 for non centered pattern (classical case)
                    % Output: Fuzzy sample entropy and number of similar m-pattern for a certain type of symmetry.
                    % Example:
                    % data=wfbm(0.5,1000);type='T';m=2;r=std(data)/10;p=1000; Centering=0;
                    % [FSE_T,N_T]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering);
                    % Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
                    % https://www.mdpi.com/1099-4300/20/4/287
                    % - Author:       Jean-Marc Girault
                    % - Date:         07/07/2017



                    if(selData(STATISTIC_INDEX.FuzzyEntropy_CAFE)==1)


                        isError = true;
                        try
                            cd('../com/ExternalPackages/centered and averaged FE');

                            tic
                            m = str2double(app.editFE_CAFE_M.Value);
                            %% threshold r and order n
                            r=str2double(app.editFE_CAFE_R.Value);
                            %% time delay
                            p=str2double(app.editFE_CAFE_P.Value);



                            type = split(app.pMenuFE_CAFE_Type.Value,'-');
                            type = type{1};
                            %local=0 and global=1
                            centering = find(strcmp(app.pMenuFE_CAFE_Centering.Items,app.pMenuFE_CAFE_Centering.Value)) -1;




                            %% returns vector so stored in seperate variable
                            %ResultRCMSE_STD(epochID,:) = RCMSE_std(currData',m,r,n,tau,scale);
                            %%check multidimensional
                            %% using loop
                            %% there are multidimensional version as well..
                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpR=r*nanstd(currData(:,i));
                                %[FuzSampEn_trig,Nm]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering)
                                tmpVal(1,i)= FuzzySampEnt_TRIG(currData(isnan(currData(:,i))==0,i),type,m,tmpR,p,centering);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.FuzzyEntropy_CAFE} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.FuzzyEntropy_CAFE}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end


                    %function varargout = disten(ser, m, tau, B)
                    %DISTEN distribution entropy
                    %
                    % Inputs:
                    %           ser    --- time-series (vector in a column)
                    %           m      --- embedding dimension (scalar)
                    %           tau    --- time delay (scalar)
                    %           B      --- bin number for histogram (scalar)


                    if(selData(STATISTIC_INDEX.DistributionEntropy_DistEn)==1)


                        isError = true;
                        try
                            cd('../com/ExternalPackages/DistEn');

                            tic
                            m = str2double(app.editDE_M.Value);
                            % membership function



                            %% time delay
                            tau=str2double(app.editDE_Tau.Value);


                            B =str2num(app.editDE_B.Value);

                            %% returns vector so stored in seperate variable
                            %ResultRCMSE_STD(epochID,:) = RCMSE_std(currData',m,r,n,tau,scale);
                            %%check multidimensional
                            %% using loop
                            %% there are multidimensional version as well..
                            tmpVal = zeros(1,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(1,i)= disten(currData(isnan(currData(:,i))==0,i), m, tau, B);
                                %tmpVal(1,i)= FuzEn_MFs(currData(isnan(currData(:,i))==0,i),m,CONS_FUZZY_ENTROPY.getMembershipFName(mf),t,local==1,tau);
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.DistributionEntropy_DistEn} = tmpVal;


                            ComputationTime{currIndex,STATISTIC_INDEX.DistributionEntropy_DistEn}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end

                    end

                    if(selData(STATISTIC_INDEX.RCmSE_SD)==1)
                        isError = true;
                        try
                            cd('../com/ExternalPackages/DataShare');
                            tic
                            m = str2double(app.editRCMSEstdM.Value);
                            % r: threshold (it is usually equal to 0.15 of the standard deviation of a signal -
                            %r = str2double(app.editRCMSEstdR.Value).*std(currData,[],1);
                            %% because we normalize signals to have a standard deviation of 1, here, r is usually equal to 0.15)
                            %% if our currData is in windowSlide, it's not normalized ??????
                            % n: fuzzy power (it is usually equal to 2)
                            %n=str2double(app.editRCMSEstdN.Value);
                            % tau: time lag (it is usually equal to 1)
                            tau=str2double(app.editRCMSEstdTau.Value);
                            %Scale: number of scale factors (not critical for RCMSE? - most useful results at values of 5 to 7)
                            scale = str2double(app.editRCMSEstdScale.Value);%STATISTIC_INDEX.RMSE_SCALE;
                            %% using the one defined in DataShare

                            %% returns vector so stored in seperate variable
                            %ResultRCMSE_STD(epochID,:) = RCMSE_std(currData',m,r,n,tau,scale);
                            %%check multidimensional
                            %% using loop
                            %% there are multidimensional version as well..
                            tmpVal = zeros(scale,size(currData,2));
                            for i=1:size(currData,2)
                                r = str2double(app.editRCMSEstdR.Value).*nanstd(currData(:,i),[],1);
                                tmpVal(:,i)= [RCMSE_std(currData(isnan(currData(:,i))==0,i)',m,r,tau,scale)]';
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.RCmSE_SD} = tmpVal;
                            %StatisticCol{currIndex,STATISTIC_INDEX.RCMSE_SIGMA}  = RCMSE_std(currData',m,r,n,tau,scale);

                            ComputationTime{currIndex,STATISTIC_INDEX.RCmSE_SD}=toc;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal;
                            cd('../../../scripts')
                        end




                    end


                    %    RCMFE?    https://DataShare.is.ed.ac.uk/handle/10283/2099


                    %%RCMFE_STD

                    %% Refined composite multiscale fuzzy entropy based on SD (RCMFE?)

                    %
                    %  This function calculates the refined composite multiscale fuzzy entropy (RCMFE) whose coarse-graining uses mean (RCMFE_STD)
                    %
                    %
                    % Inputs:
                    %
                    % x: univariate signal - a vector of size 1 x N (the number of sample points)
                    % m: embedding dimension
                    if(selData(STATISTIC_INDEX.RCmFE_SD)==1)
                        tic

                        isError = true;
                        try



                            cd('../com/ExternalPackages/DataShare');


                            m = str2double(app.editRCMFEstdM.Value);
                            % r: threshold (it is usually equal to 0.15 of the standard deviation of a signal -
                            r = str2double(app.editRCMFEstdR.Value).*nanstd(currData,[],1);
                            %% because we normalize signals to have a standard deviation of 1, here, r is usually equal to 0.15)
                            %% if our currData is in windowSlide, it's not normalized ??????
                            % n: fuzzy power (it is usually equal to 2)
                            n=str2double(app.editRCMFEstdN.Value);
                            % tau: time lag (it is usually equal to 1)
                            tau=str2double(app.editRCMFEstdTau.Value);
                            %Scale: number of scale factors (not critical for RCMFE? - most useful results at values of 5 to 7)
                            scale = str2double(app.editRCMFEstdScale.Value);%STATISTIC_INDEX.RMSE_SCALE;
                            %% using the one defined in DataShare

                            %% returns vector so stored in seperate variable
                            %ResultRCMFE_STD(epochID,:) = RCMFE_std(currData',m,r,n,tau,scale);
                            %%check multidimensional
                            %% using loop
                            %% there are multidimensional version as well..
                            tmpVal = zeros(scale,size(currData,2));
                            for i=1:size(currData,2)
                                tmpVal(:,i)= [RCMFE_std(currData(isnan(currData(:,i))==0,i)',m,r(1,i),n,tau,scale)]';
                            end
                            StatisticCol{currIndex,STATISTIC_INDEX.RCmFE_SD} = tmpVal;
                            %StatisticCol{currIndex,STATISTIC_INDEX.RCMFE_SIGMA}  = RCMFE_std(currData',m,r,n,tau,scale);

                            ComputationTime{currIndex,STATISTIC_INDEX.RCmFE_SD}=toc;



                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal;
                            cd('../../../scripts')
                        end



                    end


                    %    RCMDE
                    %% using the one define in datashare
                    %RCMDE(x,m,c,tau,Scale)
                    %
                    % This function calculates the refined composite multiscale dispersion entropy (RCMDE) of a univariate signal x
                    %
                    % Inputs:
                    %
                    % x: univariate signal - a vector of size 1 x N (the number of sample points)
                    % m: embedding dimension
                    % c: number of classes (it is usually equal to a number between 3 and 9 -
                    if(selData(STATISTIC_INDEX.RCmDE)==1)
                        cd('../com/ExternalPackages/DataShare');
                        tic
                        m=str2double(app.editRCMDE_M.Value);
                        c=str2double(app.editRCMDE_NoC.Value);
                        tau=str2double(app.editRCMDE_Tau.Value);
                        scale=str2double(app.editRCMDE_Scale.Value);
                        % tau: time lag (it is usually equal to 1)
                        % Scale: number of scale factors

                        %StatisticCol{currIndex,STATISTIC_INDEX.RCMDE) = RCMDE(currData',m,c,tau,scale);
                        % ResultRCMDE(epochID,:) = RCMDE(currData',m,c,tau,scale);

                        tmpVal = zeros(scale,size(currData,2));
                        for i=1:size(currData,2)
                            %% there may be case that it donot accept scale and throw error,
                            %% in that case decrease the scale
                            while true
                                try
                                    tmpVal(:,i)= [RCMDE(currData(isnan(currData(:,i))==0,i)',m,c,tau,scale)]';
                                    break
                                catch
                                    scale=scale-1;
                                    if scale <1
                                        break;
                                    end
                                end
                            end
                        end

                        cd('../../../scripts')
                        %StatisticCol{currIndex,STATISTIC_INDEX.RCMDE}=RCMDE(currData',m,c,tau,scale);
                        StatisticCol{currIndex,STATISTIC_INDEX.RCmDE}=tmpVal;
                        clear tmpVal;
                        ComputationTime{currIndex,STATISTIC_INDEX.RCmDE}=toc;
                    end







                    if(selData(STATISTIC_INDEX.SlopeEntropy_SlopeEn)==1)
                        tic
                        m = str2double(app.editSlopeEnM.Value);
                        % gamma is usually between 1 to 2
                        gamma = str2double(app.editSlopeEnGamma.Value);
                        %% delat is vary small, usually 0.001
                        delta=str2double(app.editSlopeEnDelta.Value);

                        addpath('../com/ExternalPackages/Cuesta-frau_SlopeEntropy');
                        %% returns vector so stored in seperate variable
                        %ResultRCMSE_STD(epochID,:) = RCMSE_std(currData',m,r,n,tau,scale);
                        %%check multidimensional
                        %% using loop
                        %% there are multidimensional version as well..
                        tmpVal = zeros(1,size(currData,2));

                        for i=1:size(currData,2)
                            [tmpVal(1,i), ~] = SlopeEntr(currData(isnan(currData(:,i))==0,i),m,gamma,delta);

                            %tmpVal(1,i)= getSlopeEntropy(currData(isnan(currData(:,i))==0,i),m,gamma,delta);
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.SlopeEntropy_SlopeEn} = tmpVal;
                        %StatisticCol{currIndex,STATISTIC_INDEX.RCMSE_SIGMA}  = RCMSE_std(currData',m,r,n,tau,scale);
                        try
                            rmpath('../com/ExternalPackages/Cuesta-frau_SlopeEntropy');
                        catch
                        end
                        ComputationTime{currIndex,STATISTIC_INDEX.SlopeEntropy_SlopeEn}=toc;
                    end


                    if(selData(STATISTIC_INDEX.BubbleEntropy_BE)==1)
                        tic
                        m = str2double(app.editBubbleEnM.Value);


                        addpath('../com/algorithms/bubbleEntropy');
                        %[bEn] = getBubbleEn(x,m,toPrint)
                        tmpVal = zeros(1,size(currData,2));
                        for i=1:size(currData,2)

                            tmpVal(1,i)= getBubbleEn(currData(isnan(currData(:,i))==0,i)',m,false);
                        end
                        StatisticCol{currIndex,STATISTIC_INDEX.BubbleEntropy_BE} = tmpVal;
                        %StatisticCol{currIndex,STATISTIC_INDEX.RCMSE_SIGMA}  = RCMSE_std(currData',m,r,n,tau,scale);
                        try
                            rmpath('../com/algorithms/bubbleEntropy');
                        catch
                        end
                        ComputationTime{currIndex,STATISTIC_INDEX.BubbleEntropy_BE}=toc;
                    end



                    if(selData(STATISTIC_INDEX.SpectralEntropy_SpEn)==1)
                        tic

                        try



                            %StatisticCol{currIndex,STATISTIC_INDEX.FastLomb}=fastlomb(currData,t);
                            for v =1:size(currData,2)
                                tmpVal = [];
                                tmpData = currData(isnan(currData(:,v))==0,v)';
                                ans=pentropy(tmpData,[1:size(tmpData,1)]);
                                if isempty(tmpVal)
                                    tmpVal = zeros(size(ans,1),size(currData,2));
                                end
                                tmpVal(1:size(ans,1),v)=ans;

                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.SpectralEntropy_SpEn} = tmpVal;
                            clear tmpVal
                        catch ME
                            getReport(ME)
                            x=1;
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.SpectralEntropy_SpEn}=toc;
                    end



                    if(selData(STATISTIC_INDEX.FalseNearestNeighbours_FNN)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/RecurrencePlot_ToolBox')

                            mindim=str2num(app.editFracFNN_MinDim.Value);
                            maxdim=str2num(app.editFracFNN_MaxDim.Value);
                            tau=str2double(app.editFracFNN_Tau.Value);
                            rt=str2double(app.editFracFNN_Rt.Value);

                            tmpVal = nan(maxdim-mindim+1,size(currData,2));
                            scaleInfo='';
                            for i=1:size(currData,2)

                                out=false_nearest(currData(isnan(currData(:,i))==0,i),mindim,maxdim,tau,rt);
                                tmpVal(:,i)=out(mindim:maxdim,2);

                            end
                            for i=mindim:maxdim
                                scaleInfo=strcat(scaleInfo,'m-',num2str(i),';');
                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.FalseNearestNeighbours_FNN}=tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.FalseNearestNeighbours_FNN,1}=scaleInfo;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end










                    if(selData(STATISTIC_INDEX.ToneEntropy_T_E)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/ToneEntropy')


                            tau=str2double(app.editToneE_M.Value);


                            tmpVal = nan(2,size(currData,2));
                            scaleInfo='';
                            for i=1:size(currData,2)

                                [a,b]=getMultiLagToneEntropy_Karm(currData(isnan(currData(:,i))==0,i),tau);
                                tmpVal(:,i)=[a(1,end);b(1,end)];

                            end

                            scaleInfo='entropy;tone';


                            StatisticCol{currIndex,STATISTIC_INDEX.ToneEntropy_T_E}=tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.ToneEntropy_T_E,1}=scaleInfo;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%

                    if(selData(STATISTIC_INDEX.FD_C)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/Fractal_dimension_measures/CastiglioniCodes')




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)=FD_C(tmpData,size(tmpData,1));

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.FD_C}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end


                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%

                    if(selData(STATISTIC_INDEX.FD_M)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/Fractal_dimension_measures/CastiglioniCodes')




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)=FD_M(tmpData,size(tmpData,1));

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.FD_M}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555

                    %  D=frdimsigfmc1(rand(100,1),'maxscale',5,'window',3)
                    if selData(STATISTIC_INDEX.mFD_Maragos)==1
                        tic
                        cd('../com/ExternalPackages/MFD_NTUA');

                        try
                            scale=str2num(app.editMultiScaleFD_scale.Value);
                            window = str2num(app.editMultiScaleFD_M.Value);


                            tmpVal= [];
                            %%deepak
                            scaleInfo='';
                            for v=1:size(currData,2)
                                %% frdimsigfmc1(rand(100,1),'maxscale',5,'window',3)
                               % tmpVal(:,v)  = frdimsigfmc1(currData(:,v),'maxscale',scale,'window',window)' ;
                               d = frdimsigfmc1(currData(:,v),'maxscale',scale,'window',window);
                                tmpVal=[tmpVal d];
                                %% chk if we can do this out of for v loop...deepak
                                
                                for i=1:length(d)
                                    if v==1
                                        scaleInfo=strcat(scaleInfo,'d-',num2str(i),';');
                                    end

                                end



                            end

                            StatisticCol{currIndex,STATISTIC_INDEX.mFD_Maragos}=tmpVal   ;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.mFD_Maragos,1}=scaleInfo;

                            ComputationTime{currIndex,STATISTIC_INDEX.mFD_Maragos}=toc;
                            throwME(MException("Go To Finally","Finally"));
                        catch

                            clear tmpVal
                            cd('../../../scripts')
                        end
                    end



                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                    if(selData(STATISTIC_INDEX.FD_K)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/Fractal_dimension_measures/CastiglioniCodes')




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)=FD_K(tmpData);

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.FD_K}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end


                    end

                    if(selData(STATISTIC_INDEX.FD_S)==1)

                        tic

                        isError = true;
                        try


                            %% use from Yang

                            cd('../com/ExternalPackages/Fractal_dimension_measures/CastiglioniCodes')




                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)
                                tmpData = currData(isnan(currData(:,i))==0,i);

                                tmpVal(1,i)=FD_S(tmpData);

                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.FD_S}=tmpVal;


                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%%%%%%%%%%



















                    %function mi = mutual(signal,partitions,tau)
                    %Estimates the time delayed mutual information of the data set
                    %Author: Hui Yang
                    %Affiliation:
                    %The Pennsylvania State University
                    %310 Leohard Building, University Park, PA
                    %Email: yanghui@gmail.com

                    %input: signal - input time series
                    %input: partitions - number of boxes for the partition
                    %input: tau - maximal time delay
                    %output: mi - mutual information from 0 to tau


                    if(selData(STATISTIC_INDEX.AutoMutualInformation_AMI)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/RecurrencePlot_ToolBox')

                            partitions=str2num(app.editMI_Partitions.Value);

                            tau=str2double(app.editMI_TMax.Value);


                            tmpVal = nan(tau+1,size(currData,2));
                            scaleInfo='';
                            for i=1:size(currData,2)

                                tmpVal(:,i)=mutual(currData(isnan(currData(:,i))==0,i),partitions,tau)';


                            end
                            for i=0:tau
                                scaleInfo=strcat(scaleInfo,'tau-',num2str(i),';');
                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.AutoMutualInformation_AMI}=tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.AutoMutualInformation_AMI,1}=scaleInfo;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                    if(selData(STATISTIC_INDEX.LargestLyapunovExp_LLE)==1)

                        tic

                        isError = true;
                        try

                            tic


                            cd('../com/ExternalPackages/LLE_WithRosensteinAlgo_Mirwais')

                            m=str2num(app.editLLE_M.Value);

                            tau=str2double(app.editLLE_Tau.Value);
                            meanperiod=str2double(app.editLLE_MeanPeriod.Value);
                            maxiter=str2double(app.editLLE_Maxiter.Value);


                            tmpVal = nan(maxiter,size(currData,2));
                            scaleInfo='';
                            for i=1:size(currData,2)
                                %%lyarosenstein(x,m,tao,meanperiod,maxiter)
                                % x:signal
                                % tao:time delay
                                % m:embedding dimension
                                tmpVal(:,i)=lyarosenstein(currData(isnan(currData(:,i))==0,i),m,tau,meanperiod,maxiter)';


                            end
                            for i=1:maxiter
                                scaleInfo=strcat(scaleInfo,'Maxiter-',num2str(i),';');
                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.LargestLyapunovExp_LLE}=tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.LargestLyapunovExp_LLE,1}=scaleInfo;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Entropy Hub


                    if(selData(STATISTIC_INDEX.Attention_AttnEn)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/EntropyHub')


                            logx=str2double(app.editAttnE_Logx.Value);



                            for i=1:size(currData,2)
                                %%lyarosenstein(x,m,tao,meanperiod,maxiter)
                                % x:signal
                                % tao:time delay
                                % m:embedding dimension

                                tmpVal(:,i)=AttnEn(currData(isnan(currData(:,i))==0,i),'Logx',logx)';


                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.Attention_AttnEn}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.Attention_AttnEn}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end







                    if(selData(STATISTIC_INDEX.CosineSimilarity_CoSiEn)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/EntropyHub')

                            m=str2num(app.editCosiEN_M.Value);

                            tau=str2double(app.editCosiEN_Tau.Value);
                            r=str2double(app.editCosiEN_R.Value);
                            logx=str2double(app.editCosiEN_Logx.Value);



                            for i=1:size(currData,2)
                                %%lyarosenstein(x,m,tao,meanperiod,maxiter)
                                % x:signal
                                % tao:time delay
                                % m:embedding dimension
                                rVal = r*std(currData(:,i));
                                tmpVal(:,i)=CoSiEn(currData(isnan(currData(:,i))==0,i),'m',m,'tau',tau,'r',rVal,'Logx',logx)';


                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.CosineSimilarity_CoSiEn}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.CosineSimilarity_CoSiEn}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end








                    %%%%------------------------------


                    if(selData(STATISTIC_INDEX.GriddedDistEn_GDistEn)==1)


                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/EntropyHub')

                            m=str2double(app.editGridEN_M.Value);

                            tau=str2double(app.editGridEN_Tau.Value);

                            logx=str2double(app.editGridEN_Logx.Value);



                            for i=1:size(currData,2)
                                %%lyarosenstein(x,m,tao,meanperiod,maxiter)
                                % x:signal
                                % tao:time delay
                                % m:embedding dimension

                                tmpVal(:,i)=GridEn(currData(isnan(currData(:,i))==0,i),'m',m,'tau',tau,'Logx',logx)';


                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.GriddedDistEn_GDistEn}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.GriddedDistEn_GDistEn}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end


                    %%%%%%%%%%%%%%-----

                    if(selData(STATISTIC_INDEX.IncrementEntropy_IncrEn)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/EntropyHub')

                            m=str2double(app.editIncrEN_M.Value);
                            tau=str2double(app.editIncrEN_Tau.Value);
                            r=str2double(app.editIncrEN_R.Value);
                            logx=str2double(app.editIncrEN_Logx.Value);



                            for i=1:size(currData,2)
                                %%lyarosenstein(x,m,tao,meanperiod,maxiter)
                                % x:signal
                                % tao:time delay
                                % m:embedding dimension

                                tmpVal(:,i)=IncrEn(currData(isnan(currData(:,i))==0,i),'m',m,'tau',tau,'R',r,'Logx',logx)';


                            end



                            StatisticCol{currIndex,STATISTIC_INDEX.IncrementEntropy_IncrEn}=tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.IncrementEntropy_IncrEn}=toc;
                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            clear tmpVal
                            cd('../../../scripts')
                        end


                    end




                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%











                    if(selData(STATISTIC_INDEX.ComplexCorrelation_CCM)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/DavidCornforth_HRV')
                            lagK   =str2double(app.editCCM_Lag.Value);



                            tic

                            tmpVal = nan(3,size(currData,2));
                            for v=1:size(currData,2)

                                [tmpVal(2,v),tmpVal(3,v),tmpVal(1,v)] = djcCCM(currData(isnan(currData(:,v))==0,v),lagK);

                            end


                            scaleInfo='CCM;SD1;SD2';


                            StatisticCol{currIndex,STATISTIC_INDEX.ComplexCorrelation_CCM}= tmpVal;
                            ALL_ScaleHeadingCol{STATISTIC_INDEX.ComplexCorrelation_CCM,1}=scaleInfo;
                            ComputationTime{currIndex,STATISTIC_INDEX.ComplexCorrelation_CCM}=toc;



                            clear tmpVal



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
                        ComputationTime{currIndex,STATISTIC_INDEX.ComplexCorrelation_CCM}=toc;
                    end




                    %% olofsen_CPEI
                    if(selData(STATISTIC_INDEX.CPEI_olofsen)==1)
                        isError = true;
                        try

                            cd('../com/ExternalPackages/Olofsen_CPEI')
                            epz   =str2double(app.editCPEI_epz.Value);



                            tic

                            tmpVal = nan(1,size(currData,2));
                            for v=1:size(currData,2)

                                if app.chkUseIntraQuarderRange.Value ==1
                                    %q1 = quantile(currData(isnan(currData(:,v))==0,v),1);
                                    %q3 = quantile(currData(isnan(currData(:,v))==0,v),3);


                                     q = quantile(currData(isnan(currData(:,v))==0,v),[.25 .50 .75]);

                                     epz_v=(q(3)-q(1))*epz;




                                    
                                else
                                    epz_v = epz;

                                end
                                tmpVal(1,v) = CPEI(currData(isnan(currData(:,v))==0,v),epz_v)


                            end

                            %ExternalPackages/Olofsen_CPEI





                            StatisticCol{currIndex,STATISTIC_INDEX.CPEI_olofsen}= tmpVal;

                            ComputationTime{currIndex,STATISTIC_INDEX.CPEI_olofsen}=toc;



                            clear tmpVal



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
                        ComputationTime{currIndex,STATISTIC_INDEX.CPEI_olofsen}=toc;
                    end




                    if(selData(STATISTIC_INDEX.PhaseEntropy_PhEn)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/algorithms')



                            noSector=str2double(app.editPhEnK.Value);


                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)

                                tmpVal(1,i)=getPhEntropyV1_Corrected(currData(isnan(currData(:,i))==0,i),noSector);




                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.PhaseEntropy_PhEn}=tmpVal;
                            clear tmpVal
                            %ALL_ScaleHeadingCol{STATISTIC_INDEX.AutoMutual_Information,1}=scaleInfo;

                            isError = false;
                            throwME(MException("Go To Finally","Finally"));
                        catch e %e is an MException struct
                            if isError
                                getReport(e)

                            end
                            % more error handling...

                            %% moving back
                            cd('../../scripts')
                        end

                        ComputationTime{currIndex,STATISTIC_INDEX.PhaseEntropy_PhEn}=toc;
                    end

%%% multiscale phase entropy

                    if(selData(STATISTIC_INDEX.MultiscalePhEn_mPhEn)==1)

                        tic

                        isError = true;
                        try




                            cd('../com/ExternalPackages/Ashis')



                             noSector=str2double(app.editMPhEnK.Value);
                             scale=str2double(app.editMPhEnScale.Value);

                            tmpVal = nan(1,size(currData,2));

                            for i=1:size(currData,2)

                                tmpVal(1,i)=getMS_PhEntropy_CGData(currData(isnan(currData(:,i))==0,i),noSector,scale);

                                            %getMS_PhEntropy_CGData(data,noSector,scale)


                            end




                            StatisticCol{currIndex,STATISTIC_INDEX.MultiscalePhEn_mPhEn}=tmpVal;
                            clear tmpVal
                            %ALL_ScaleHeadingCol{STATISTIC_INDEX.AutoMutual_Information,1}=scaleInfo;

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

                        ComputationTime{currIndex,STATISTIC_INDEX.MultiscalePhEn_mPhEn}=toc;
                    end







%%%[PhEn] = getMS_PhEntropy_CGData(data,noSector,scale)


                    %         if(selData(STATISTIC_INDEX.EmbeddingDimension)==1) || (selData(STATISTIC_INDEX.FirstCriterionNN)==1) || (selData(STATISTIC_INDEX.SecondCriterionNN)==1)
                    %             tic
                    %
                    %             isError = true;
                    %             try
                    %
                    %
                    %                 %% use from Yang
                    %
                    %                 cd('../com/ExternalPackages/FNN_1')
                    %
                    %
                    %                 m= str2double(app.editFNNMaxM.Value);
                    %                 %StatisticCol{currIndex,STATISTIC_INDEX.FastLomb}=fastlomb(currData,t);
                    %                 tmpVal = nan(3,size(currData,2));
                    %                 for i=1:size(currData,2)
                    %                     [tmpVal(1,i),tmpVal(2,i),tmpVal(3,i)]= fnn(currData(isnan(currData(:,i))==0,i)',m);
                    %                 end
                    %
                    %
                    %
                    %                 StatisticCol{currIndex,STATISTIC_INDEX.EmbeddingDimension}=tmpVal(1,:);
                    %                 StatisticCol{currIndex,STATISTIC_INDEX.FirstCriterionNN}=tmpVal(2,:);
                    %                 StatisticCol{currIndex,STATISTIC_INDEX.SecondCriterionNN}=tmpVal(3,:);
                    %
                    %
                    %                 cTime = toc;
                    %                 ComputationTime{currIndex,STATISTIC_INDEX.EmbeddingDimension}=cTime;
                    %                 ComputationTime{currIndex,STATISTIC_INDEX.FirstCriterionNN}=cTime;
                    %                 ComputationTime{currIndex,STATISTIC_INDEX.SecondCriterionNN}=cTime;
                    %
                    %
                    %
                    %                 isError = false;
                    %                 throwME(MException("Go To Finally","Finally"));
                    %             catch e %e is an MException struct
                    %                 if isError
                    %                     getReport(e)
                    %
                    %                 end
                    %                 % more error handling...
                    %
                    %                 %% moving back
                    %                 clear tmpVal
                    %cd('../../../scripts')
                    %             end
                    %
                    %
                    %         end



                    currIndex=currIndex+1;

                end



                ALL_StatisticCol{fIndex,CONS_INDEX.functionalValues}=StatisticCol;
                %    ALL_StatisticCol{fIndex,CONS_INDEX.outliers}=OutlierInfo;

                %ALL_StatisticCol{fIndex,CONS_INDEX.kMaxHiguchFD}=kMaxHiguchiFD;
                ALL_StatisticCol{fIndex,CONS_INDEX.computationTime} = ComputationTime;
                ALL_StatisticCol{fIndex,CONS_INDEX.fastLombIndex} = FastLombCol;
                ALL_StatisticCol{fIndex,CONS_INDEX.fftIndex} = FFTCol;
                ALL_StatisticCol{fIndex,CONS_INDEX.SpectralEntropy_SpEn} = SpectralEntropyCol;

            end
            %% if save in excel is selected then save the result in excel file as well
            %  if app.chkSaveExcel.Value
            %   if app.rbSaveInMExcel.Value
            %         saveDataInMulSheetExcel(handles,StatisticCol,resultPath,FileName,totalEpoch);
            %         %saveDataInMulSheetExcel(handles,StatisticCol,resultPath,FileName,totalEpoch)
            %         app.editProgressInfoExcel.Value = strcat('Excel File # ',num2str(fIndex),' created out of / ', num2str(size(dbFilesCols,1)),'  .......'));
            %         drawnow
            %   else
            close(f)
        end


    end
end

