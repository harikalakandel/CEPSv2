function [ output_args ] = writeToDiffExcelSheet( dataInCell,sheetHeading,fileName )


    
    for i=1:size(dataInCell,1)
        xlswrite(fileName, dataInCell{i,1},i);
    end

end

