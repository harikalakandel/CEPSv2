
%open file identifier

for i=1:size(data,2)
   currData = data(:,i);
  % currData(isnan(currData),:)=[];
   writecell(num2cell(currData),strcat('File_',num2str(i)));
   disp(i)
   
end
