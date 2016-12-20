function op1=test0  %% not complete modification.

global open high low close vol;
op1=0;
L=length(high);

if close(L-1)>close(L-2)&&close(L-1)<low(L-1)+(high(L-1)-low(L-1))/2 && close(L-1)<open(L-1)&& high(L)>high(L-1)%close(L-1)<low(lowest(L-6,L-2)) && high(L)>high(L-1) && vol(L-1)>mean(vol(L-4:L-2))
    op1=high(L-1);
end
end