function EMAValue=EMA(Price,Length)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
EMAValue=zeros(length(Price),1);
K=2/(Length+1);
for i=1:length(Price)
    if i==1
        EMAValue(i)=Price(i);
    else 
        EMAValue(i)=Price(i)*K+EMAValue(i-1)*(1-K);
    end
end
end

