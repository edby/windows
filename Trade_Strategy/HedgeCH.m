function op=HedgeCH
w=windmatlab;
[IH,~,~,Date]=w.wsd('ih00.cfe','close','20150416',today-1);
IC=w.wsd('ic00.cfe','close','20150416',today-1);

L=length(IH);
results=zeros(1,L);
for i=3:L  
    temLast=IC(i-1)/IC(i-2)-IH(i-1)/IH(i-2);
    tem=IC(i)/IC(i-1)-IH(i)/IH(i-1);
    wd=weekday(Date(i))-1;
    switch wd
        case 1 % hold status on monday;
            if temLast>=-0.0180
                results(i)=-tem;
            else
                results(i)=tem;
            end
        case 2
            if temLast>=-0.05
                results(i)=tem;
            else
                results(i)=-tem;
            end
        case 3
            if temLast>=-0.006
                results(i)=-tem;
            else
                results(i)=tem;
            end
        case 4
            if temLast>=-0.065
                results(i)=tem;
            else
                results(i)=-tem;
            end
        case 5
            results(i)=tem;
    end
end
resultsCopy=results(results~=0);
op=mean(resultsCopy)/std(resultsCopy);
results=results+1;
y=cumprod(results)-1;
figure;
[AX,H1,H2]=plotyy(1:L,[IH,IC],1:L,y*100);
y(end)
title('IH��IC�����ȫ�Գ�','fontsize',16);
xlabel('ʱ��','fontsize',12);
set(AX(1),'xTick',1:20:L);
Date=datestr(Date,'yyyy-mm-dd');
dateTarget=mat2cell(Date,ones(size(Date,1),1),size(Date,2));
set(AX(1),'xTicklabel',dateTarget(1:20:L),'XTickLabelRotation',60);
set(get(AX(1),'ylabel'),'string','��ָ�ڻ�ָ��','fontsize',12);
set(get(AX(2),'ylabel'),'string','�����ǵ�ָ����%��','fontsize',12);
set(AX(2), 'YColor', 'r')
set(H2,'color','k');
legend('IH����','IC����','��������','location','NorthOutside','Orientation','horizontal');
grid on;
end

