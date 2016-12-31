function prepareData( varargin) 

global date high low close open vol;

% load IDNames_copy.mat;
load IDNames.mat;

X=zeros(50000000,6);
Y=zeros(50000000,1);

for i=1:length(IDNames)
%     name_f=strcat('E:\360Synchronization\360Synchronization\MatLab\DataFromZX\AllStocks\',IDNames{i},'.txt');
    name_f=strcat('E:\360Synchronization\360Synchronization\MatLab\DataFromZX\BackTest\',IDNames{i},'.txt');
    fid=fopen(name_f);
    Data=textscan(fid,'%s %f %f %f %f %d %d','headerlines',2);  
    fclose(fid);
    L=length(Data{1})-1;
    if L<50
        continue;
    end
    date=Data{1}(1:L);
%     open=Data{2}(1:L);
    high=Data{3}(1:L);
    low=Data{4}(1:L);
    close=Data{5}(1:L);
    vol=Data{6}(1:L);
    x=zeros(10000,6);
    y=zeros(10000,1);
    for j=15:L-5
        highPoint=highest(j-12,j);
        lowPoint=lowest(j-12,j);
        x(j-14,1)=(close(j)-close(j-1))/close(j-1);
        x(j-14,2)=double(vol(j)-vol(j-1))/double(vol(j-1));
        everPrice=mean(close(highPoint:j));
        x(j-14,3)=(close(j)-everPrice)/everPrice;
        everVol=double(mean(vol(highPoint:j)));
        x(j-14,4)=double(vol(j)-everVol)/everVol;
        x(j-14,5)=j-highPoint;
        x(j-14,6)=j-lowPoint;
        if low(j)<low(lowest(j+1,j+4))&& datenum(date(j+4))-datenum(date(j))<=10
            upratio=(high(highest(j+1,j+4))-low(j))/low(j);
            if upratio>0.15 && upratio<0.3
                y(j-14)=1;
            elseif upratio>=0.3
                y(j-14)=2;
            end
        end                                      
    end
    
    len_x=sum(x(:,1)~=0);
    len_X=sum(X(:,1)~=0);
    X(len_X+1:len_X+len_x,:)=x(1:len_x,:);
    Y(len_X+1:len_X+len_x)=y(1:len_x);
end
save dataML X Y
end

