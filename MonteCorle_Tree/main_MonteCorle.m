%ʹ��Monte Corle���ж������

clc
clear
N=100;                          %����
[uav,target,l,b] = initialize_Monte(); %��ʼ�����˻���Ŀ�ꡢ��������
uavResource =[];                %��¼ÿ�������������Դ
targetResource = [];
missionTime = zeros(1,N);       %��¼ÿһ�ε��������ʱ��
energyConsume = zeros(1,N);     %��¼ÿһ�ε���������
count = 0;                      %��¼��ɴ���

for i=1:N
  tr=randi([1,8],5,2);        %���������Ŀ����Դ����
  ur=randi([1,3],20,2);        %������������˻���Դ
  uavResource = [uavResource;ur];
  targetResource = [targetResource;tr];
  [time,energy,flag] = task_plan(uav,target,ur,tr,l,b);
  if flag==1  %���
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
fprintf("��ɴ�����%d \n",count);
fprintf("ƽ������ʱ�䣺%f \n",averageTime);
fprintf("ƽ���������ģ�%f \n",averageEnergy);