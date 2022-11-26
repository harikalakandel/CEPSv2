% Perform a rank-order test: sort [To;Ts(:)] and return the rank of To
%
% Usage: r = ranktest (To, Ts);

function r = ranktest (To, Ts);

[DUM IND1] = sort ([To;Ts(:)]);
r = find (IND1==1);
