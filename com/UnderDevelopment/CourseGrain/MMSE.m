function E = MMSE(data, scale)
r = 0.15*std(data);
for i = 1:scale
    buf = movingaverage(data, i);
    %E(i) = SampEn2(buf,r,i);
    E(i) = SampEn(buf,r,i);
end
% moving average procedure. See Eq. (9)
% data: input signal; s: scale numbers ;S.-D. Wu et al. / Physica A 392 (2013) 5865–5873

function data = movingaverage(data,s)
N = length(data);
for i = 1:N - s + 1
    data(i) = mean(data(i:i + s - 1));
end
%function to calculate sample entropy with delay.
function entropy = SampEn(data,r,delay)
N = length(data);
Nn = 0;
Nd = 0;
for i = 1:N - 3*delay
    for j = i + delay:1:N - 2*delay
        if abs(data(i)-data(j)) < r && abs(data(i + delay)-data(j + delay)) < r
            Nn = Nn + 1;
            if abs(data(i + 2*delay)-data(j + 2*delay)) < r
                Nd = Nd + 1;
            end
        end
    end
end
entropy = - log(Nd/Nn);