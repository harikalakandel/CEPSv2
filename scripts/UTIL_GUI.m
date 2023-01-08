classdef UTIL_GUI
    %UTIL_GUI Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Property1
    end

    methods(Static)

        %%get list of all individual ids seperated by comma
        %% in case of range of ids, das (-) is used to provide the range
        %% getIdListFromString('5,6,7-30,55')
        %% will return
        %% [5     6     7     8     9    10    11    12    13    14    15    16
        %% 17    18    19 20    21    22    23    24    25    26    27    28    29
        %% 30    55]
        function [allItemsList]=getIdListFromString(strInfo)
            allItemsList=[];
            if ~isempty(strInfo)
                infoList=strsplit(strInfo,',');
                for index=1:size(infoList,2)
                    tmpItemList=strsplit(infoList{index},'-');
                    %%if range keep adding range
                    if size(tmpItemList,2) > 1
                        startIndex=str2num(tmpItemList{1});
                        endIndex=str2num(tmpItemList{2});
                        allItemsList=[allItemsList startIndex:endIndex];
                    else
                        allItemsList=[allItemsList str2num(tmpItemList{1})];
                    end
                end

            else
                allItemsList=[];
            end
        end

        function [list]=getScaleList(app)
            list=[];
            if find(strcmp(app.pMenuScale.Items,app.pMenuScale.Value))==1
                list=UTIL_GUI.getIdListFromString(app.editScaleRange.Value);
            else
                list = find(strcmp(app.pMenuScale.Items,app.pMenuScale.Value))-1 ;
            end
        end

        function [slideBy] = getSlideBy(app)
            slideBy=[];
            if find(strcmp(app.pMenuScaleSlideBy.Items,app.pMenuScaleSlideBy.Value))>1
                slideBy=str2num(app.pMenuScaleSlideBy.Value);
            else
                slideBy=[1:str2num(app.pMenuScale.Value)];
            end
        end
        function [list]=getDimensionList(app)
            list=[];
            if find(strcmp(app.pMenuDimension.Items,app.pMenuDimension.Value))==1
                list=[];
            elseif find(strcmp(app.pMenuDimension.Items,app.editColumnRange.Value))==2
                list = UTIL_GUI.getIdListFromString(app.pMenuDimension.Value);
            else
                list = find(strcmp(app.pMenuDimension.Items,app.pMenuDimension.Value))-2 ;
            end
        end

        function [list]=getInterpolationList(app)
            selIndex = find(strcmp(app.pMenuIP_Method.Items,app.pMenuIP_Method.Value));

            if selIndex==1
                list = 2:size(app.pMenuIP_Method.Items,2);
            else
                list = selIndex;
            end

        end

        function [list]=getNormazationList(app)
            selIndex = find(strcmp(app.pMenuNormalization.Items,app.pMenuNormalization.Value));
            if selIndex==1
                list = 2:size(app.pMenuNormalization.Items,2);
            else
                list = selIndex;
            end

        end


        function [list]=getFileIDList(app)
            global RawDataSet
            list=[];
            if find(strcmp(app.pMenuFileNames.Items,app.pMenuFileNames.Value))==1
                list=1:size(RawDataSet,1);
            elseif find(strcmp(app.pMenuFileNames.Items,app.pMenuFileNames.Value))==2
                list = UTIL_GUI.getIdListFromString(app.editFileRange.Value);
            else
                list = find(strcmp(app.pMenuFileNames.Items,app.pMenuFileNames.Value))-2 ;
            end
        end


        function [list]=getEpochList(app)
            global epochList
            list=[];
            if find(strcmp(app.pMenuEpochs.Items,app.pMenuEpochs.Value))==1
                list=[];
            elseif find(strcmp(app.pMenuEpochs.Items,app.pMenuEpochs.Value))==2
                fIndex = getFileIDList(app);
                list = epochList{fIndex,1};
            elseif find(strcmp(app.pMenuEpochs.Items,app.pMenuEpochs.Value))==3

                list = UTIL_GUI.getIdListFromString(app.pMenuEpochs.Value);
            else
                list = find(strcmp(app.pMenuEpochs.Items,app.pMenuEpochs.Value))-3 ;
            end
        end




        function[pFound] = chkDependency(toolBoxName,dMessage)

            if nargin <=1
                dMessage=false;

            end

            pFound = false;
            allPackages = ver;

            for i=1:size(allPackages,2)
                if strcmp(toolBoxName,allPackages(i).Name)
                    pFound=true;
                    break;
                end
            end

            if (pFound==false) && dMessage
                msgbox(strcat('Please install toolbox ',toolBoxName));
            end

        end
        function refresh()

        end

        function [oldOutliers]=combineOutliers(data,oldOutliers,newOutliers)
            if isempty(oldOutliers)
                oldOutliers=newOutliers;
                return
            end

            %v oIndex data(oIndex,1) replaceVal
            for i=1:size(newOutliers,1)

                v=newOutliers(i,1);
                pos=newOutliers(i,2);
                oldValue = data(pos,v);
                newValue = newOutliers(i,4);

                index=find(oldOutliers(:,1)==v && oldOutliers(:,2)==pos);
                if ~ isempty(index)
                    oldOutliers(oldOutliers(:,1)==v && oldOutliers(:,2)==pos,4)=newValue;
                else
                    oldOutliers=[oldOutliers;v pos oldValue newValue];
                end
            end

        end


        function loadUnloadTabs(app,strControlName)


            try
                ind = UTIL_GUI.getMyTabIndex(app.TabGroupHidden,strcat(strControlName," I"));
                if ind >0
                    app.TabGroupHidden.Children(ind).Parent = app.TabGroupUpper;
                    app.TabGroupUpper.SelectedTab=app.TabGroupUpper.Children(2);

                end
            catch

            end

        end

        function ind = getMyTabIndex(groupTab,childTabName)
            for ind=1:size(groupTab.Children)
                if strcmp(groupTab.Children(ind).Title,childTabName)
                    return;
                end
            end
            ind = -1;
        end

        function controlFlow(app,  controlMode)

            if controlMode==CONS_CONTROL_FLOW.loadData

                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='on';

                %app.DataFilesTab
                %UTIL_GUI.setVisibleTestBox(app,'off');
                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Load Data');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);


            elseif controlMode==CONS_CONTROL_FLOW.preProcessedAppMode

                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';


                %app.uitableSMeasures.Enable = 'off';
                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                %UTIL_GUI.setVisibleTestBox(app,'off');

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Pre-Process Data');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);

            elseif controlMode==CONS_CONTROL_FLOW.interploateMultiScaleMode

                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Interpolation/Multiscale');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);


            elseif controlMode==CONS_CONTROL_FLOW.paramTest_runPipeLineMode

                %app.uitableSMeasures.Enable = 'on';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Measures');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Test Parameters / Run Pipeline');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);
                % app.pMenuRunMode();
            elseif controlMode==CONS_CONTROL_FLOW.processResults
                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Process Results');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);

                %   UTIL_GUI.loadUnloadTabs(app,"Process Results");
                %app.uitableSMeasures.Enable = 'off';
            elseif controlMode==CONS_CONTROL_FLOW.analysis

                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Analysis');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);



                %app.uitableSMeasures.Enable = 'on';

                %    UTIL_GUI.loadUnloadTabs(app,"Analysis")
                % app.uitableSMeasures.Enable = 'off';
            elseif controlMode == CONS_CONTROL_FLOW.dataAnalysis

                %app.uitableSMeasures.Enable = 'off';
                %app.chkAllMeasures.Enable = 'off';
                app.uiTableFilesName.Enable='off';

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupSelection,'Data Files');
                app.TabGroupSelection.SelectedTab=app.TabGroupSelection.Children(showIndex);

                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupButtom,'Data Analysis');
                app.TabGroupButtom.SelectedTab=app.TabGroupButtom.Children(showIndex);



            end
        end





        function getParamPanelTabView(app)

            %             %% move all panels to hidden
            %             for ind=2:size(app.TabGroupMiddle.Children,1)
            %                 app.TabGroupMiddle.Children(2).Parent = app.TabGroupHidden;
            %             end

            chkSelMeasures = app.uitableSMeasures.Data;
            mc = ?STATISTIC_INDEX;
            %% store the name index (-1)from STATISTIC_INDEX  for those measurement which are selected.
            selTabIndex=[];
            currTabIndex=1;
            for i=1:size(chkSelMeasures,1)
                %% if curent measurement is selected, store its group name index in STATISTIC_INDEX

                try
                    if mc.PropertyList(i).DefaultValue==-1
                        currTabIndex=i;
                    elseif ~isempty(chkSelMeasures{i,2}) & chkSelMeasures{i,2}==1
                        selTabIndex=[selTabIndex,currTabIndex];
                    end
                catch
                    x=1;
                end



            end

            %%selTabIndex is the one with -1
            %% get only unique index
            selTabIndex=unique(selTabIndex);
            %% now get the name of the group from STATISTIC_INDEX

            if ~isempty(selTabIndex)
                for i=1:size(selTabIndex,2)

                    try
                        ind = UTIL_GUI.getMyTabIndex(app.TabGroupHidden,chkSelMeasures{selTabIndex(i),1});

                        app.TabGroupHidden.Children(ind).Parent=app.TabGroupMiddle;
                    catch
                        x=1;
                    end




                end
            end
            try
                %% get the first selection tab in display.
                showIndex=UTIL_GUI.getMyTabIndex(app.TabGroupMiddle,chkSelMeasures{selTabIndex(i),1});
                app.TabGroupMiddle.SelectedTab=app.TabGroupMiddle.Children(showIndex);

            catch ME

            end

        end



        function selData = getStatisticSelData(app)
            chkSelMeasures = app.uitableSMeasures.Data;
            %uit = uitable(app.uiPanelChkStatistic);
            mc = ?STATISTIC_INDEX;
            %% total number of statitistics we going to calculate
            totalNumStatistics = size(mc.PropertyList,1);
            selData=zeros(max([mc.PropertyList.DefaultValue]),1);

            for i=1:totalNumStatistics

                %try catch to avoid seperator
                try
                    if mc.PropertyList(i).DefaultValue~=-1 %&& mc.PropertyList(i).DefaultValue  < 200
                        %selData(mc.PropertyList(i).DefaultValue,1)=chkSelMeasures{i,2};
                        selData(i,1)=chkSelMeasures{i,2};
                    end
                catch
                    x=1;
                end

            end
        end

        function loadParameters(app)
            global dbFileParam
            global Param

            % allItems = app.pMenuFileParam.ItemsData;
            % selectedIndex = find(strcmp(allItems, app.pMenuFileParam.Value)) ;
            % dbFiles = app.pMenuFileParam.Value;

            for fIndex=1:size(dbFileParam,2)
                %dbFileParam(1,fIndex).Attributes.fName
                if(strcmp(dbFileParam(1,fIndex).Attributes.fName,'defaultParam'))
                    Param = dbFileParam(1,fIndex);

                    %%init
                    app.editSampleR.Value = Param.INIT.SampleRate.Text;
                    app.editEpochT.Value = Param.INIT.EpochTimeInSecond.Text;
                    app.editStartT.Value = Param.INIT.StartTimeInSecond.Text;
                    app.editMaxLength.Value = Param.INIT.MaxLengthInSecond.Text;

                    %%outlier

                    app.editOutlierMW.Value = Param.OUTLIERS.MedianW.Text;


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


                    %%Kstest
                    app.editKSLevelOfSig.Value = Param.KSTEST.alpha.Text;
                    app.editKSLevelOfSig_T1.Value = Param.KSTEST.alpha.Text;


                    app.editSW_P.Value = Param.SWTEST.alpha.Text;
                    app.editSW_P_T1.Value = Param.SWTEST.alpha.Text;

                    %% autocovariance
                    app.editAutoCovLagK.Value = Param.AUTO_COVARANCE.lagK.Text;
                    app.editAutoCovLagK_T1.Value = Param.AUTO_COVARANCE.lagK.Text;




                    %%autocorrelation
                    app.editAutoCorrNumLags.Value = Param.AUTO_CORRELATION.numLag.Text;
                    app.editAutoCorrNumLags_T1.Value = Param.AUTO_CORRELATION.numLag.Text;
                    %app.editAutoCorrNumSTD.Value = Param.AUTO_CORRELATION.numSTD.Text;
                    %app.editAutoCorrNumSTD_T1.Value = Param.AUTO_CORRELATION.numSTD.Text;

                    %%need to sort out by deepak
                    %app.pMenuRAMethod.Value=Param.RA_Test.method.Text


                    app.editMWindowM.Value = Param.M_WINDOW.m.Text;
                    app.editMWindowT1.Value = Param.M_WINDOW.t1.Text;
                    app.editMWindowT2.Value = Param.M_WINDOW.t2.Text;
                    app.editMWindowM_T1.Value = Param.M_WINDOW.m.Text;
                    app.editMWindowT1_T1.Value = Param.M_WINDOW.t1.Text;
                    app.editMWindowT2_T1.Value = Param.M_WINDOW.t2.Text;


                    %%% continue from here harikala


                    app.editAlanFactor_nWindow.Value = Param.ALAN_FACTOR_AF.nWindow.Text;
                    app.editAlanFactor_nWindow_T1.Value = Param.ALAN_FACTOR_AF.nWindow.Text;

                    app.editHiguchiFD_KMax.Value = Param.HIGUNCHI_FD.KMax.Text;
                    app.editHiguchiFD_KMax_T1.Value = Param.HIGUNCHI_FD.KMax.Text;


                    app.editCorrDimM.Value = Param.CORRDIM.m.Text;
                    app.editCorrDimLag.Value = Param.CORRDIM.tau.Text;
                    app.editCorrDimM_T1.Value = Param.CORRDIM.m.Text;
                    app.editCorrDimLag_T1.Value = Param.CORRDIM.tau.Text;



                    app.editDFAEmbededDim.Value = Param.DFA.m.Text;
                    app.editDFAOrder.Value = Param.DFA.k.Text;
                    app.editDFAEmbededDim_T1.Value = Param.DFA.m.Text;
                    app.editDFAOrder_T1.Value = Param.DFA.k.Text;



                    app.editRQA_M.Value = Param.RQA.m.Text;
                    app.editRQA_Tau.Value = Param.RQA.tau.Text;
                    app.editRQA_R.Value = Param.RQA.r.Text;
                    app.editRQA_Minline.Value = Param.RQA.minLine.Text;
                    app.editRQA_M_T1.Value = Param.RQA.m.Text;
                    app.editRQA_Tau_T1.Value = Param.RQA.tau.Text;
                    app.editRQA_R_T1.Value = Param.RQA.r.Text;
                    app.editRQA_Minline_T1.Value = Param.RQA.minLine.Text;


                    app.editEPPLag.Value = Param.EPP.K.Text;
                    app.editEPPLag_T1.Value = Param.EPP.K.Text;


                    app.editMLZCScal.Value = Param.M_LZC.scale.Text;

                    app.editAvgSampEn_Profile_M.Value = Param.AvgSampEn_Profile.m.Text;
                    app.editAvgSampEn_Profile_M_T1.Value = Param.AvgSampEn_Profile.m.Text;


                    app.editAvgApEn_Profile_M.Value = Param.AvgApEn_Profile.m.Text;
                    app.editAvgApEn_Profile_M_T1.Value = Param.AvgApEn_Profile.m.Text;


                    app.editLLE_M.Value = Param.LLE.m.Text;
                    app.editLLE_Tau.Value = Param.LLE.tau.Text;
                    app.editLLE_MeanPeriod.Value = Param.LLE.meanperiod.Text;
                    app.editLLE_Maxiter.Value = Param.LLE.maxiter.Text;
                    app.editLLE_M_T1.Value = Param.LLE.m.Text;
                    app.editLLE_Tau_T1.Value = Param.LLE.tau.Text;
                    app.editLLE_MeanPeriod_T1.Value = Param.LLE.meanperiod.Text;
                    app.editLLE_Maxiter_T1.Value = Param.LLE.maxiter.Text;



                    app.editShEn_M.Value = Param.SHANNON_EN.m.Text;
                    app.editShEn_numInt.Value = Param.SHANNON_EN.numInt.Text;
                    app.editShEn_M_T1.Value = Param.SHANNON_EN.m.Text;
                    app.editShEn_numInt_T1.Value = Param.SHANNON_EN.numInt.Text;








                    app.editPJSC_M.Value = Param.Permutation_JS_Complexity.m.Text;
                    app.editPJSC_Tau.Value = Param.Permutation_JS_Complexity.tau.Text;
                    app.editPJSC_M_T1.Value = Param.Permutation_JS_Complexity.m.Text;
                    app.editPJSC_Tau_T1.Value = Param.Permutation_JS_Complexity.tau.Text;

                    %% Tasllis Permutation Entropy
                    app.editPTE_M.Value = Param.Tsallis_Permutation_Entropy.m.Text;
                    app.editPTE_Tau.Value = Param.Tsallis_Permutation_Entropy.tau.Text;
                    app.editPTE_TO.Value = Param.Tsallis_Permutation_Entropy.k.Text;
                    app.editPTE_M_T1.Value = Param.Tsallis_Permutation_Entropy.m.Text;
                    app.editPTE_Tau_T1.Value = Param.Tsallis_Permutation_Entropy.tau.Text;
                    app.editPTE_TO_T1.Value = Param.Tsallis_Permutation_Entropy.k.Text;


                    %% Renyi Permutation Entropy
                    app.editRPE_M.Value = Param.Renyi_Permutation_Entropy.m.Text;
                    app.editRPE_Tau.Value = Param.Renyi_Permutation_Entropy.tau.Text;
                    app.editRPE_RO.Value = Param.Renyi_Permutation_Entropy.k.Text;
                    app.editRPE_M_T1.Value = Param.Renyi_Permutation_Entropy.m.Text;
                    app.editRPE_Tau_T1.Value = Param.Renyi_Permutation_Entropy.tau.Text;
                    app.editRPE_RO_T1.Value = Param.Renyi_Permutation_Entropy.k.Text;



                    %% edit Permutation Entropy
                    app.editEdgePE_M.Value = Param.Edge_PE.m.Text;
                    app.editEdgePE_T.Value = Param.Edge_PE.t.Text;
                    app.editEdgePE_R.Value = Param.Edge_PE.r.Text;
                    app.editEdgePE_M_T1.Value = Param.Edge_PE.m.Text;
                    app.editEdgePE_T_T1.Value = Param.Edge_PE.t.Text;
                    app.editEdgePE_R_T1.Value = Param.Edge_PE.r.Text;




                    app.editToneE_M.Value = Param.TONE_ENTROPY.tau.Text;
                    app.editToneE_M_T1.Value = Param.TONE_ENTROPY.tau.Text;

                    app.editEoD_M.Value = Param.EOD.m.Text;
                    app.editEoD_Shift.Value = Param.EOD.shift.Text;
                    app.editEoD_M_T1.Value = Param.EOD.m.Text;
                    app.editEoD_Shift_T1.Value = Param.EOD.shift.Text;

                    app.editKLD_M.Value = Param.KLD.m.Text;
                    app.editKLD_Shift.Value = Param.KLD.shift.Text;
                    app.editKLD_M_T1.Value = Param.KLD.m.Text;
                    app.editKLD_Shift_T1.Value = Param.KLD.shift.Text;


                    app.editMoChan_M.Value = Param.EN_MOCHAN.m.Text;
                    app.editMoChan_T.Value = Param.EN_MOCHAN.tau.Text;
                    app.editMoChan_M_T1.Value = Param.EN_MOCHAN.m.Text;
                    app.editMoChan_T_T1.Value = Param.EN_MOCHAN.tau.Text;


                    app.editTEntropyQ.Value = Param.TSALLIS_ENTROPY.q.Text;
                    app.editTEntropyQ_T1.Value = Param.TSALLIS_ENTROPY.q.Text;


                    app.editAE_BinSize.Value = Param.AE.binsize.Text;
                    app.editAE_Scale.Value = Param.AE.scale.Text;
                    app.editAE_Min.Value = Param.AE.min.Text;
                    app.editAE_Max.Value = Param.AE.max.Text;
                    app.editAE_BinSize_T1.Value = Param.AE.binsize.Text;
                    app.editAE_Scale_T1.Value = Param.AE.scale.Text;
                    app.editAE_Min_T1.Value = Param.AE.min.Text;
                    app.editAE_Max_T1.Value = Param.AE.max.Text;



                    app.editEE_BinSize.Value = Param.EOE.binsize.Text;
                    app.editEE_Scale.Value = Param.EOE.scale.Text;
                    app.editEE_Min.Value = Param.EOE.min.Text;
                    app.editEE_Max.Value = Param.EOE.max.Text;
                    app.editEE_BinSize_T1.Value = Param.EOE.binsize.Text;
                    app.editEE_Scale_T1.Value = Param.EOE.scale.Text;
                    app.editEE_Min_T1.Value = Param.EOE.min.Text;
                    app.editEE_Max_T1.Value = Param.EOE.max.Text;


                    app.editREntropyQ.Value = Param.RENYI_ENTROPY.q.Text;
                    app.editREntropyQ_T1.Value = Param.RENYI_ENTROPY.q.Text;


                    app.editPEM.Value = Param.M_PE.m.Text;
                    app.editPET.Value = Param.M_PE.tau.Text;
                    app.editPEM_T1.Value = Param.M_PE.m.Text;
                    app.editPET_T1.Value = Param.M_PE.tau.Text;
                    app.editPEScale.Value = Param.M_PE.scale.Text;
                    app.editPEScale_T1.Value = Param.M_PE.scale.Text;


                    app.editAAPEM.Value = Param.AAPE.m.Text;
                    app.editAAPET.Value = Param.AAPE.t.Text;
                    app.editAAPEA.Value = Param.AAPE.a.Text;
                    app.editAAPEM_T1.Value = Param.AAPE.m.Text;
                    app.editAAPET_T1.Value = Param.AAPE.t.Text;
                    app.editAAPEA_T1.Value = Param.AAPE.a.Text;


                    app.editImPEM.Value = Param.IMPE.m.Text;
                    app.editImPET.Value = Param.IMPE.t.Text;
                    app.editImPEScale.Value = Param.IMPE.scale.Text;
                    app.editImPEM_T1.Value = Param.IMPE.m.Text;
                    app.editImPET_T1.Value = Param.IMPE.t.Text;
                    app.editImPEScale_T1.Value = Param.IMPE.scale.Text;




                    app.editMPeM.Value = Param.MPM_E.m.Text;
                    app.editMPeT.Value = Param.MPM_E.t.Text;
                    %app.editMPeScale.Value = Param.MPM_E.scale.Text;
                    app.editMPeM_T1.Value = Param.MPM_E.m.Text;
                    app.editMPeT_T1.Value = Param.MPM_E.t.Text;
                    %app.editMPeScale_T1.Value = Param.MPM_E.scale.Text;


                    app.editApEnM.Value = Param.APPROX_EN.m.Text;
                    app.editApEnR.Value = Param.APPROX_EN.r.Text;
                    app.editApEnM_T1.Value = Param.APPROX_EN.m.Text;
                    app.editApEnR_T1.Value = Param.APPROX_EN.r.Text;


                    app.editApLWEnM.Value = Param.APEn_LW.m.Text;
                    app.editApLWEnR.Value = Param.APEn_LW.r.Text;
                    app.editApLWEnM_T1.Value = Param.APEn_LW.m.Text;
                    app.editApLWEnR_T1.Value = Param.APEn_LW.r.Text;


                    app.editCCM_Min.Value = Param.Cont_CS.min.Text;
                    app.editCCM_Max.Value = Param.Cont_CS.max.Text;
                    app.editCCM_DistSS.Value = Param.Cont_CS.distSS.Text;
                    app.editCCM_Min_T1.Value = Param.Cont_CS.min.Text;
                    app.editCCM_Max_T1.Value = Param.Cont_CS.max.Text;
                    app.editCCM_DistSS_T1.Value = Param.Cont_CS.distSS.Text;





                    app.editCE_M.Value = Param.CONDITIONAL_EN.m.Text;
                    app.editCE_NumInt.Value = Param.CONDITIONAL_EN.numInt.Text;
                    app.editCE_M_T1.Value = Param.CONDITIONAL_EN.m.Text;
                    app.editCE_NumInt_T1.Value = Param.CONDITIONAL_EN.numInt.Text;



                    app.editCorrectedCE_M.Value = Param.CorrectedCE.m.Text;
                    app.editCorrectedCE_NumInt.Value = Param.CorrectedCE.numInt.Text;
                    app.editCorrectedCE_M_T1.Value = Param.CorrectedCE.m.Text;
                    app.editCorrectedCE_NumInt_T1.Value = Param.CorrectedCE.numInt.Text;




                    app.editSE_M.Value = Param.SAMPLE_ENTROPY.m.Text;
                    app.editSE_R.Value = Param.SAMPLE_ENTROPY.r.Text;
                    app.editSE_TAU.Value = Param.SAMPLE_ENTROPY.tau.Text;
                    app.editSE_M_T1.Value = Param.SAMPLE_ENTROPY.m.Text;
                    app.editSE_R_T1.Value = Param.SAMPLE_ENTROPY.r.Text;
                    app.editSE_TAU_T1.Value = Param.SAMPLE_ENTROPY.tau.Text;


                    app.editSE_RH_M.Value = Param.SAMPLE_ENTROPY_R.m.Text;
                    app.editSE_RH_R.Value = Param.SAMPLE_ENTROPY_R.r.Text;
                    app.editSE_RH_M_T1.Value = Param.SAMPLE_ENTROPY_R.m.Text;
                    app.editSE_RH_R_T1.Value = Param.SAMPLE_ENTROPY_R.r.Text;


                    app.editCI_M.Value = Param.COMPLEX_IND.m.Text;
                    app.editCI_M_T1.Value = Param.COMPLEX_IND.m.Text;
                    app.editCI_R.Value = Param.COMPLEX_IND.r.Text;
                    app.editCI_R_T1.Value = Param.COMPLEX_IND.r.Text;
                    app.editCI_Tau.Value = Param.COMPLEX_IND.tmax.Text;
                    app.editCI_Tau_T1.Value = Param.COMPLEX_IND.tmax.Text;


                    app.editCosEn_cosR.Value = Param.COS_EN.cosR.Text;
                    app.editCosEn_cosR_T1.Value = Param.COS_EN.cosR.Text;
                    app.editCosEn_M.Value = Param.COS_EN.m.Text;
                    app.editCosEn_M_T1.Value = Param.COS_EN.m.Text;
                    app.editCosEn_TAU.Value = Param.COS_EN.tau.Text;
                    app.editCosEn_TAU_T1.Value = Param.COS_EN.tau.Text;




                    app.editFSampEn_nWindow.Value = Param.Fixed_SAMP_EN.nWindow.Text;
                    app.editFSampEn_nWindow_T1.Value = Param.Fixed_SAMP_EN.nWindow.Text;
                    app.editFSampEn_fNumStep.Value = Param.Fixed_SAMP_EN.fnstep.Text;
                    app.editFSampEn_fNumStep_T1.Value = Param.Fixed_SAMP_EN.fnstep.Text;
                    app.editFSampEn_M.Value = Param.Fixed_SAMP_EN.m.Text;
                    app.editFSampEn_M_T1.Value = Param.Fixed_SAMP_EN.m.Text;
                    app.editFSampEn_R.Value = Param.Fixed_SAMP_EN.r.Text;
                    app.editFSampEn_R_T1.Value = Param.Fixed_SAMP_EN.r.Text;



                    app.editMSE_M.Value = Param.MSE.m.Text;
                    app.editMSE_M_T1.Value = Param.MSE.m.Text;
                    app.editMSE_R.Value = Param.MSE.r.Text;
                    app.editMSE_R_T1.Value = Param.MSE.r.Text;
                    app.editMSE_Tau.Value = Param.MSE.tau.Text;
                    app.editMSE_Tau_T1.Value = Param.MSE.tau.Text;



                    app.editFE_M.Value = Param.FUZZY_ENTROPY.m.Text;
                    app.editFE_M_T1.Value = Param.FUZZY_ENTROPY.m.Text;
                    app.pMenuFE_MF.Value = app.pMenuFE_MF.Items{str2num(Param.FUZZY_ENTROPY.mf.Text)};
                    app.editFE_T.Value = Param.FUZZY_ENTROPY.rn.Text;
                    app.editFE_T_T1.Value = Param.FUZZY_ENTROPY.rn.Text;
                    app.pMenuFE_L.Value = app.pMenuFE_L.Items{str2num(Param.FUZZY_ENTROPY.local.Text)};
                    app.editFE_Tau.Value = Param.FUZZY_ENTROPY.tau.Text;
                    app.editFE_Tau_T1.Value = Param.FUZZY_ENTROPY.tau.Text;




                    app.editFE_CAFE_M.Value = Param.FUZZY_ENTROPY_CAFE.m.Text;
                    app.editFE_CAFE_M_T1.Value = Param.FUZZY_ENTROPY_CAFE.m.Text;
                    app.pMenuFE_CAFE_Centering.Value = Param.FUZZY_ENTROPY_CAFE.centering.Text;
                    app.editFE_CAFE_R.Value = Param.FUZZY_ENTROPY_CAFE.r.Text;
                    app.editFE_CAFE_R_T1.Value = Param.FUZZY_ENTROPY_CAFE.r.Text;
                    app.pMenuFE_CAFE_Type.Value = Param.FUZZY_ENTROPY_CAFE.type.Text;
                    app.editFE_CAFE_P.Value = Param.FUZZY_ENTROPY_CAFE.p.Text;
                    app.editFE_CAFE_P_T1.Value = Param.FUZZY_ENTROPY_CAFE.p.Text;






                    app.editDE_M.Value = Param.DISTRIBUTION_ENTROPY.m.Text;
                    app.editDE_B.Value = Param.DISTRIBUTION_ENTROPY.binNum.Text;
                    app.editDE_Tau.Value = Param.DISTRIBUTION_ENTROPY.tau.Text;
                    app.editDE_M_T1.Value = Param.DISTRIBUTION_ENTROPY.m.Text;
                    app.editDE_B_T1.Value = Param.DISTRIBUTION_ENTROPY.binNum.Text;
                    app.editDE_Tau_T1.Value = Param.DISTRIBUTION_ENTROPY.tau.Text;





                    app.editRCMSEstdM.Value = Param.RCMSE_STD.m.Text;
                    app.editRCMSEstdR.Value = Param.RCMSE_STD.r.Text;
                    app.editRCMSEstdTau.Value = Param.RCMSE_STD.tau.Text;
                    app.editRCMSEstdScale.Value = Param.RCMSE_STD.scale.Text;
                    app.editRCMSEstdM_T1.Value = Param.RCMSE_STD.m.Text;
                    app.editRCMSEstdR_T1.Value = Param.RCMSE_STD.r.Text;
                    app.editRCMSEstdTau_T1.Value = Param.RCMSE_STD.tau.Text;
                    app.editRCMSEstdScale_T1.Value = Param.RCMSE_STD.scale.Text;



                    app.editRCMFEstdM.Value = Param.RCMFE_STD.m.Text;
                    app.editRCMFEstdR.Value = Param.RCMFE_STD.r.Text;
                    app.editRCMFEstdTau.Value = Param.RCMFE_STD.tau.Text;
                    app.editRCMFEstdN.Value = Param.RCMFE_STD.n.Text;
                    app.editRCMFEstdScale.Value = Param.RCMFE_STD.scale.Text;
                    app.editRCMFEstdM_T1.Value = Param.RCMFE_STD.m.Text;
                    app.editRCMFEstdR_T1.Value = Param.RCMFE_STD.r.Text;
                    app.editRCMFEstdTau_T1.Value = Param.RCMFE_STD.tau.Text;
                    app.editRCMFEstdN_T1.Value = Param.RCMFE_STD.n.Text;
                    app.editRCMFEstdScale_T1.Value = Param.RCMFE_STD.scale.Text;


                    app.editRCMDE_M.Value = Param.RCMDE.m.Text;
                    app.editRCMDE_NoC.Value = Param.RCMDE.c.Text;
                    app.editRCMDE_Tau.Value = Param.RCMDE.tau.Text;
                    app.editRCMDE_Scale.Value = Param.RCMDE.scale.Text;
                    app.editRCMDE_M_T1.Value = Param.RCMDE.m.Text;
                    app.editRCMDE_NoC_T1.Value = Param.RCMDE.c.Text;
                    app.editRCMDE_Tau_T1.Value = Param.RCMDE.tau.Text;
                    app.editRCMDE_Scale_T1.Value = Param.RCMDE.scale.Text;


                    app.editSlopeEnM.Value = Param.SLOPE_EN.m.Text;
                    app.editSlopeEnGamma.Value = Param.SLOPE_EN.gamma.Text;
                    app.editSlopeEnDelta.Value = Param.SLOPE_EN.delta.Text;
                    app.editSlopeEnM_T1.Value = Param.SLOPE_EN.m.Text;
                    app.editSlopeEnGamma_T1.Value = Param.SLOPE_EN.gamma.Text;
                    app.editSlopeEnDelta_T1.Value = Param.SLOPE_EN.delta.Text;


                    app.editBubbleEnM.Value = Param.BUBBLE_EN.m.Text;
                    app.editBubbleEnM_T1.Value = Param.BUBBLE_EN.m.Text;


                    app.editPhEnK.Value = Param.PHASE_EN.k.Text;
                    %                    app.editPhEn_Tau.Value = Param.PHASE_EN.tau.Text;
                    app.editPhEnK_T1.Value = Param.PHASE_EN.k.Text;
                    %                    app.editPhEn_Tau_T1.Value = Param.PHASE_EN.tau.Text;


                    app.editMPhEnK.Value = Param.M_PHASE_EN.k.Text;
                    %                    app.editPhEn_Tau.Value = Param.PHASE_EN.tau.Text;
                    app.editMPhEnK_T1.Value = Param.M_PHASE_EN.k.Text;
                    %                    app.editPhEn_Tau_T1.Value = Param.PHASE_EN.tau.Text;
                    app.editMPhEnScale.Value = Param.M_PHASE_EN.scale.Text;
                    %                    app.editPhEn_Tau.Value = Param.PHASE_EN.tau.Text;
                    app.editMPhEnScale_T1.Value = Param.M_PHASE_EN.scale.Text;
                    %                    app.editPhEn_Tau_T1.Value = Param.PHASE_EN.tau.Text;



                    app.editFracFNN_MinDim.Value = Param.FNN.minDim.Text;
                    app.editFracFNN_MaxDim.Value = Param.FNN.maxDim.Text;
                    app.editFracFNN_Tau.Value = Param.FNN.tau.Text;
                    app.editFracFNN_Tau_T1.Value = Param.FNN.tau.Text;
                    app.editFracFNN_Rt.Value = Param.FNN.rt.Text;
                    app.editFracFNN_Rt_T1.Value = Param.FNN.rt.Text;


                    app.editAFN_BinSize.Value = Param.AFN.binsize.Text;
                    app.editAFN_TMax.Value = Param.AFN.tmax.Text;
                    app.editAFN_BinSize_T1.Value = Param.AFN.binsize.Text;
                    app.editAFN_TMax_T1.Value = Param.AFN.tmax.Text;


                    app.editMI_Partitions.Value = Param.AMI.binsize.Text;
                    app.editMI_TMax.Value = Param.AMI.tmax.Text;
                    app.editMI_Partitions_T1.Value = Param.AMI.binsize.Text;
                    app.editMI_TMax_T1.Value = Param.AMI.tmax.Text;


                    app.editCCM_Lag.Value = Param.CCM.k.Text;
                    app.editCCM_Lag_T1.Value = Param.CCM.k.Text;


                    app.editCosiEN_M.Value = Param.COSI_EN.m.Text;
                    app.editCosiEN_Tau.Value = Param.COSI_EN.tau.Text;
                    app.editCosiEN_R.Value = Param.COSI_EN.r.Text;
                    app.editCosiEN_Logx.Value = Param.COSI_EN.logx.Text;

                    app.editCosiEN_M_T1.Value = Param.COSI_EN.m.Text;
                    app.editCosiEN_Tau_T1.Value = Param.COSI_EN.tau.Text;
                    app.editCosiEN_R_T1.Value = Param.COSI_EN.r.Text;
                    app.editCosiEN_Logx_T1.Value = Param.COSI_EN.logx.Text;


                    app.editAttnE_Logx.Value = Param.ATTN_EN.logx.Text;
                    app.editAttnE_Logx_T1.Value = Param.ATTN_EN.logx.Text;


                    app.editGridEN_M.Value = Param.GRID_EN.m.Text;
                    app.editGridEN_Tau.Value = Param.GRID_EN.tau.Text;

                    app.editGridEN_Logx.Value = Param.GRID_EN.logx.Text;


                    app.editGridEN_M_T1.Value = Param.GRID_EN.m.Text;
                    app.editGridEN_Tau_T1.Value = Param.GRID_EN.tau.Text;

                    app.editGridEN_Logx_T1.Value = Param.GRID_EN.logx.Text;

                    app.editIncrEN_M.Value = Param.INCR_EN.m.Text;
                    app.editIncrEN_Tau.Value = Param.INCR_EN.tau.Text;
                    app.editIncrEN_R.Value = Param.INCR_EN.r.Text;
                    app.editIncrEN_Logx.Value = Param.INCR_EN.logx.Text;

                    app.editIncrEN_M_T1.Value = Param.INCR_EN.m.Text;
                    app.editIncrEN_Tau_T1.Value = Param.INCR_EN.tau.Text;
                    app.editIncrEN_R_T1.Value = Param.INCR_EN.r.Text;
                    app.editIncrEN_Logx_T1.Value = Param.INCR_EN.logx.Text;




                    app.editApLWEnM.Value = Param.APP_E_LIGHT_W.l.Text;
                    app.editApLWEnR.Value = Param.APP_E_LIGHT_W.r.Text;
                    app.editApLWEnM_T1.Value = Param.APP_E_LIGHT_W.l.Text;
                    app.editApLWEnR_T1.Value = Param.APP_E_LIGHT_W.r.Text;

                    app.editCPEI_epz.Value = Param.OLOFSEN_CPEI.epz.Text;
                    app.editCPEI_epz_T1.Value = Param.OLOFSEN_CPEI.epz.Text;

                    app.editCMSE_scale.Value = Param.COMPOSIT_MSE.scale.Text;
                    app.editCMSE_scale_T1.Value = Param.COMPOSIT_MSE.scale.Text;

                    app.editMMSE_scale.Value = Param.MODIFIED_MSE.scale.Text;
                    app.editMMSE_scale_T1.Value = Param.MODIFIED_MSE.scale.Text;




                    app.editFDnldwanWL.Value =  Param.NLDWAN_FD.wl.Text
                    app.editFDnldwanWS.Value =  Param.NLDWAN_FD.ws.Text
                    app.editFDnldwanWL_T1.Value =  Param.NLDWAN_FD.wl.Text
                    app.editFDnldwanWS_T1.Value =  Param.NLDWAN_FD.ws.Text

                    app.editFDnldianWL.Value =  Param.NLDIAN_FD.wl.Text
                    app.editFDnldianWS.Value =  Param.NLDIAN_FD.ws.Text
                    app.editFDnldianWL_T1.Value =  Param.NLDIAN_FD.wl.Text
                    app.editFDnldianWS_T1.Value =  Param.NLDIAN_FD.ws.Text

                    app.editMultiScaleFD_M.Value =  Param.MULTISCALE_FD.window.Text
                    app.editMultiScaleFD_scale.Value =  Param.MULTISCALE_FD.scale.Text
                    app.editMultiScaleFD_M_T1.Value =  Param.MULTISCALE_FD.window.Text
                    app.editMultiScaleFD_scale_T1.Value =  Param.MULTISCALE_FD.scale.Text

                    app.editHRM_Tau.Value =  Param.HRM_MEASURES.tau.Text
                    app.editHRM_Tau_T1.Value =  Param.HRM_MEASURES.tau.Text


                    app.editImPEM.Value =  Param.ORDINAL_EN.order.Text
                    app.editImPET.Value =  Param.ORDINAL_EN.tau.Text
                    app.editImPEScale.Value =  Param.ORDINAL_EN.scale.Text
                    app.editImPEM_T1.Value =  Param.ORDINAL_EN.order.Text
                    app.editImPET_T1.Value =  Param.ORDINAL_EN.tau.Text
                    app.editImPEScale_T1.Value =  Param.ORDINAL_EN.scale.Text


                    app.editSEx_M.Value =  Param.SHANNON_EXTROPY.m.Text
                    app.editSEx_NumInt.Value =  Param.SHANNON_EXTROPY.numInt.Text
                    app.editSEx_M_T1.Value =  Param.SHANNON_EXTROPY.m.Text
                    app.editSEx_NumInt_T1.Value =  Param.SHANNON_EXTROPY.numInt.Text


                    app.editAttnE_Logx.Value =  Param.ATTENTION_EN.logX.Text
                    app.editAttnE_Logx_T1.Value =  Param.ATTENTION_EN.logX.Text


                    app.editPJSC_M.Value =  Param.PJSC.m.Text
                    app.editPJSC_Tau.Value =  Param.PJSC.tau.Text
                    app.editPJSC_M_T1.Value =  Param.PJSC.m.Text
                    app.editPJSC_Tau_T1.Value =  Param.PJSC.tau.Text



                    app.editK_EDD_order.Value =  Param.KALAUZI_EDD.order.Text
                    app.editK_EDD_WS.Value =  Param.KALAUZI_EDD.windowS.Text
                    app.editK_EDD_order_T1.Value =  Param.KALAUZI_EDD.order.Text
                    app.editK_EDD_WS_T1.Value =  Param.KALAUZI_EDD.windowS.Text




                    %working2

                    %  app.editEPPLag.Value = Param.EPP.K.Text;


                    %% not sure why break is here
                    break;
                end
            end
        end


        function setPanelsVisibility(app)
            selData = UTIL_GUI.getStatisticSelData(app);

            app.uiPanelSEntropy1.Visible = selData(STATISTIC_INDEX.SampEn_DS);
            app.uiPanelSEntropy_RH.Visible = selData(STATISTIC_INDEX.SampEn_Richman);
            %app.uiPanelSEntropy2.Visible = selData(STATISTIC_INDEX.SampEn_DS_2))
            %    app.uiPanelSEntropy3.Visible = selData(STATISTIC_INDEX.RCMDE))
            app.uiPanelRCMDE1.Visible = selData(STATISTIC_INDEX.RCmDE);
            %app.uiPanelRCMDE2.Visible = selData(STATISTIC_INDEX.RCMDE_2))
            app.uiPanelImprovedPE.Visible = selData(STATISTIC_INDEX.ImPE);
            app.uiPanelPe.Visible = selData(STATISTIC_INDEX.MultiscalePE_mPE);
            app.uiPanelAAPE.Visible = selData(STATISTIC_INDEX.AmplitudeAware_PE);

            app.uiPaneledgeEntropy.Visible = selData(STATISTIC_INDEX.Edge_PE);
            app.uiPanelShannonEn.Visible = selData(STATISTIC_INDEX.ShannonEntropy_SE);

            app.uiPanelPJSC.Visible = selData(STATISTIC_INDEX.Permutation_JS_Complexity_PJSC);

            app.uiPanelCPEI.Visible = selData(STATISTIC_INDEX.CPEI_olofsen);

            app.uiPanelPermutationTE.Visible = selData(STATISTIC_INDEX.TsallisPE_TPE);
            app.uiPanelRenyiPE.Visible = selData(STATISTIC_INDEX.RenyiPE_RPE);


            app.uiPanelEoD.Visible = selData(STATISTIC_INDEX.EntropyOfDifference_EoD);
            app.uiPanelToneEntropy.Visible = selData(STATISTIC_INDEX.ToneEntropy_T_E);

            app.uiPanelContCM.Visible = selData(STATISTIC_INDEX.Continious_CS);

            app.uiPanelKLD.Visible = selData(STATISTIC_INDEX.KullbachLeiblerDivergence_KLD);

            app.uiPanelAvgApEn_Profile.Visible = selData(STATISTIC_INDEX.AvgApEn_Profile);
            app.uiPanelApEnLw.Visible = selData(STATISTIC_INDEX.ApEn_LightWeight);


            app.uiPanelAvgSampleEn_Profile.Visible = selData(STATISTIC_INDEX.AvgSampEn_Profile);


            app.uiPanelEntropyMoChan.Visible = selData(STATISTIC_INDEX.Entropy_MC);

            %app.uiPanelIMPe3.Visible = selData(STATISTIC_INDEX.IMPE_3))
            app.uiPanelMPme1.Visible = selData(STATISTIC_INDEX.mPM_E);
            app.uipanelFE.Visible = selData(STATISTIC_INDEX.FuzzyEntropy_FE);
            app.uipanelFE_CAFE.Visible = selData(STATISTIC_INDEX.FuzzyEntropy_CAFE);
            app.uiPanelDistributionEn.Visible = selData(STATISTIC_INDEX.DistributionEntropy_DistEn);
            app.uiPanelMSE.Visible = selData(STATISTIC_INDEX.mSE);





            app.uiPanelKS.Visible = selData(STATISTIC_INDEX.KolmogorovSmirnovTest);

            app.uiPanelSW.Visible = selData(STATISTIC_INDEX.ShapiroWilkTest);

            app.uiPanelHFD.Visible = selData(STATISTIC_INDEX.Higuchi_FD);
            app.uiPanelAF.Visible = selData(STATISTIC_INDEX.AlanFactor_AF);

            app.uiPanelCorrDim.Visible = selData(STATISTIC_INDEX.CorrDim_D2);
            app.uiPanelDFA.Visible = selData(STATISTIC_INDEX.DFA);
            app.uiPanelRQA.Visible = selData(STATISTIC_INDEX.RQA);
            app.uiPanelEPP.Visible = selData(STATISTIC_INDEX.ExtendedPoincare_EPP);

            app.uiPanelRCMFESigma.Visible = selData(STATISTIC_INDEX.RCmFE_SD);
            app.uiPanelRCMSESigma.Visible = selData(STATISTIC_INDEX.RCmSE_SD);
            app.uiPanelSlopeEn.Visible = selData(STATISTIC_INDEX.SlopeEntropy_SlopeEn);
            app.uiPanelBubbleEn.Visible = selData(STATISTIC_INDEX.BubbleEntropy_BE);

            app.uiPanelCosEn.Visible = selData(STATISTIC_INDEX.CosEn_And_QSE);
            app.uiPanelFixedSampEn.Visible = selData(STATISTIC_INDEX.FixedSampEn_fSampEn);
            app.uiPanelApEn.Visible = selData(STATISTIC_INDEX.ApEn);

            app.uiPanelConditionalEn.Visible = selData(STATISTIC_INDEX.ConditionalEntropy_CE);
            app.uiPanelCorrectedCE.Visible = selData(STATISTIC_INDEX.CorrectedConditionalEntropy_CCE);
            app.uiPanelM_LZC.Visible = selData(STATISTIC_INDEX.Multiscale_LZC);
            app.uiPanelLLE.Visible = selData(STATISTIC_INDEX.LargestLyapunovExp_LLE);

            app.uiPanelTEntropy.Visible = selData(STATISTIC_INDEX.TsallisEntropy_TE);

            app.uiPanelAverageEntropy.Visible = selData(STATISTIC_INDEX.AverageEntropy_AE);
            app.uiPanelEntropyOfEntropy.Visible = selData(STATISTIC_INDEX.Entropy_of_Entropy_EoE);


            app.uiPanelREntropy.Visible = selData(STATISTIC_INDEX.RenyiEntropy_RE);
            app.uiPanelAutoCov.Visible = selData(STATISTIC_INDEX.AutoCovariance);
            app.uiPanelAutoCorrelation.Visible = selData(STATISTIC_INDEX.AutoCorrelation);
            %% view FNN panel if any of the three measures are selected..
            %viewFNNPanel=max([selData(STATISTIC_INDEX.EmbeddingDimension),selData(STATISTIC_INDEX.FirstCriterionNN),selData(STATISTIC_INDEX.SecondCriterionNN)]);
            %app.uiPanelFFN.Visible = viewFNNPanel);
            app.uiPanelMWindow.Visible = selData(STATISTIC_INDEX.MovingWindowTest);
            app.uiPanelRATest.Visible = selData(STATISTIC_INDEX.ReverseA_Test);

            app.uiPanelFracFNN.Visible = selData(STATISTIC_INDEX.FalseNearestNeighbours_FNN);
            app.uiPanelMI.Visible = selData(STATISTIC_INDEX.AutoMutualInformation_AMI);


            app.uiPanelPhaseEntropy.Visible = selData(STATISTIC_INDEX.PhaseEntropy_PhEn);
            app.uiPanelMScalsePhaseEntropy.Visible = selData(STATISTIC_INDEX.MultiscalePhEn_mPhEn);


            app.uiPanelAFN.Visible = selData(STATISTIC_INDEX.AverageFalseNeighbours_AFN);
            app.uiPanelComplexityIndex.Visible = selData(STATISTIC_INDEX.ComplexityIndex_CI);


            app.uiPanelCCM.Visible = selData(STATISTIC_INDEX.ComplexCorrelation_CCM);


            app.uiPanelFDNldwan.Visible = selData(STATISTIC_INDEX.FD_nldwan);
            app.uiPanelFDNldian.Visible = selData(STATISTIC_INDEX.FD_nldian);




            app.uiPanelIncrEn.Visible = selData(STATISTIC_INDEX.IncrementEntropy_IncrEn);
            app.uiPanelGridEn.Visible = selData(STATISTIC_INDEX.GriddedDistEn_GDistEn);

            app.uiPanelCosiEN.Visible = selData(STATISTIC_INDEX.CosineSimilarity_CoSiEn);
            app.uiPaneAttnEN.Visible = selData(STATISTIC_INDEX.Attention_AttnEn);


            app.uiPanelCompositMSE.Visible = selData(STATISTIC_INDEX.CompositeMsE_CmSE);
            %app.uiPanelMultiS_FD.Visible = selData(STATISTIC_INDEX.CompositeMsE_CmSE);




            app.uiPanelModifiedMSE.Visible = selData(STATISTIC_INDEX.Modified_mSE_MmSE);
            app.uiPanelHRM_Measures.Visible = selData(STATISTIC_INDEX.HRA_PI_GI_AI_SI);  %% ??????????

            %%app.uiPanelModifiedMSE.Visible =   selData(STATISTIC_INDEX.Modified_mSE_MmSE);  ???

            app.uiPanelEDD_Kalauzi.Visible = selData(STATISTIC_INDEX.EEP_Kalauzi);

            app.uiPanelMultiS_FD.Visible =   selData(STATISTIC_INDEX.mFD_Maragos);


            app.uiPanelShannonEx.Visible =   selData(STATISTIC_INDEX.ShannonExtropy_SEx);



        end

        function setVisibleTestBox(app, ON_OFF)

            app.editAutoCovLagK_T1.Visible = ON_OFF;

            app.editAutoCorrNumLags_T1.Visible = ON_OFF;
            %            app.editAutoCorrNumSTD_T1.Visible = ON_OFF;

            app.TextAreaTestInfo.Visible = ON_OFF;

            app.editMWindowM_T1.Visible = ON_OFF;
            app.editMWindowT1_T1.Visible = ON_OFF;
            app.editMWindowT2_T1.Visible = ON_OFF;

            %app.editFNNMaxM_T1.Visible = ON_OFF;

            app.editHiguchiFD_KMax_T1.Visible = ON_OFF;
            app.editAlanFactor_nWindow_T1.Visible = ON_OFF;

            app.editCCM_Lag_T1.Visible = ON_OFF;

            app.editToneE_M_T1.Visible = ON_OFF;
            app.pMenuToneEntropy.Visible = ON_OFF;


            app.editRQA_M_T1.Visible = ON_OFF;
            app.textRQAOutput.Visible = ON_OFF;
            app.pMenuRQAOutput.Visible = ON_OFF;


            app.textEPPOutput.Visible = ON_OFF;
            app.pMenuEEPOutput.Visible = ON_OFF;


            app.editMoChan_M_T1.Visible = ON_OFF;
            app.editMoChan_T_T1.Visible = ON_OFF;


            app.editEPPLag_T1.Visible = ON_OFF;

            app.editAvgApEn_Profile_M_T1.Visible = ON_OFF;

            app.editAvgSampEn_Profile_M_T1.Visible = ON_OFF;



            app.editCorrDimM_T1.Visible = ON_OFF;
            app.editCorrDimLag_T1.Visible = ON_OFF;



            app.editDFAEmbededDim_T1.Visible = ON_OFF;
            app.editDFAOrder_T1.Visible = ON_OFF;


            app.editSE_R_T1.Visible = ON_OFF;
            app.editSE_M_T1.Visible = ON_OFF;
            app.editSE_TAU_T1.Visible = ON_OFF;

            app.editSE_RH_R_T1.Visible = ON_OFF;
            app.editSE_RH_M_T1.Visible = ON_OFF;

            %%Permutation_JS
            app.editPJSC_M_T1.Visible = ON_OFF;
            app.editPJSC_Tau_T1.Visible = ON_OFF;


            %%Tsallis Permutation Entropy
            app.editPTE_M_T1.Visible = ON_OFF;
            app.editPTE_Tau_T1.Visible = ON_OFF;
            app.editPTE_TO_T1.Visible = ON_OFF;

            %%Renyi Permutation Entropy
            app.editRPE_M_T1.Visible = ON_OFF;
            app.editRPE_Tau_T1.Visible = ON_OFF;
            app.editRPE_RO_T1.Visible = ON_OFF;

            %%Renyi Permutation Entropy
            app.editEdgePE_M_T1.Visible = ON_OFF;
            app.editEdgePE_T_T1.Visible = ON_OFF;
            app.editEdgePE_R_T1.Visible = ON_OFF;



            app.editCosEn_cosR_T1.Visible = ON_OFF;
            app.editCosEn_TAU_T1.Visible = ON_OFF;
            app.editCosEn_M_T1.Visible = ON_OFF;

            app.pMenuHRM.Visible = ON_OFF;





            app.txtReverseAMethod_T1.Visible = ON_OFF;
            % if strcat(ON_OF,'off')
            %     app.pMenuRAMethod.Visible = 'on');
            % else
            %     app.pMenuRAMethod.Visible = 'off');
            % end

            app.editFSampEn_nWindow_T1.Visible=ON_OFF;
            app.editFSampEn_fNumStep_T1.Visible = ON_OFF;
            app.editFSampEn_M_T1.Visible = ON_OFF;
            app.editFSampEn_R_T1.Visible = ON_OFF;



            app.editMSE_M_T1.Visible = ON_OFF;
            app.editMSE_R_T1.Visible = ON_OFF;
            app.editMSE_Tau_T1.Visible = ON_OFF;

            app.editRQA_M_T1.Visible = ON_OFF;
            app.editRQA_Tau_T1.Visible = ON_OFF;
            app.editRQA_R_T1.Visible = ON_OFF;
            app.editRQA_Minline_T1.Visible = ON_OFF;
            app.pMenuRQAOutput.Visible = ON_OFF;


            app.editLLE_M_T1.Visible = ON_OFF;
            app.editLLE_Tau_T1.Visible = ON_OFF;
            app.editLLE_MeanPeriod_T1.Visible = ON_OFF;
            app.editLLE_Maxiter_T1.Visible = ON_OFF;


            app.editAE_Max_T1.Visible = ON_OFF;
            app.editAE_Min_T1.Visible = ON_OFF;
            app.editAE_BinSize_T1.Visible = ON_OFF;
            app.editAE_Scale_T1.Visible = ON_OFF;



            app.editEE_Max_T1.Visible = ON_OFF;
            app.editEE_Min_T1.Visible = ON_OFF;
            app.editEE_BinSize_T1.Visible = ON_OFF;
            app.editEE_Scale_T1.Visible = ON_OFF;





            app.editRCMFEstdR_T1.Visible = ON_OFF;
            app.editRCMFEstdM_T1.Visible = ON_OFF;
            app.editRCMFEstdTau_T1.Visible = ON_OFF;
            app.editRCMFEstdScale_T1.Visible = ON_OFF;
            app.editRCMFEstdN_T1.Visible = ON_OFF;


            app.editFE_M_T1.Visible = ON_OFF;
            app.chkFE_MF.Visible = ON_OFF;
            app.editFE_T_T1.Visible = ON_OFF;
            app.chkFE_L.Visible = ON_OFF;
            app.editFE_Tau_T1.Visible = ON_OFF;






            app.editFE_CAFE_M_T1.Visible = ON_OFF;
            app.editFE_CAFE_R_T1.Visible = ON_OFF;
            app.editFE_CAFE_P_T1.Visible = ON_OFF;

            app.chkFE_CAFE_Centering.Visible = ON_OFF;
            app.chkFE_CAFE_Type.Visible = ON_OFF;







            app.editDE_M_T1.Visible = ON_OFF;
            app.editDE_B_T1.Visible = ON_OFF;
            app.editDE_Tau_T1.Visible = ON_OFF;








            %%phase entropy
            app.editPhEnK_T1.Visible = ON_OFF;
            %             app.editPhEn_Tau_T1.Visible = ON_OFF;

            app.editMPhEnK_T1.Visible = ON_OFF;
            app.editMPhEnScale_T1.Visible = ON_OFF;

            app.editImPEM_T1.Visible = ON_OFF;
            app.editImPET_T1.Visible = ON_OFF;
            app.editImPEScale_T1.Visible = ON_OFF;


            app.editRCMDE_M_T1.Visible = ON_OFF;
            app.editRCMDE_NoC_T1.Visible = ON_OFF;
            app.editRCMDE_Tau_T1.Visible = ON_OFF;
            app.editRCMDE_Scale_T1.Visible = ON_OFF;


            app.editRCMSEstdR_T1.Visible = ON_OFF;
            app.editRCMSEstdM_T1.Visible = ON_OFF;
            app.editRCMSEstdTau_T1.Visible = ON_OFF;
            app.editRCMSEstdScale_T1.Visible = ON_OFF;


            app.editMPeM_T1.Visible = ON_OFF;
            app.editMPeT_T1.Visible = ON_OFF;
            %            app.editMPeScale_T1.Visible = ON_OFF;


            app.editAAPEM_T1.Visible = ON_OFF;
            app.editAAPET_T1.Visible = ON_OFF;
            app.editAAPEA_T1.Visible = ON_OFF;


            app.editPEM_T1.Visible = ON_OFF;
            app.editPET_T1.Visible = ON_OFF;
            app.editPEScale_T1.Visible = ON_OFF;

            app.editShEn_M_T1.Visible = ON_OFF;
            app.editShEn_numInt_T1.Visible = ON_OFF;

            app.editEoD_M_T1.Visible = ON_OFF;
            app.editEoD_Shift_T1.Visible = ON_OFF;

            app.editKLD_M_T1.Visible = ON_OFF;
            app.editKLD_Shift_T1.Visible = ON_OFF;



            %app.editMPe2T.Visible = ON_OFF;


            app.editKSLevelOfSig_T1.Visible = ON_OFF;

            app.editSW_P_T1.Visible = ON_OFF;


            app.editTEntropyQ_T1.Visible = ON_OFF;


            app.editREntropyQ_T1.Visible = ON_OFF;
            app.editBubbleEnM_T1.Visible = ON_OFF;

            app.editApEnM_T1.Visible = ON_OFF;
            app.editApEnR_T1.Visible = ON_OFF;

            app.editApLWEnM_T1.Visible = ON_OFF;
            app.editApLWEnR_T1.Visible = ON_OFF;


            app.editCCM_Min_T1.Visible = ON_OFF;
            app.editCCM_Max_T1.Visible = ON_OFF;
            app.editCCM_DistSS_T1.Visible = ON_OFF;



            app.editCE_M_T1.Visible = ON_OFF;
            app.editCE_NumInt_T1.Visible = ON_OFF;


            app.editCorrectedCE_M_T1.Visible = ON_OFF;
            app.editCorrectedCE_NumInt_T1.Visible = ON_OFF;


            app.editSlopeEnM_T1.Visible = ON_OFF;
            app.editSlopeEnGamma_T1.Visible = ON_OFF;
            app.editSlopeEnDelta_T1.Visible = ON_OFF;


            app.editFracFNN_Tau_T1.Visible = ON_OFF;
            app.editFracFNN_Rt_T1.Visible = ON_OFF;

            % app.editPhEnK_T1.Visible = ON_OFF;


            app.editCosiEN_M_T1.Visible = ON_OFF;

            app.editCosiEN_Tau_T1.Visible = ON_OFF;
            app.editCosiEN_R_T1.Visible = ON_OFF;
            app.editCosiEN_Logx_T1.Visible  = ON_OFF;



            app.editAttnE_Logx_T1.Visible  = ON_OFF;




            app.editGridEN_M_T1.Visible  = ON_OFF;
            app.editGridEN_Tau_T1.Visible  = ON_OFF;

            app.editGridEN_Logx_T1.Visible  = ON_OFF;


            app.editIncrEN_M_T1.Visible  = ON_OFF;
            app.editIncrEN_Tau_T1.Visible  = ON_OFF;
            app.editIncrEN_R_T1.Visible  = ON_OFF;
            app.editIncrEN_Logx_T1.Visible  = ON_OFF;


            app.editApLWEnM_T1.Visible  = ON_OFF;
            app.editApLWEnR_T1.Visible  = ON_OFF;

            app.editCPEI_epz_T1.Visible = ON_OFF;

            app.editMI_Partitions_T1.Visible = ON_OFF;
            app.editMI_TMax_T1.Visible = ON_OFF;


            app.editAFN_BinSize_T1.Visible = ON_OFF;
            app.editAFN_TMax_T1.Visible = ON_OFF;

            app.editCMSE_scale_T1.Visible = ON_OFF;
            app.editMMSE_scale_T1.Visible = ON_OFF;

            app.editFDnldwanWL_T1.Visible = ON_OFF;
            app.editFDnldwanWS_T1.Visible = ON_OFF;

            app.editFDnldianWL_T1.Visible = ON_OFF;
            app.editFDnldianWS_T1.Visible = ON_OFF;

            app.editMultiScaleFD_M_T1.Visible = ON_OFF;
            app.editMultiScaleFD_scale_T1.Visible = ON_OFF;

            app.editHRM_Tau_T1.Visible = ON_OFF;


            app.editImPEM_T1.Visible = ON_OFF;
            app.editImPET_T1.Visible = ON_OFF;
            app.editImPEScale_T1.Visible = ON_OFF;


            app.editSEx_M_T1.Visible = ON_OFF;
            app.editSEx_NumInt_T1.Visible = ON_OFF;


            app.editAttnE_Logx_T1.Visible = ON_OFF;


            app.editPJSC_M_T1.Visible = ON_OFF;
            app.editPJSC_Tau_T1.Visible = ON_OFF;

            app.editPJSC_M_T1.Visible = ON_OFF;
            app.editPJSC_Tau_T1.Visible = ON_OFF;

            app.editK_EDD_order_T1.Visible = ON_OFF;
            app.editK_EDD_WS_T1.Visible = ON_OFF;







            %WORKING_1



        end

        function setMSelectionOptions(app,  isTestCase)

            mc = ?STATISTIC_INDEX;
            totalNumStatistics = size(mc.PropertyList,1);
            staticData = app.uitableSMeasures.Data;

            for i=1:totalNumStatistics
                staticData{i,2}='';

            end


            if isTestCase
                msgbox('Running in Test mode. Select only ONE measure from the list.');

                mcIndex = ?STATISTIC_INDEX_TEST;
            else
                mcIndex=mc;
            end

            totalNumStatistics=size(mcIndex.PropertyList,1);

            for i=1:totalNumStatistics
                try
                    % mod(-1,200) gives 199, so avoid it
                    if mcIndex.PropertyList(i).DefaultValue~=-1
                        staticData{ mcIndex.PropertyList(i).DefaultValue,2}=false;

                    end

                catch
                    x=1;
                end
            end
            % end

            app.uitableSMeasures.Data = staticData;
            UTIL_GUI.setPanelsVisibility(app);
        end

        function setEpochList(app,  data, epochWidth, fIndex,epochListString)
            global epochList
            tmpEpochList = UTIL_GUI.getIdListFromString(epochListString);
            N = size(data,1);
            totalEpoch = floor(N /epochWidth);
            if app.chkSingleData.Value ==1
                epochList{fIndex,1}=[1];
            elseif app.chkAllEpoch.Value ==1
                epochList{fIndex,1} = [1:totalEpoch];
            else
                try

                    %num = textscan ( epochTxt, '%f', 'delimiter', ',' );
                    %num = tmpEpochList;
                    epochList{fIndex,1} = tmpEpochList;
                    totalEpoch = size(epochList{fIndex,1},2);
                    for eachEpochID = epochList{fIndex,1}
                        currSIndex = (eachEpochID-1)*epochWidth+1;
                        if    size(data,1) <= currSIndex
                            msgbox(strcat(' Maximum Epoch  in fileID ',num2str(fIndex),' can be ', num2str(eachEpochID)));
                            tmpVal = epochList{fIndex,1};
                            epochList{fIndex,1} = tmpVal(1,tmpVal<eachEpochID);
                            break;
                        end


                    end
                catch
                    epochList{fIndex,1} = [1:totalEpoch];

                end
            end
        end

    end
end