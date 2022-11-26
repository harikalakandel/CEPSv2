function [frameSize] = getSamplingRate(fileName)
    frameSize = 1024;
    LIST_WITH_2048Hz = {'BA_a_25_','BA_d_0_','BB_a_0_','BB_b_80_','BC_a_80_','BD_a_80_'}
    if contains(fileName,LIST_WITH_2048Hz)
       frameSize = 2048;
    end
end

