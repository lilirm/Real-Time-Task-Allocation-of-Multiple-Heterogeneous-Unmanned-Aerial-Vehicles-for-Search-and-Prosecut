function  plotscene3(uav,target,l,b)
%根据uav.path中的路径坐标点画出无人机的运动轨迹
l=5000;  %坐标轴范围，大于initialize函数中的搜索范围，目的是画出边界处理部分的曲线
b=5000;
colorChoice = ['rgbmycrgbymcrgbymc'];
figure(1);
clf
box on;
axis([-1000 l -1000 b])
hold on;
plot([0,5000],[0,0],'--k');
hold on;
plot([0,5000],[5000,5000],'--k');
hold on;
plot([0,0],[0,5000],'--k');
hold on;
plot([5000,5000],[0,5000],'--k');
hold on;
set(gca,'xtick',-1000:500:5000);
set(gca,'ytick',-1000:500:5000);
hold on;

%plot targets
for iTarget=1:length(target)
    h1=plot(target(iTarget).location(1),target(iTarget).location(2),[colorChoice(1) 'x'],'markersize',10,'linewidth',2);
    text(target(iTarget).location(1)+40,target(iTarget).location(2),strcat('T_',num2str(iTarget)),'FontSize',10);   
end

%plot uavs path
load uavData4
for iUav=1:length(uav)
    h2=plot(uavData(iUav,1),uavData(iUav,2),[colorChoice(3) '^'],'markersize',10,'MarkerFaceColor','b');
    %plot(uav(iUav).position(1),uav(iUav).position(2),[colorChoice(3) '*'],'markersize',10,'MarkerFaceColor','b');
    text(uavData(iUav,1)+40,uavData(iUav,2),strcat('A_',num2str(iUav)),'FontSize',10);  
    if ~isempty(uav(iUav).planning_route)
        uav(iUav).path = [uav(iUav).path; uav(iUav).planning_route];
    end
    plot(uav(iUav).path(:,1),uav(iUav).path(:,2),'LineWidth',2);
end
legend([h1,h2],'Target','UAV','Location','North');
drawnow
end



