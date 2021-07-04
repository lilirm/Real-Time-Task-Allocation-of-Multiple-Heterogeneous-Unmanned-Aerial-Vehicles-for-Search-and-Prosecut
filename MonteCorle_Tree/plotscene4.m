%画任务时间图
figure(1);
box on;
axis([0 25 160 340])
set(gca,'xtick',0:5:25);
set(gca,'ytick',160:10:340);
xlabel('Number of UAVs');
ylabel('Average mission time(s)');
hold on;

A=[6 281.061;10 242.866;15 171.765;20 164.973];   %Tree-based
B=[6 294.652;10 246.380;15 169.157;20 164.223];   %Time
C=[6 285.151;10 246.444;15 172.035;20 165.612];   %Energy
D=[6 334.965;10 256.613;15 199.657;20 195.781];   %Resource welfare
for i=1:4
    plot(A(i,1),A(i,2),'s','Color','r','MarkerSize',5,'MarkerFaceColor','r');
    plot(B(i,1),B(i,2),'o','Color','b','MarkerSize',5,'MarkerFaceColor','b');
    plot(C(i,1),C(i,2),'^','Color','c','MarkerSize',5,'MarkerFaceColor','c');
    plot(D(i,1),D(i,2),'d','Color','k','MarkerSize',5,'MarkerFaceColor','k');
    if i<4
      h1=plot([A(i,1),A(i+1,1)],[A(i,2),A(i+1,2)],'-','Color','r');
      h2=plot([B(i,1),B(i+1,1)],[B(i,2),B(i+1,2)],'-','Color','b');
      h3=plot([C(i,1),C(i+1,1)],[C(i,2),C(i+1,2)],'-','Color','c');
      h4=plot([D(i,1),D(i+1,1)],[D(i,2),D(i+1,2)],'-','Color','k');
    end
end
legend([h1,h2,h3,h4],'最小化任务时间与能耗联盟组建算法','最小化任务时间联盟组建算法','最小化无人机能耗联盟组建算法','基于资源福利任务分配算法','Location','North');