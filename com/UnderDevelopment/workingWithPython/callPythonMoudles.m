%% check python environment
try
    pyenv  %only work after 2019b
catch
    pyversion   % defined in older version
end

%kk=py.testMe.addMe(5,6)


res = pyrunfile("pythonScripts.py","z",x=3,y=2)