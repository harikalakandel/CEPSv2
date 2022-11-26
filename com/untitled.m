s=xml2struct('DevelopmentList.xml')
fn=fieldnames(s.Measurements)
for i=1:size(fn,1)
	nodeStruct=eval(strcat('s.Measurements.',fn{i}))
	childFn = fieldnames(nodeStruct)
	for j=1:size(childFn,1)
	   node = eval(strcat('nodeStruct.',childFn{j}))
	   str2num(node.Text)
	end
end