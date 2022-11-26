function [x] = reDimPreserve(x,val,index)

    if size(x,2)<index
        nk = index-size(x,2);
        x=[x nan(1,nk)];
    end
    x(1,index)=val;

end

