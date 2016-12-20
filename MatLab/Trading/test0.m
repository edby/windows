function [op1,op2]=test0(I)
global date open high low close vol;
op1=1;
% op2=0;
% 
% N=7;
% diff=high(I-N:I-1)-open(I-N:I-1);
% Diff=high(I)-open(I);
% 
% M=6;
% aver(M)=0;
% for i=I-M:I-1
%     aver(i-I+M+1)=mean(close(i-N+1:i));
% end
% 
% aver_close=aver'-close(I-M:I-1);
% a_c1=mean(aver_close(1:floor(M/2)));
% a_c2=mean(aver_close(ceil(M/2):end));
% 
% if Diff>max(diff) && sum(close(I-M:I-1)>aver')>floor(M/2) % && a_c2<=a_c1  %
%     op1=open(I)+max(diff);
% end
% 
% % if Diff>max(diff) && a_c2>=a_c1 && close(L)>=open(L)  % && sum(close(L-M:L-1)>aver')>floor(M/2)  %
% %     op1=close(L);
% % end
% 
% % if high(L)>mean(high(L-3:L-1));
% %     op2=close(L);
% % end

end

