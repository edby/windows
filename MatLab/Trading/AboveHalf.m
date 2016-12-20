function re=AboveHalf(len)
global high low close;
L=length(high);
L0=lowest(L-len,L);
H0=highest(L-len,L);
if (high(H0)-low(L0))/2+low(L0)<close(L)
    re=1;
else
    re=0;
end