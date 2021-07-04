%%%%%%%%%%%%%%%%����һ��ת��뾶���Զ���ٶȷ����ܺ���С%%%%%%%%%%%%%%%%%%%%%
     T=2; %�������˻�����1��
     c_1=9.26*10^(-4);   %������������
     c_2=2250;           %������������
     g=9.8;              %�������ٶ�
     r=120;              %��Сת��뾶
     V=0:1:100;
     E_1=T.*(c_1.*V.^3);
     E_2=T.*(c_2./V);
     E_3=T.*(c_1.*V.^3+c_2./V);                       %����ֱ���˶��ܺĹ�ʽ
     E_4=T.*((c_1+c_2./(g.^2.*r.^2))*V.^3+c_2./V);    %����Բ���˶��ܺĹ�ʽ
    
     p=find(E_3==min(E_3));    %��Сֵ
     p1=find(E_4==min(E_4));
     
%      h1=plot(V,E_1,'--r','LineWidth',2);
%      hold on;
%      h2=plot(V,E_2,'--g','LineWidth',2);
%      hold on;
     h3=plot(V,E_3,'Color', 'b','LineWidth',2); 
     hold on;
     plot(V(p),E_3(p),'o','color','r','MarkerSize',6,'MarkerFaceColor','r');   %��ǳ���Сֵ��
     hold on;
     text(V(p)+1,E_3(p)-3,['(',num2str(V(p)),',',num2str(E_3(p)),')'],'color','k');
     hold on;
     h4=plot(V,E_4,'Color', 'g','LineWidth',2); 
     hold on;
     plot(V(p1),E_4(p1),'o','color','r','MarkerSize',6,'MarkerFaceColor','r');   %��ǳ���Сֵ��
     hold on;
     text(V(p1)+1,E_4(p1)-6,['(',num2str(V(p1)),',',num2str(E_4(p1)),')'],'color','k');

     xlabel('Flight Speed V');
     ylabel('Power Required E');
%      title('�ٶ��ܺ�ͼ');
%      legend([h1,h2,h3,h4],'v^3','1/v','ֱ�߷����ܺ�','���߷����ܺ�','location','best');
     legend([h3,h4],'Straight Flight Power Required','Circular Flight Power Required','location','best');
     axis([0 80 100 5*10^2]);
        