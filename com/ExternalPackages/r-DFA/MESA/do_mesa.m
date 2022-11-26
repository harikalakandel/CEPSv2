function do_mesa
% generate and plot MESA analysis (Dusty, Burg, et al.) using current
% global data and settings from HARP

%%(C)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C)Jeffrey Hall Lab, Brandeis University.             %%
% Use and distribution of this software is free for academic      %%
% purposes only, provided this copyright notice is not removed.   %%
% Not for commercial use.                                         %%
% Unless by explicit permission from the copyright holder.        %%
% Mailing address:                                                %%
% Jeff Hall Lab, Kalman Bldg, Brandeis Univ, Waltham MA 02454 USA %%
% Email: hall@brandeis.edu                                        %%
%%(C)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MESA_ORDER
global MESA_FROM
global MESA_TO
global MESA_FUN

global MIN_PER_BIN

x = cleanup;

[y,tau] = per_mesa(x, MIN_PER_BIN, MESA_FUN, MESA_ORDER);

setup

plot(tau, y)

maketitle(MESA_FUN)

set(gca, 'XLim', [MESA_FROM MESA_TO])

pkreport(tau, y, MESA_FROM, MESA_TO)
