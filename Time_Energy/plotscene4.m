function  plotscene4(uav,target)
%画初始环境图
%(U3,U5)--T1/传递过来的uav是uav1
l=4000;  %坐标轴范围，大于initialize函数中的搜索范围，目的是画出边界处理部分的曲线
b=4000;
colorChoice = ['rgbmycrgbymcrgbymc'];
figure(1);
clf
box on;
axis([-200 l -200 b])
hold on;
plot([0,3200],[0,0],'--k');
hold on;
plot([0,3200],[3200,3200],'--k');
hold on;
plot([0,0],[0,3200],'--k');
hold on;
plot([3200,3200],[0,3200],'--k');
hold on;
set(gca,'xtick',0:500:3500);
set(gca,'ytick',0:500:3500);
xlabel('x(m)');
ylabel('y(m)');
hold on;

%plot targets
for iTarget=1:length(target)
    plot(target(iTarget).location(1),target(iTarget).location(2),[colorChoice(1) 'x'],'markersize',10,'linewidth',2);
    text(target(iTarget).location(1)+40,target(iTarget).location(2),'T','FontSize',10);   
end

%plot uavs path
load uavData2
for iUav=1:length(uav)
    if iUav==3 || iUav==5 || iUav==6
    plot(uav(iUav).path(2,1),uav(iUav).path(2,2),[colorChoice(3) '^'],'markersize',10,'MarkerFaceColor','b');
    %plot(uav(iUav).position(1),uav(iUav).position(2),[colorChoice(3) '*'],'markersize',10,'MarkerFaceColor','b');
    text(uav(iUav).path(2,1)+50,uav(iUav).path(2,2),strcat('U_',num2str(iUav)),'FontSize',10);  
    end
    if ~isempty(uav(iUav).planning_route)
        uav(iUav).path = [uav(iUav).path; uav(iUav).planning_route];
    end
    if iUav==3 
       h1=plot(uav(iUav).path(:,1),uav(iUav).path(:,2),'LineWidth',2);
    end
    if iUav==5 
       h2=plot(uav(iUav).path(:,1),uav(iUav).path(:,2),'LineWidth',2);
    end
    if iUav==6 
       h3=plot(uav(iUav).path(:,1),uav(iUav).path(:,2),'LineWidth',2);
    end
end
legend([h1,h2,h3],'UAV3','UAV5','UAV6','Location','North');
drawnow
end

