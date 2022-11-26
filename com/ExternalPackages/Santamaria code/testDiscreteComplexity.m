files = dir('../../../Data/SampleData/RR_Data/*.txt');

for f = 1:1%size(files,1)
    data = load(strcat('../../../Data/SampleData/RR_Data/',files(f).name));
    
    [ emergence, selfOrganization, complexity, varargout ] = DiscreteComplexityMeasures( data )
    [emergence, selfOrganization, complexity, varargout ] = ContinuousComplexityMeasures(data,2,6,2 )
end