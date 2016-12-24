function op1 = Model_SuddenDown( IDName,n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
op1=0;
global open high low close;
if nargin==2
    L=n;
else
    L=length(high);
end

h=high(highest(L-2,L));
if (h-low(L))/h >0.07 && L>20
    for i=14:-1:4
        H1=highest(L-i,L);
        L1=lowest(L-i,H1);
        if H1>L-i-3 && low(L1)==low(lowest(L1-6,H1)) && H1-L1>=2 && L-H1>=2 && low(L)==low(lowest(H1,L))
            for j=L1+1:H1
            if high(j)<high(j-1) && low(j)<low(j-1)
                break;
            end
            end
            if j==H1 && low(L)>low(L1)&& (low(L)-low(L1))/low(L1)-0.015 <=0
                op1=1;
                if nargin==1
                    srsz=get(0,'ScreenSize');
                    figure('Position',[srsz(3)/8,srsz(4)/8,srsz(3)*3/4,srsz(4)*3/4]);
                    subplot(3,1,[1,2]);
                    Kplot(open,high,low,close);
                    title(IDName);
                    grid on;
                    hold on;
                    plot([L1;H1;L],[low(L1);high(H1);low(L)]);
                    subplot(3,1,3);
                    MACD(close);
                end
                break;
            end
        end
    end
end
end

