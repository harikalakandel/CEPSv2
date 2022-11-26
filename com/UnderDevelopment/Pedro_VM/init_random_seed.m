% !**************** initializes random number generator ******************
% !**************** using system clock                  ******************
% subroutine init_random_seed()
function[]=init_random_seed()
    %init_random_seed
    %integer::i,n,clock
    %integer,dimension(:),allocatable::seed

    %% ???
    %%call random_seed(size=n)
    %%??
    %%allocate(seed(n))
    %%??
    %%call system_clock(count=clock)
    %seed=clock+37*(/ (i-1, i=1, n) /)
    %%seed=clock+37*(/ (i-1, i=1, n) /)
    %%???
    %%call random_seed(put=seed)
    %%??
    %%deallocate(seed)
    %%return
    %%end subroutine init_random_seed    
%%!***********************************************************************
%%end
end
    
