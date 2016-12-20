function [p, settings] = thanksgiving(DATE, OPEN, HIGH, LOW, CLOSE, settings)
settings.markets     = {'CASH', 'F_AD', 'F_BO', 'F_BP', 'F_C', 'F_CC', 'F_CD', 'F_CL', 'F_CT', 'F_DX', 'F_EC', 'F_ES', 'F_FC', 'F_FV', 'F_GC', 'F_HG', 'F_HO', 'F_JY', 'F_KC', 'F_LB', 'F_LC', 'F_LN', 'F_MD', 'F_MP', 'F_NG', 'F_NQ', 'F_NR', 'F_O', 'F_OJ', 'F_PA', 'F_PL', 'F_RB', 'F_RU', 'F_S', 'F_SB', 'F_SF', 'F_SI', 'F_SM', 'F_TU', 'F_TY', 'F_US', 'F_W', 'F_XX', 'F_YM'};
settings.slippage    = 0.05;
settings.budget      = 1000000;
settings.samplebegin = 19900101;
settings.sampleend   = 20161231;
settings.lookback    = 102;

period1 = 50;  %#[200:100:500]#
period2 = 100; %#[50:10:150]#

RSImatrix = RSI(CLOSE, period2);
ATRmatrix = ATR(HIGH, LOW, CLOSE, period1);
EMAmatrix = EMA(HIGH, period2);
SMAmatrix = SMA(LOW,  period2);
STDmatrix = MSTD(CLOSE, 20);
BOLmatrix = BOLLINGER(CLOSE, 50, 2);
WILmatrix = WILLIAMS(CLOSE, 30);
ADXmatrix = ADX(HIGH,LOW,CLOSE,14);
keyboard

p = ones(1,numel(settings.markets));

p = RSImatrix(end,:) - 50;
disp(['Processing ' num2str(DATE(end))]);

end

function out = RSI(fieldClose,period)
closeMom = fieldClose(2:end,:) - fieldClose(1:end-1,:);
up   = closeMom >= 0;
down = closeMom < 0;
out = [nan(1,size(fieldClose,2)); 100 - 100 ./ (1 + SMA(up,period) ./ SMA(down,period))];
end

function out = ATR(fieldHigh, fieldLow, fieldClose, period)
tr = TR(fieldHigh,fieldLow,fieldClose);
out = SMA(tr,period);
end

function out = TR(fieldHigh, fieldLow, fieldClose)
fieldCloseLag = LAG(fieldClose,1);

range1 = fieldHigh - fieldLow;
range2 = abs(fieldHigh-fieldCloseLag);
range3 = abs(fieldLow -fieldCloseLag);

out = max(max(range1,range2),range3);
end

function out = LAG(field, period)
nMarkets = size(field,2);
out = [nan(period,nMarkets); field(1:end-period,:)];
end

function out = EMA(field, period)
ep = 2/(period+1);
out = filter(ep,[1 -(1-ep)],field,field(1,:)*(1-ep));
out(1:period-1,:) = NaN;
end

function out = SMA(field, period)
out = filter(ones(1,period),period,field);
out(1:period-1,:) = NaN;
end

function out = MSTD(field, period)
out = NaN(size(field));
for k = period:size(field,1)
    out(k,:) = std(field(k-period+1:k,:));
end
end

function out = BOLLINGER(field, period, delta)
out.sma = EMA(field,period);
bolStd  = MSTD(field,period);
out.upperBorder = out.sma + bolStd .* delta;
out.lowerBorder = out.sma - bolStd .* delta;
end

function out = MMAX(field, period)
out = NaN(size(field));
for k = period:size(field,1)
   out(k,:) = max(field(k-period+1:k,:));
end
end

function out = MMIN(field, period)
out = NaN(size(field));
for k = period:size(field,1)
   out(k,:) = min(field(k-period+1:k,:));
end
end

function out = WILLIAMS(field, period)
    maxi = MMAX(field,period);
    mini = MMIN(field,period);
    out  = (field - mini) ./ (maxi - mini);
end

function out = ADX(fieldHigh, fieldLow, fieldClose, period)
    upMove    = fieldHigh(2:end,:) - fieldHigh(1:end-1,:);
    downMove  = fieldLow(1:end-1,:) - fieldLow(2:end,:);
    plusDMix  = [false(1, size(fieldHigh,2)); upMove > 0   & upMove > downMove];
    minusDMix = [false(1, size(fieldHigh,2)); downMove > 0 & downMove > upMove];
    plusDM    = zeros(size(fieldHigh));
    minusDM   = zeros(size(fieldLow));
    plusDM(plusDMix)   = upMove(plusDMix(2:end,:));
    minusDM(minusDMix) = downMove(minusDMix(2:end,:));
    atr       = ATR(fieldHigh, fieldLow, fieldClose, period);

    plusDI    = 100 * SMA(plusDM,period) ./ atr;
    minusDI   = 100 * SMA(minusDM, period) ./ atr;

    out = 100 * SMA(abs(plusDI - minusDI) ./ (plusDI + minusDI), period);
end
