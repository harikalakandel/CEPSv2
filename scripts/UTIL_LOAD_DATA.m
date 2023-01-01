classdef UTIL_LOAD_DATA
    %UTIL_LOAD_DATA Summary of this class goes here
    %   Detailed explanation goes here
    
  
    
    methods(Static)
        
        function loadDataDirectory(app)
            try
                dbDir = app.editDataDir.Value;
                selExt = app.pMenuDbFileExtension.Value;
                
                
                dbFiles  = dir(strcat(dbDir,'/*.',selExt));
                numFiles = size(dbFiles,1);
                
                app.editNumDbFiles.Value = num2str(numFiles);
                if numFiles <=0
                    warndlg('This folder does not include data files like this.Please select another folder or subfolder, or a different file extension.')
                end
            catch
                warndlg('Invalid data folder path');
            end
        end
        
        %% read file from directory
        
        function [data]=loadDataFiles(app,selExt,dbDirectoryPath,fileName)
                if strcmp(selExt,'csv')
                    %% reading the csv files with one heading line..
                    data = csvread( strcat(dbDirectoryPath,'/',fileName),1,0);
                elseif strcmp(selExt,'xlsx')
                    data = xlsread(strcat(dbDirectoryPath,'/',fileName));
                elseif strcmp(selExt,'mat')
                    
                    dataFile = load(strcat(dbDirectoryPath,'/',fileName));
                    try
                        data = dataFile.data;
                    catch
                         fName = fieldnames(dataFile);
                         data = eval(strcat('dataFile.',fName{1}));
                         try
                             data = data{:,:};%% convet table into matrix
                         catch
                         end
                    end
                else
                   data = load(strcat(dbDirectoryPath,'/',fileName));
                   %data = textread(strcat(dbDirectoryPath,'/',fileName),'%s','delimiter','\n','whitespace','','emptyvalue',NaN);
                   
                end
                
             
                
                %app.UITableFileData.Data = data;
                
%                 %%add data name to data loaded table
%                 selTableData = app.uiTableSelectedFiles.Data;
%                 dataN = size(selTableData,1)
%                 
%                 [rowN,colN]=size(data);
%                 selTableData{dataN+1,1}=fileName;
%                 selTableData{dataN+1,2}=rowN;
%                 selTableData{dataN+1,3}=colN;
%                 app.uiTableSelectedFiles.Data= selTableData;
%                 
%                 %% remove from view file table
%                 fileIndex = find(strcmp(app.uiTableFilesName.Data(:,1),selTableData{dataN+1,1}))
%                 app.uiTableFilesName.Data(fileIndex,:)=[];
        end
        
        
        function [data]=truncateEmptyCells(data)
               %%% remove preceding empty cell from data
                minIndex=2*size(data,1);
                maxIndex=-1;
                for i=1:size(data,2)
                    nanList = find(isnan(data));
                    if isempty(nanList)
                        %% do nothing
                    elseif size(nanList,1)==1
                            minIndex=min(minIndex,nanList(1,1));
                            maxIndex=max(maxIndex,nanList(1,1));
                    else
                        tmpMinIndex = nanList(1,1);
                        tmpMaxIndex = nanList(end,1);
                        if (tmpMaxIndex-tmpMinIndex)+1 == size(nanList,1)
                            minIndex=min(minIndex,nanList(1,1));
                            maxIndex=max(maxIndex,nanList(end,1));
                        end
                    end
                end
                
                %%truncate the data.....
                if ~(maxIndex==-1)
                    data(minIndex:end,:)=[];
                end
                
                x=1;
                
        end
        function addLoadedFile(app,fileName,data)
                    [rowN,colN]=size(data);
                    selTableData = app.uiTableSelectedFiles.Data;
                    dataN = size(selTableData,1);
                    selTableData{dataN+1,1}=fileName;
                    selTableData{dataN+1,2}=rowN;
                    selTableData{dataN+1,3}=colN;
                    app.uiTableSelectedFiles.Data= selTableData;
                    
                    %% remove from view file table
                    fileIndex = find(strcmp(app.uiTableFilesName.Data(:,1),selTableData{dataN+1,1}));
                    app.uiTableFilesName.Data(fileIndex,:)=[];
        end
    end
    
    
end

