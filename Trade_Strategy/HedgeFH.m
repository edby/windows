function op=HedgeFH
w=windmatlab;
[IH,~,~,Date]=w.wsd('ih00.cfe','close','20150416',today-1);
IF=w.wsd('if00.cfe','close','20150416',today-1);

L=length(IH);
results=zeros(1,L);
for i=3:L  
    temLast=IF(i-1)/IF(i-2)-IH(i-1)/IH(i-2);
    tem=IF(i)/IF(i-1)-IH(i)/IH(i-1);
    wd=weekday(Date(i))-1;
    switch wd
        case 1
            if temLast>=-0.0082  % hold status on monday;
                results(i)=-tem;
            else
                results(i)=tem;
            end
        case 2
            if temLast>=-0.0213
                results(i)=tem;
            else
                results(i)=-tem;
            end
        case 3
            results(i)=tem;
        case 4
            results(i)=tem;
%             if temLast>=-0.0344
%                 results(i)=tem;
%             else 
%                 results(i)=-tem;
%             end
        case 5
            results(i)=tem;
    end
end
resultsCopy=results(results~=0);
op=mean(resultsCopy)/std(resultsCopy);
results=results+1;
y=cumprod(results)-1;
y(end)
[AX,H1,H2]=plotyy(1:L,[IF,IH],1:L,y*100);
title('IF��IH�����ȫ�Գ�','fontsize',16);
xlabel('ʱ��','fontsize',12);
set(AX(1),'xTick',1:20:L);
Date=datestr(Date,'yyyy-mm-dd');
dateTarget=mat2cell(Date,ones(size(Date,1),1),size(Date,2));
set(AX(1),'xTicklabel',dateTarget(1:20:L),'XTickLabelRotation',60);
set(get(AX(1),'ylabel'),'string','��ָ�ڻ�ָ��','fontsize',12);
set(get(AX(2),'ylabel'),'string','�����ǵ�ָ����%��','fontsize',12);
set(AX(2), 'YColor', 'r')
set(H2,'color','k');
legend('IF����','IH����','��������','location','NorthOutside','Orientation','horizontal');
grid on;
end

