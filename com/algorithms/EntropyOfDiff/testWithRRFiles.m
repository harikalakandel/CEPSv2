
%%test Case...
%x=ceil(rand(100000,1)*100);

dbFiles=dir('../../../Data/SampleData/RR_Data/*.txt')
EDim_N=10;
SHIFT_N=1;

EDCol={};

KLCol={};


for i=1:size(dbFiles,1)
    data=load(strcat('../../../Data/SampleData/RR_Data/',dbFiles(i).name));
    
    %%adding small amount of white noise
    x=data+rand(size(data,1),1)*10^(-5);
    
    tmpEDCol=nan(SHIFT_N,EDim_N);
    tmpKLCol=nan(SHIFT_N,EDim_N);
    %data = [   85    16    91    92    83    70    58    10    98    56    71    28    14    93    43    75    17    44    36    79    94    48    22    40    27];
    
    allResults=nan(5,5);
    
    %%getEntropyOfDiff(x,2,1)
    fprintf('\nEntropy of Differences .............\n\n');
    fprintf('\n Shift\t \t\t m=2 \t\t m=3 \t\t m=4 \t\t m=5 \t\t m=6')
    for shift=1:SHIFT_N
        fprintf('\n %f\t\t',shift)
        for m =2:EDim_N
            
            ans1 = getEntropyOfDiff(x,m,shift);
            fprintf('%f\t',ans1)
            tmpEDCol(shift,m)=ans1;
        end
    end
    
    fprintf('\n\n\n......KL Diverse.................')
    
    
    fprintf('\n Shift\t \t\t m=2 \t\t m=3 \t\t m=4 \t\t m=5 \t\t m=6')
    for shift=1:SHIFT_N
        fprintf('\n %f\t\t',shift)
        for m =2:EDim_N
            
            [~,ans1] = getEntropyOfDiff(x,m,shift);
            fprintf('%f\t',ans1)
            tmpKLCol(shift,m)=ans1;
        end
    end
    
    EDCol{i,1}=tmpEDCol;
    KLCol{i,1}=tmpKLCol;
end

%% graph
%% shift = 1
for i=1:size(dbFiles,1)
    fig=figure(i)
    tmpED = EDCol{i,1}
    tmpKL = KLCol{i,1}
    plot(tmpED(1,:),'color','green')
    hold on
    plot(tmpKL(1,:),'color','blue')
    xlabel('Embedded Dimension(m)')
    legend({'ED','KL'})
   
   set(fig,'Name',dbFiles(i).name);
end


