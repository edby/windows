function backtest_test
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% read in dates from files and plot
global open close high low vol;

% Read in the data and make them as standard format;************************************************************************
    str=input('Please put in the stock number:','s');
    if str(1)=='6'
        name_f=strcat('E:\Matlab_Data\','SH',str,'.txt');
    else
        name_f=strcat('E:\Matlab_Data\','SZ',str,'.txt');
    end
    [date,open,high,low,close,vol,sum]=textread(name_f,'%s %f %f %f %f %d %d','headerlines',2);
    date(2:2:end)=[];date(end)=[]; %delete all needless 0s.
    open(2:2:end)=[];open(end)=[];
    high(2:2:end)=[];high(end)=[];
    low(2:2:end)=[];low(end)=[];
    close(2:2:end)=[];close(end)=[];
    vol(2:2:end)=[];vol(end)=[];
    L=length(close);
%**************************************************************************************************************************
buy=0;
sum=0;
figure;
hold on;
for i=20:L
    if buy==0 && Model_SuddenDown('xx',i);
        start_P=close(i);
        start_B=i;
        buy=1;
        stop=low(lowest(i-3,i));
    elseif buy==1
        if low(i)<=stop
            buy=0;
            sum=sum+low(i)-start_P;
            line([start_B,i],[low(start_B),low(i)],'LineWidth',5,'Color','r');
        else
            for j=start_B:i-3
                if low(j)==low(lowest(j-4,j+3)) && low(j)>stop
                    stop=low(j);
                end
            end
        end
    end
end
Kplot(open,high,low,close);
hold off;
disp('Last win money:');
disp(sum);
%//////////////////////////////////////////////////////////////////////////////
end

