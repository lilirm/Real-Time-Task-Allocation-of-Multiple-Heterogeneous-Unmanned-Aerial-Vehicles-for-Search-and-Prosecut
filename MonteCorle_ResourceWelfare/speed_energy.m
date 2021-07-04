%%%%%%%%%%%%%%%%给定一个转弯半径，以多大速度飞行能耗最小%%%%%%%%%%%%%%%%%%%%%
     T=1; %假设无人机飞行1秒
     c_1=9.26*10^(-4);   %两个常量参数
     c_2=2250;           %两个常量参数
     g=9.8;              %重力加速度
     r=120;              %最小转弯半径
     V=0:1:100;
     E_1=T.*(c_1.*V.^3);
     E_2=T.*(c_2./V);
     E_3=T.*(c_1.*V.^3+c_2./V);                       %匀速直线运动能耗公式
     E_4=T.*((c_1+c_2./(g.^2.*r.^2))*V.^3+c_2./V);    %匀速圆周运动能耗公式
    
     p=find(E_3==min(E_3));    %最小值
     p1=find(E_4==min(E_4));
     
     h1=plot(V,E_1,'--r','LineWidth',2);
     hold on;
     h2=plot(V,E_2,'--g','LineWidth',2);
     hold on;
     h3=plot(V,E_3,'Color', 'b','LineWidth',2); 
     plot(V(p),E_3(p),'*','color','r','MarkerSize',10);   %标记出最小值点
     text(V(p)+1,E_3(p)-1,['(',num2str(V(p)),',',num2str(E_3(p)),')'],'color','k');
     hold on;
     h4=plot(V,E_4,'Color', 'm','LineWidth',2); 
     plot(V(p1),E_4(p1),'*','color','r','MarkerSize',10);   %标记出最小值点
     text(V(p1)+1,E_4(p1)-1,['(',num2str(V(p1)),',',num2str(E_4(p1)),')'],'color','k');

     xlabel('Flight Speed V');
     ylabel('Power Required E');
     title('速度能耗图');
     legend([h1,h2,h3,h4],'v^3','1/v','直线飞行能耗','曲线飞行能耗','location','best');
     
     axis([0 100 0 5*10^2]);
        