
                selFileIndex = find(strcmp(app.pMenuFileNames_RS.Items,app.pMenuFileNames_RS.Value));
                if selFileIndex == 1
                    msgbox('Please select one of the file');
                    return;                
                end
    
                selExt = app.pMenuFileExtention_RS.Value;
                dbDirectoryPath = app.editFileLocation_RS.Value;
                fileName=app.pMenuFileNames_RS.Value;
                data = UTIL_LOAD_DATA.loadDataFiles(app,selExt,dbDirectoryPath,fileName);
                if size(data,2) <2
                    msgbox('Data file have only one column, required at least two columns');
                    return
                else
                    data = data(:,1:2);
                end
    
                if find(strcmp(app.pMenuTimeType.Items,app.pMenuTimeType.Value))==2
                    currSum=data(1,1);
                    for i=2:size(data,1)
                        currSum = currSum+data(i,1);
                        data(i,1)=currSum;
                    end
                else
                    if sum(data(2:end,1)<data(1:end-1,1)) > 1
                        msgbox('Time interval is not cummulative, so please choose interval')
                        return
                    end
                end
                
                sampleFs=str2num(app.editSampleFS_DM.Value);

                if app.chkResamplingFreq.Value ==1
                    desiredFs = str2num(app.editResamplingFreq.Value);
                else
                    desiredFs =  size(data,1)/data(end,1);
                end

                methodID = find(strcmp(app.pMenuInterpolation_DM.Items,app.pMenuInterpolation_DM.Value));
                allMethodList = {'linear', 'pchip', 'spline'};

               



                if app.chkEndpointEffect.Value ==1
                    [p,q] = rat(desiredFs/sampleFs);
                    % ensure an odd length filter
                    n = 10*q+1;
                    % use .25 of Nyquist range of desired sample rate
                    cutoffRatio = str2double(app.editCutOffRatio.Value);
                    % construct lowpass filter 
                    lpFilt = p * fir1(n, cutoffRatio * 1/q);
                    [y, Ty] = resample(data(:,2),data(:,1),desiredFs,allMethodList{methodID},p,q,lpFilt);
                else
                    [y, Ty] = resample(data(:,2),data(:,1),desiredFs,allMethodList{methodID});
                 end


    
                app.PanelChk.AutoResizeChildren='off';

                t=tiledlayout(app.PanelChk,1,1);
                ax1=nexttile(t);

    
                
              %  ax1= plot('Parent',app.PanelChk);
                % plot(ax1,data)
    
               


                plot(ax1,data(:,1),data(:,2),'.-',Ty,y,'o-');


        



    
    
    
    
                legend(ax1,{'Original','Resampled'});
                
    
    
               % catch e
                    
                   % msgbox('Something wrong.....')
             %   end