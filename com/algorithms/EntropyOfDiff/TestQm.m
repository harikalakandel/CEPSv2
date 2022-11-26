for m=1:5
    allCombination =npermutek([1,-1],m);
    fprintf('\n-------------------------------------------------------------------------',m)
    fprintf('\n------------------------------ m     %.0d--------------------------------\n',m)
    for i=1:size(allCombination,1)
        ans=Qm(allCombination(i,:));
        disp([allCombination(i,:) ans]);
    end
end