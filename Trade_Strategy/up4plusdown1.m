function op=up4plusdown1(varargin) 
stock=varargin{1};
w=windmatlab;
rawData=w.wsd(stock,'open,high,low,close,volume','2000-01-01',today-1,'Fill=Previous','PriceAdj=F');
open=rawData(:,1);
indTem=sum(isnan(open))+1;
open=open(indTem:end);
high=rawData(indTem:end,2);
low=rawData(indTem:end,3);
close=rawData(indTem:end,4);
vol=rawData(indTem:end,5);
L=length(open);
x=zeros(1,L);
y=zeros(1,L);
results=zeros(1,L);
j=1;
for i=6:L-3
    downNow=max(high(i-4:i-1))-low(i);
    downs=[max(high(i-4:i-2))-low(i-1),max(high(i-4:i-3))-low(i-2),max(high(i-5:i-4))-low(i-3),high(i-5)-low(i-4)];
    if close(i-1)>open(i-1) && close(i-2)>open(i-2) && close(i-3)>open(i-3) && close(i-4)>open(i-4) &&...% continuous ups(close>open)
            downNow>1*max(downs)&&low(i)>min(low(i-4:i-1))&&...%big down happens;
            close(i)<low(i)+0.25*(high(i)-low(i)) %&& weekday(rawDate(i))==5 %(high(i)-low(i))>0.85*diff &&close(i) < low(i-4)+0.6*(high(i-1)-low(i-4))&&
        x(j)=i;
        y(j)=low(i);
        if open(i+1)<close(i)
            results(j)=0.5*(close(i+1)-close(i))/close(i);
            j=j+1;
            results(j)=0.5*(open(i+2)-open(i+1))/open(i+1);
            j=j+1;
        else
            results(j)=0.5*(close(i+1)-close(i))/close(i);
            j=j+1;
        end
    end
end
if nargin<2
    figure;
    candle(high,low,close,open);
    hold on;
    plot(x(1:j-1),y(1:j-1),'*','Color','r')
end
plus=sum(results>0);
winRatio=plus/(j-1);
resultsRaw=results;
results=results(1:j-1)+1;
y=cumprod(results)-1;
if ~isempty(y)
    sharpe=mean(resultsRaw)/std(resultsRaw);
    op=[winRatio,sharpe,j-1];
    if nargin<2
        figure;
        plot(1:j-1,y);
    end
else
    op=[0,0,0];
    display('There is not k line which fits to this module!');
end

