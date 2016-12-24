function [ output_args ] = scan( varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%%******************************************************************************************************************************************************************
% trace the gas between the target stock and other for a little long time
% when you want to buy it. buy it only when the gas' change shows the
% target becomes up strong from week.


% syms b c x1 x2 y1 y2
% ex1 = b*x1+c-y1;
% ex2 = b*x2+c-y2;
% [b,c] = solve(ex1,ex2,'b,c');
% % 求出直线方程
% A = [1 2];
% B = [5 6];
% x1 = A(1); x2 = B(1);
% y1 = A(2); y2 = B(2);
% b = subs(b)
% c = subs(c)
% % 作图验证
% syms x y
% ezplot(b*x+c-y);
% hold on
% plot(x1,y1,'ro');
% plot(x2,y2,'ro');
% grid on
% hold off
%%***************************************************************************************************************************************************************

args=cell2mat(varargin);

A=0; 
targets=repmat('',1); %save the selected stocks;
t_A=0;%the number of the target stocks;
global date open high low close vol sum1;
load IDNames.mat;
for i=1:length(IDNames)
    name_f=strcat('E:\360Synchronization\360Synchronization\MatLab\DataFromZX\',IDNames{i},'.txt');
    A=A+1;    
    [date,open,high,low,close,vol,sum1]=textread(name_f,'%s %f %f %f %f %d %d','headerlines',2);  
    date(2:2:end)=[];date(end)=[]; %delete all needless 0s.
    open(2:2:end)=[];open(end)=[];
    high(2:2:end)=[];high(end)=[];
    low(2:2:end)=[];low(end)=[];
    close(2:2:end)=[];close(end)=[];
    vol(2:2:end)=[];vol(end)=[];
    L=length(close);
if L>6
%% Model one: select down--up--down('down's are are same,'up' is different); Number:1
if nargin==0||any(args==1)
    if low(L)<=low(lowest(L-5,L))
        kline=0;
        clear X Y;
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
                        if (high(H1)-low(L1))/(L1-H1)>(high(H2)-low(L))*1.02/(L-H2) 
                            kline=kline+1;
                            X(1,kline)=jj-j; Y(1,kline)=high(jj-j);
                            X(2,kline)=jj;   Y(2,kline)=low(jj);
                            X(3,kline)=L-j;  Y(3,kline)=high(L-j);
                            X(4,kline)=L;    Y(4,kline)=low(L);
                        end
                    end
                end
            end
            if flag==1
                break;
            end
        end
        if kline>=1
            t_A=t_A+1;
            targets{t_A,1}=IDNames{i};% save the names of selected stocks.
            srsz=get(0,'ScreenSize');
            figure('Position',[srsz(3)/8,srsz(4)/8,srsz(3)*3/4,srsz(4)*3/4]); % make one figure for each stock;
            subplot(3,1,[1,2])
            Kplot(open,high,low,close);
            hold on
            plot(X,Y,'r','LineWidth',2);
            title(IDNames{i});
            if kline>1
                set(gca,'color','y');
            end
            grid on;
            subplot(3,1,3);
            MACD(close);
            % tsobj=fints(date,[open,high,low,close],{'Open','High','Low','Close'});
            % candle(tsobj);
        end
    end
end
%//////////////////////////////////////////////////////////////////////////////
%% Model two: select same ups and downs; Number:2 which include 21;
if nargin==0 || any(args==2)
    if low(lowest(L-2,L))>=low(end)
        kline=0;
        clear X Y;
        for j=2:30       
            if L-2*j-4 <=0
                break;
            end
            H=highest(L-2*j,L);
            if low(lowest(L-j,L-2*j-4))>=low(L-2*j) && low(L)<=low(lowest(L-j,L)) &&...
                    low(L)>=low(L-2*j) && abs((highest(L-2*j,L)-(L-2*j))-j)<=1 &&...
                (high(H)-low(L-2*j))/(H-L+2*j)>(high(H)-low(L))/(L-H)
                kline=kline+1;
                X(1,kline)=L-2*j; Y(1,kline)=low(L-2*j);
                X(2,kline)=L-j;   Y(2,kline)=high(L-j);
                X(3,kline)=L;     Y(3,kline)=low(L);
            end
        end
        if kline>=1
            t_A=t_A+1;
            targets{t_A,1}=IDNames{i};% save the names of selected stocks.
            srsz=get(0,'ScreenSize');
            figure('Position',[srsz(3)/8,srsz(4)/8,srsz(3)*3/4,srsz(4)*3/4]); % make one figure for each stock;
            subplot(3,1,[1,2]);
            Kplot(open,high,low,close);
            title(IDNames{i});
            if kline>1
                set(gca,'color','y');
            end
            grid on;
            hold on;
            plot(X,Y,'r','LineWidth',2);
            hold off;
            subplot(3,1,3);
            MACD(close);
        end
    end
end
%//////////////////////////////////////////////////////////////////////////////
%% Model vice two: select same ups and downs(Multiple);  Number:21
if any(args==21)
    if low(lowest(L-2,L))>=low(end)
        kline=0;
        clear X Y;
            for j=2:30    
                if L-2*j-4 <=0
                break;
                end
                if low(lowest(L-j,L-2*j-4))>=low(L-2*j) && abs((highest(L-2*j,L)-(L-2*j))-j)<=1 && low(L)>low(L-2*j)
                    kline=kline+1;
                    X(1,kline)=L-2*j; Y(1,kline)=low(L-2*j);
                    X(2,kline)=L-j;   Y(2,kline)=high(L-j);
                    X(3,kline)=L;     Y(3,kline)=low(L);
                end
            end
            
            if kline>1
                t_A=t_A+1;
                targets{t_A,1}=IDNames{i};% save the names of selected stocks.
                
                srsz=get(0,'ScreenSize');
                figure('Position',[srsz(3)/8,srsz(4)/8,srsz(3)*3/4,srsz(4)*3/4]); % make one figure for each stock;
                subplot(3,1,[1,2]);
                Kplot(open,high,low,close);
                title(IDNames{i});
                grid on;
                hold on;
                plot(X,Y,'r','LineWidth',2);
                hold off;
                subplot(3,1,3);
                MACD(close);
            end
    end
end
%////////////////////////////////////////////////////////////////////////////
%% Model three: small_smaller_smaller;  Number:3
if nargin==0 || any(args==3)
    re=Model_MACD(close);
    if re>0
        t_A=t_A+1;
        targets{t_A,1}=IDNames{i};% save the names of selected stocks.
        srsz=get(0,'ScreenSize');
        figure('Position',[srsz(3)/8,srsz(4)/8,srsz(3)*3/4,srsz(4)*3/4]); % make one figure for each stock;
        subplot(3,1,[1,2]);
        Kplot(open,high,low,close);
        title(IDNames{i});
        subplot(3,1,3);
        MACD(close);        
    end
end
%////////////////////////////////////////////////////////////////////////////
%% Model four: Up-Line-BreakOut; Model  Number:4
if nargin==0 || any(args==4)
   Model_UpLine(IDNames(i));
end
%////////////////////////////////////////////////////////////////////////////
%% Model five: Suddon Down after Big Up; Model  Number:5
if nargin==0 || any(args==5)
   Model_SuddenDown(IDNames(i));
end
%////////////////////////////////////////////////////////////////////////////
end
end
disp(strcat(num2str(A),' stocks have benn scaned!'));
disp(strcat(num2str(A*100/length(IDNames)),'% have been completed!'));
disp(targets);
clear all;
end