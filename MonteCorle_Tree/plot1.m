function  plot1()
%UAV ¼Ó ¾ùºâÏß
colorChoice = ['rgbmycrgbymcrgbymc'];
figure(1);
clf
box on;
axis([0 1000 0 1000])
hold on;
h1=plot([0,1000],[500,500],':r','LineWidth',2.5);
ylabel('path length')

%Í¼1
% load uavpos
% for iUav=1:length(uavpos)
%     h2=plot(uavpos(iUav,1),uavpos(iUav,2),[colorChoice(3) '^'],'markersize',10,'MarkerFaceColor','b');
%     %plot(uav(iUav).position(1),uav(iUav).position(2),[colorChoice(3) '*'],'markersize',10,'MarkerFaceColor','b');
%     text(uavpos(iUav,1)+7,uavpos(iUav,2),strcat('A',num2str(iUav)),'FontSize',10);  
% end
% legend([h1,h2],'balance line','UAV','Location','NorthEast');

%Í¼2
load uavpos1
for iUav=1:length(uavpos1)
    h2=plot(uavpos1(iUav,1),uavpos1(iUav,2),[colorChoice(3) '^'],'markersize',10,'MarkerFaceColor','b');
    %plot(uav(iUav).position(1),uav(iUav).position(2),[colorChoice(3) '*'],'markersize',10,'MarkerFaceColor','b');
    text(uavpos1(iUav,1)+7,uavpos1(iUav,2),strcat('A',num2str(iUav)),'FontSize',10);  
end
legend([h1,h2],'balance line','UAV','Location','NorthEast');


end

