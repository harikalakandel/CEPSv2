function [ans] = changeToBinary(X)
    X1 = X(1:end-1,:);
    X2 = X(2:end,:);

    ans = X1 > X2;
    ans = (ans*2)-1
end

