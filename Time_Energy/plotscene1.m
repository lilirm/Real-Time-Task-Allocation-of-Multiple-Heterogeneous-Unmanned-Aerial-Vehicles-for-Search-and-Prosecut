function  plotscene1(uav,target,l,b)
%在每一个time interval时画出uav与target的位置,相当于画出一个动态运动的图
colorChoice = ['rgbmycrgbymcrgbymc'];
figure(1);
clf
axis([-l/2 l/2 -b/2 b/2])
hold on

%plot targets
for iTarget=1:length(target)
    if sum(target(iTarget).resource) > 0
        plot(target(iTarget).location(1),target(iTarget).location(2),[colorChoice(1) 'x'],'markersize',10,'linewidth',2);
        text(target(iTarget).location(1),target(iTarget).location(2),strcat('T_',num2str(iTarget)),'FontSize',10);
    end
end

%plot uavs
uavColor = 'b';
for iUav=1:length(uav)
    uavPlot(uav(iUav).position', uav(iUav).heading,uavColor);
    text(uav(iUav).position(1),uav(iUav).position(2),strcat('A_',num2str(iUav)),'FontSize',10);  
end
drawnow
end

