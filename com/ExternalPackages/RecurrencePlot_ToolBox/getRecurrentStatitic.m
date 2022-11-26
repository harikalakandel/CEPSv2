function [rqa_stat] = getRecurrentStatitic(signal,dim,tau,thrhd,linepara)

    %%signal is N by 1
    %% dim 3
    %% tau 8
    y = phasespace(signal,dim,tau);
    recurdata = cerecurr_y(y);
    %% thrhd = 0.3
    recurrpt = tdrecurr_y(recurdata,thrhd);
    rqa_stat = recurrqa_y(recurrpt,linepara)

end

