function op1= Model_MACD(price) % return 1, if the model are confirmed; and return 0, if not;
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n=length(price);
if n<=100;
    L=n-1;
else 
    L=100;
end
DIFF=EMA(price,12)-EMA(price,26);
DEA=EMA(DIFF,9);
bar=2*(DIFF-DEA);
s1=0;
s2=0;
s3=0;
sum1=0;
sum2=0;
sum3=0;
op1=0;
if bar(n)<0 && bar(n)>=lowestx(bar(n-3:n-1),1,3);
for i=0:L
    if bar(n-i)<=0
        if s1==0
            sum1=sum1+bar(n-i);
        elseif s2==0
            sum2=sum2+bar(n-i);
        elseif s3==0
            sum3=sum3+bar(n-i);
        end
    elseif bar(n-i)>0
        if s1==0
            s1=1;
        elseif s2==0 && sum2<0
            s2=1;
        elseif s3==0 && sum3<0
            s3=1;
            sum_DEA=sum(DEA(n-i:n)); % the general sum of DEA should be below 0 line;
        end
    end
    if s3==1
        if sum1>sum2 && sum2 >sum3 && sum_DEA<0
            op1=1;
        end
        break;
    end
end
end

