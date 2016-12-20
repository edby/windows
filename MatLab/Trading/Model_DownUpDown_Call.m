function bars_len=Model_DownUpDown_Call % back forward is less than half of current up forward
global high low vol;
bars_len=0;
L=length(high);
X(5)=0;
if low(L)<=low(lowest(L-5,L))
    kline=0;
    for j=3:20
        if L-ceil(3*j/2)<=0
            break;
        else
            flag=0;
        end
        if high(L-j)>=high(highest(L-ceil(3*j/2),L))
            for jj=L-3*j-3:L-j-1
                if jj-ceil(3*j/2)<=0
                    flag=1;
                    break;
                end
                if low(jj)<=low(lowest(jj-ceil(j/2),L-j)) && high(highest(jj-j-1,jj-j+1))>=high(highest(jj-ceil(3*j/2),L))...
                        && low(L)<=low(lowest(jj-j,L)) 
                    H1=highest(jj-j-1,jj-j+1);
                    L1=lowest(jj-1,jj+1);
                    H2=highest(L-j-1,L-j+1);
                    Bar0=4*(L-H1); % Bar0 is back forward's start point;
                    if L<Bar0
                        Bar0=L-1;
                    end
                    if (high(H1)-low(L1))/(L1-H1)>=(high(H2)-low(L))/(L-H2) && AboveHalf(Bar0)
                        kline=kline+1;
                        X(kline)=L-highest(jj-j-1,jj-j+1);
                    end
                end
            end
        end
        if flag==1
            break;
        end
    end
    bars_len=X;
end
end