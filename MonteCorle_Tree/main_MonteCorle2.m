%ʹ��Monte Corle���ж������
%������������������˻���Ŀ����Դ��������滮
clc
clear
N=100;                          %����
[uav,target,l,b] = initialize_Monte(); %��ʼ�����˻���Ŀ�ꡢ��������
% uavResource =[];                %��¼ÿ�������������Դ
% targetResource = [];
missionTime = zeros(1,N);       %��¼ÿһ�ε��������ʱ��
energyConsume = zeros(1,N);     %��¼ÿһ�ε���������
planningTime = zeros(1,N);      %��¼ÿһ�ε�����滮ʱ��
count = 0;                      %��¼��ɴ���

load uavResource1
load targetResource1

for i=1:N
%   tr=randi([1,5],5,2);        %���������Ŀ����Դ����
%   ur=randi([1,8],6,2);        %������������˻���Դ
%   uavResource = [uavResource;ur];
%   targetResource = [targetResource;tr];
  ur = uavResource((i-1)*6+1:(i-1)*6+6,:);     %6�����˻�
  tr = targetResource((i-1)*5+1:(i-1)*5+5,:);  %5��Ŀ��
  [time,energy,flag,planTime] = task_plan(uav,target,ur,tr,l,b);
  if flag==1  %���
      count=count+1;
      missionTime(i) = time;
      energyConsume(i) = energy;
      planningTime(i) = planTime;
  else
      missionTime(i) = 0;
      energyConsume(i) = 0;
      planningTime(i) = 0;
  end
end
averageTime = sum(missionTime)./count;
averageEnergy = sum(energyConsume)./count;
averagePlanTime = sum(planningTime)./count;
fprintf("��ɴ�����%d \n",count);
fprintf("ƽ������ʱ�䣺%f \n",averageTime);
fprintf("ƽ������滮ʱ�䣺%f \n",averagePlanTime);
fprintf("ƽ���������ģ�%f \n",averageEnergy);
