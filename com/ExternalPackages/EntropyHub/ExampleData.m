function [X] = ExampleData(SigName)

p = inputParser;
Chk = {'uniform','uniform2','randintegers2','randintegers',...
    'henon','chirp','gaussian','gaussian2','lorenz',...
    'uniform_Mat', 'gaussian_Mat', 'entropyhub_Mat',...
    'mandelbrot_Mat','randintegers_Mat'};

addRequired(p,'SigName',@(x) ischar(x) && any(validatestring(lower(x),Chk)));
parse(p,SigName)
Temp = webread(['https://raw.githubusercontent.com/MattWillFlood/EntropyHub/main/ExampleData/' ...
    SigName '.txt'],'table','text/csv');

if strcmpi(SigName,'henon') || endsWith(SigName, '2')
    Temp2 = textscan(Temp,'%f %f','HeaderLines',2);
    X = [Temp2{1} Temp2{2}];
elseif strcmpi(SigName,'lorenz')
    Temp2 = textscan(Temp,'%f %f %f','HeaderLines',2);
    X = [Temp2{1} Temp2{2} Temp2{3}];
elseif endsWith(SigName, '_Mat')
    Temp2 = textscan(Temp,repmat('%f ',1,128),'HeaderLines',2, ...
    'EndOfLine','\r\n');
    Temp3 = cell2mat(Temp2);
    X = Temp3(:,~isnan(sum(Temp3,1)));    
else
    Temp2 = textscan(Temp,'%f','HeaderLines',2);
    X = Temp2{1};
end

end