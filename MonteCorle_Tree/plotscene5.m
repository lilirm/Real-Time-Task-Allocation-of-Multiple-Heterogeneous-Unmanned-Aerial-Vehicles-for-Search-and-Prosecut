%画能耗图
figure(1);
box on;
axis([0 25 3.0 7.5])
set(gca,'xtick',0:5:25);
set(gca,'ytick',3.0:0.3:7.5);
xlabel('Number of UAVs');
ylabel('Average energy consumption(x10^5J)');
hold on;

A=[6 3.38467;10 4.73778;15 5.01187;20 6.32807];   %Tree-based
B=[6 3.57935;10 4.87693;15 5.03483;20 6.49357];   %Time
C=[6 3.43164;10 4.80251;15 5.02220;20 6.35974];   %Energy
D=[6 3.96691;10 4.97098;15 5.64840;20 7.31005];   %Resource welfare
for i=1:4
    plot(A(i,1),A(i,2),'s','Color','r','MarkerSize',4,'MarkerFaceColor','r');
    plot(B(i,1),B(i,2),'o','Color','b','MarkerSize',4,'MarkerFaceColor','b');
    plot(C(i,1),C(i,2),'^','Color','c','MarkerSize',4,'MarkerFaceColor','c');
    plot(D(i,1),D(i,2),'d','Color','k','MarkerSize',4,'MarkerFaceColor','k');
    if i<4
      h1=plot([A(i,1),A(i+1,1)],[A(i,2),A(i+1,2)],'-','Color','r');
      h2=plot([B(i,1),B(i+1,1)],[B(i,2),B(i+1,2)],'-','Color','b');
      h3=plot([C(i,1),C(i+1,1)],[C(i,2),C(i+1,2)],'-','Color','c');
      h4=plot([D(i,1),D(i+1,1)],[D(i,2),D(i+1,2)],'-','Color','k');
    end
end
legend([h1,h2,h3,h4],'最小化任务时间与能耗联盟组建算法','最小化任务时间联盟组建算法','最小化无人机能耗联盟组建算法','基于资源福利任务分配算法','Location','North');