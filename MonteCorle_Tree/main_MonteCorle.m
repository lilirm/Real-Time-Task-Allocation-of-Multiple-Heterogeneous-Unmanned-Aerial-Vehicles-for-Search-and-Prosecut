%使用Monte Corle进行多次试验

clc
clear
N=100;                          %次数
[uav,target,l,b] = initialize_Monte(); %初始化无人机、目标、任务区域
uavResource =[];                %记录每次随机产生的资源
targetResource = [];
missionTime = zeros(1,N);       %记录每一次的任务完成时间
energyConsume = zeros(1,N);     %记录每一次的能量消耗
count = 0;                      %记录完成次数

for i=1:N
  tr=randi([1,8],5,2);        %随机产生的目标资源需求
  ur=randi([1,3],20,2);        %随机产生的无人机资源
  uavResource = [uavResource;ur];
  targetResource = [targetResource;tr];
  [time,energy,flag] = task_plan(uav,target,ur,tr,l,b);
  if flag==1  %完成
      count=count+1;
      missionTime(i) = time;
      energyConsume(i) = energy;
  else
      missionTime(i) = 0;
      energyConsume(i) = 0;
  end
end
averageTime = sum(missionTime)./count;
averageEnergy = sum(energyConsume)./count;
fprintf("完成次数：%d \n",count);
fprintf("平均任务时间：%f \n",averageTime);
fprintf("平均能量消耗：%f \n",averageEnergy);
