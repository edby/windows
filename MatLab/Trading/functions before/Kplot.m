function Kplot( varargin )
% fun help
% function cndlV2(O,H,L,C)
%          cndlV2(O,H,L,C,date)
%          cndlV2(O,H,L,C date,colorUp,colorDown,colorLine)
%          cndlV2(OHLC)
%          cndlV2(OHLC,date)
%          cndlV2(OHLC,date,colorUp,colorDown,colorLine)
isMat=size(varargin{1},2);
indexShift=0;
useDate=0;

if isMat ==4,
    O=varargin{1}(:,1);
    H=varargin{1}(:,2);
    L=varargin{1}(:,3);
    C=varargin{1}(:,4);
else
    O=varargin{1};
    H=varargin{2};
    L=varargin{3};
    C=varargin{4};
    indexShift=3;
end

if nargin+isMat<7,
    colorUp='w';
    colorDown='k';
    colorLine='k';
else
    colorUp=varargin{3+indexShift};
    colorDown=varargin{4+indexShift};
    colorLine=varargin{5+indexShift};
end
if nargin+isMat<6
    date=(1:length(O))';
else
    if varargin{2+indexShift}~=0
        date=varargin{2+indexShift};
        useDate=1;
    else
        date=(1:length(O))';
    end
end
w=0.3*min([(date(2)-date(1)) (date(3)-date(2))]);
d=C-O;
l=length(d);
hold on;
for i=1:l;
    line([date(i) date(i)],[L(i) H(i)],'Color',colorLine);
end
n=find(d<0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorDown);
end
n=find(d>=0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorUp);
end
if (nargin+isMat>5)&&useDate,
    dynamicDateTicks
end

end

