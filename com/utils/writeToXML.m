%https://blogs.mathworks.com/community/2010/09/13/simple-xml-node-creation/
function [a] = writeToXML( fileName,data )
    docNode = com.mathworks.xml.XMLUtils.createDocument('Param');
    for pID=1:size(data,1)
        entry_node = docNode.createElement(data{pID,1});
        docNode.getDocumentElement.appendChild(entry_node);

        paramInfo =data{pID,2};
        for i=1:size(paramInfo,1)
            info_node = docNode.createElement(paramInfo{i,1});
            %thisElement = docNode.createElement(paramInfo{i,1}); 
            %thisElement.appendChild(docNode.createTextNode(paramInfo{i,2}));
            info_node.appendChild(docNode.createTextNode(paramInfo{i,2}));
            entry_node.appendChild(info_node);
        end
        xmlwrite(char(fileName),docNode);
    end

%data={{'INIT'},{{'sampleRate'},{'200'};{'id'},{'56'}};{'INIT1'},{{'sampleRate1'},{'2001'};{'id1'},{'561'}}}