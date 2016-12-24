%Author: Moeti Ncube
%This strategy was partially used in the development of a 100 percent 
%automative trading strategy; this is a some of the backtesting coding we 
%use to analyze tick data.

% This code can be used to backtest a trading strategy for a time series
% that has the price vector in the first column and trading indicator in
% second column. I will be using NG futures contracts for trading and will
% track pnl in terms of ticks (NG trades in ticks, so .001 ticks
%on ICE would be about $70/contract, $10/contract on NYMEX)

%Over 17 days this strategy on this dataset would make about $1060 on NYMEX, 
%or $7427 on ICE. 

%Data is stored in the first column and a (proprietery) indicator, that 
%basically tracks the speed of market, is stored in second column. 

%This code can be adjusted to incorporate another dataset/indicator as long
%as it assumes the basic strategy outline I will describe here. This is
%actually a simplification of my real strategy. For example, my real 
%Buy/Sell indicator updates to be vt=max(v1,....vt-1) whereas here I make 
%it static. 

%Buy/Sell Indicator
%Whenever the indicator is less than value "v1", you buy one contract at the current price
%in market. Whenever indicater is greater than value "v1' you sell one contract at
%current price in market. 

%Profit Target
%If the weighted average long/short position is "pt" ticks in the money  you close out
%yor position, make "pt" and strategy starts over from current price/ind.

%Stop Loss
%If the weighted average long/short position is "st" ticks out of the money, your strategy depends
%on you double down indicator "dd", If dd=0, you take the loss the first
%time this happens and strategy starts over. If dd=1, you add 1 contract to your long/short postion
%and obtain a new weighted average long/short price. Now, If your new long/short
%position becomes "pt" ticks in the money you double your profit to "2*pt",
%however if it becomes "st" ticks out of the money, you double your losses
%to "2*st"; Unless dd=2, in which once again you would buy another contract
%for potential "3*pt" gain or "3*st" loss.

%val(d,:) (matrix)
%Here I use intraday data from 17 days in the market, val provides output 
%from each day of the 
%[pnl,percent profitability, sharpe ratio, number of trades] 

%dtrades{d}
%Here I track the profit or loss realized on each trade on a given day 'd'

clear all
format short g
load data1.txt
load data2.txt
load data3.txt
load data4.txt
load data5.txt
load data6.txt
load data7.txt
load data8.txt
load data9.txt
load data10.txt
load data11.txt
load data12.txt
load data13.txt
load data14.txt
load data15.txt
load data16.txt
load data17.txt

days=17;
text='data';

for d=1:days
name=[text, num2str(d) '.txt'];
importfile(name)

%Buy/Sell Indicator, profit target, stop loss, double downs
v1=.005; pt=.007; st=.024; dd=3; 
[pnl,val(d,:)]= fbacktest(data,v1,pt,st,dd);
dtrades{d}=pnl;
end

%plot of cumulative pnl (in cents) for this strategy
plot(cumsum(val(:,1))); title('Strategy PNL')

