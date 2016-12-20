function wk=dk2wk(varargin)
if length(varargin)==6
    date=varargin{1};
    high=varargin{2};
    low=varargin{3};
    close=varargin{4};
    open=varargin{5};
    vol=varargin{6};
elseif length(varargin)==1
    name_f=strcat('E:\360Synchronization\360Synchronization\MatLab\DataFromZX\AllStocks\',varargin{1},'.txt');
    fid=fopen(name_f);
    Data=textscan(fid,'%s %f %f %f %f %d %d','headerlines',2);  
    fclose(fid);
    date=Data{1}(1:end-1);
    open=Data{2}(1:end-1);
    high=Data{3}(1:end-1);
    low=Data{4}(1:end-1);
    close=Data{5}(1:end-1);
    vol=Data{6}(1:end-1);
else
    warndlg('Put in parameters wrongly, please again!');
    return;
end
Date=datenum(date);
dl=Date(end)-Date(1)+1;
wk(ceil(dl/7)+1,6)=0;
day1=weekday(date(1));
begin=Date(1)-day1+1; % begin is a sunday;
n=0;
for i=begin:7:Date(end)+7
    n=n+1;
    [~,ind]=intersect(Date,i:i+7);
    if ~isempty(ind)
        wk(n,1)=Date(min(ind));
        wk(n,2)=max(high(ind));
        wk(n,3)=min(low(ind));
        wk(n,4)=close(ind(end));
        wk(n,5)=open(ind(1));
        wk(n,6)=sum(vol(ind));
    else
        n=n-1;
    end 
end
figure;
subplot(3,1,[1 2]);
candle(wk(:,2),wk(:,3),wk(:,4),wk(:,5));
subplot(3,1,3);
bar(wk(:,6));
end
