

function xdot=duffing(t,x)

global mu c beta a omega

xdot(1)=mu*x(2)-c*x(2)^3-beta*x(1)+a*cos(omega*t);
xdot(2)=x(1);
xdot=xdot';

end

%% parameter derived from A. Ben-Tal Physica D 171 (2002) 236-248
%% collision of two conjugate chaotic attractors
    % mu=10;c=100;beta=1;a=0.848;omega=3.5;
%% explosion of two conjugate chaotic attractors
    %mu=10;c=100;beta=1;a=0.850;omega=3.5;%symmetry
%% explosion of two conjugate period one attractors
    %mu=1;c=1;beta=0.13;a=0.25210;omega=1; 
    %mu=1;c=1;beta=0.13;a=0.25215;omega=1; 
    %mu=1;c=1;beta=0.13;a=0.2522;omega=1; 
%% symmetry restoring of a chaotic attractor results in a symmetric chaotic saddle
    %mu=1;c=1;beta=0.13;a=0.118;omega=1; 
    %mu=1;c=1;beta=0.13;a=0.11839;omega=1;
    %mu=1;c=1;beta=0.13;a=0.1184;omega=1;

%% symmetry restoring of a chaotic saddle results in a symmetric chaotic saddle
    %mu=1;c=1;beta=0.13;a=0.0105;omega=1;
    %mu=1;c=1;beta=0.13;omega=1;a=0.01054