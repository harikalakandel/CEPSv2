
%%test Case...
%x=ceil(rand(100000,1)*100);
data = [   85    16    91    92    83    70    58    10    98    56    71    28    14    93    43    75    17    44    36    79    94    48    22    40    27];
x=data';
allResults=nan(5,5);

%%getEntropyOfDiff(x,2,1)
fprintf('\nEntropy of Differences .............\n\n');
fprintf('\n Shift\t \t\t m=2 \t\t m=3 \t\t m=4 \t\t m=5 \t\t m=6')
for shift=1:5
    fprintf('\n %f\t\t',shift)
    for m =2:6
        
        ans1 = getEntropyOfDiff(x,m,shift);
        fprintf('%f\t',ans1)
    end
end

fprintf('\n\n\n......KL Diverse.................')


fprintf('\n Shift\t \t\t m=2 \t\t m=3 \t\t m=4 \t\t m=5 \t\t m=6')
for shift=1:5
    fprintf('\n %f\t\t',shift)
    for m =2:6
        
        [~,ans1] = getEntropyOfDiff(x,m,shift);
        fprintf('%f\t',ans1)
    end
end