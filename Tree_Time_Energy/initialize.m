function [uav,target,l,b] = initialize()

%搜索范围
% l = 2000;                   
% b = 2000; 
% xMin = -l/2; xMax = l/2;
% yMin = -b/2; yMax = b/2;

l = 3200;                   
b = 3200; 
xMin = 0; xMax =l;
yMin = 0; yMax = b;

%初始化目标信息：位置、所需资源
nTarget = 1;
% load targetData
load targetData2
for iTarget = 1:nTarget
    target(iTarget).id = iTarget;
    target(iTarget).location = targetData(iTarget,1:2);
    target(iTarget).resource = targetData(iTarget,3:4);
    target(iTarget).visit = 0;         %标记iTarget是否已被分配
    target(iTarget).isAttacked = 0;    %标记iTarget是否已被执行
end

%初始化无人机信息：位置、航向角、速度、转弯半径、搜索半径、携带资源
nUav = 6;
load uavData2
for iUav = 1:nUav
    uav(iUav).id = iUav;
    uav(iUav).position = uavData(iUav,1:2);
    uav(iUav).heading = degtorad(uavData(iUav,3)); %弧度值
    uav(iUav).velocity = uavData(iUav,4);
    uav(iUav).turnRadius = uavData(iUav,5);
    uav(iUav).detectRadius = uavData(iUav,6);
    uav(iUav).resource = uavData(iUav,7:8);
%     uav(iUav).status = "InSearch";   %1表示搜索，2表示执行任务，3表示边界处理
%     uav(iUav).coalitionLeader = [];
%     uav(iUav).invitationWait = [];
    uav(iUav).destroyedTargets = [];   %记录无人机执行过的所有目标
    uav(iUav).target = 0;              %记录无人机此刻的攻击目标
    uav(iUav).path = [];               %存储已飞过的航迹
    uav(iUav).planning_route = [];
    uav(iUav).condition = 1;           %1表示搜索，2表示执行攻击任务，3表示边界处理
    uav(iUav).energyConsume=0;         %记录iUav的能量消耗
%    uav(iUav).coalitionMembers = [];
end
end

