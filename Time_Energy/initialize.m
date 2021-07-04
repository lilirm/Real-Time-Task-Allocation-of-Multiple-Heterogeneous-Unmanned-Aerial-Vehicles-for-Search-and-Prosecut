function [uav,target,l,b] = initialize()

%������Χ
% l = 2000;                   
% b = 2000; 
% xMin = -l/2; xMax = l/2;
% yMin = -b/2; yMax = b/2;

l = 3200;                   
b = 3200; 
xMin = 0; xMax =l;
yMin = 0; yMax = b;

%��ʼ��Ŀ����Ϣ��λ�á�������Դ
nTarget = 1;
% load targetData
load targetData2
for iTarget = 1:nTarget
    target(iTarget).id = iTarget;
    target(iTarget).location = targetData(iTarget,1:2);
    target(iTarget).resource = targetData(iTarget,3:4);
    target(iTarget).visit = 0;         %���iTarget�Ƿ��ѱ�����
    target(iTarget).isAttacked = 0;    %���iTarget�Ƿ��ѱ�ִ��
end

%��ʼ�����˻���Ϣ��λ�á�����ǡ��ٶȡ�ת��뾶�������뾶��Я����Դ
nUav = 6;
load uavData2
for iUav = 1:nUav
    uav(iUav).id = iUav;
    uav(iUav).position = uavData(iUav,1:2);
    uav(iUav).heading = degtorad(uavData(iUav,3)); %����ֵ
    uav(iUav).velocity = uavData(iUav,4);
    uav(iUav).turnRadius = uavData(iUav,5);
    uav(iUav).detectRadius = uavData(iUav,6);
    uav(iUav).resource = uavData(iUav,7:8);
%     uav(iUav).status = "InSearch";   %1��ʾ������2��ʾִ������3��ʾ�߽紦��
%     uav(iUav).coalitionLeader = [];
%     uav(iUav).invitationWait = [];
    uav(iUav).destroyedTargets = [];   %��¼���˻�ִ�й�������Ŀ��
    uav(iUav).target = 0;              %��¼���˻��˿̵Ĺ���Ŀ��
    uav(iUav).path = [];               %�洢�ѷɹ��ĺ���
    uav(iUav).planning_route = [];
    uav(iUav).condition = 1;           %1��ʾ������2��ʾִ�й�������3��ʾ�߽紦��
    uav(iUav).energyConsume=0;         %��¼iUav����������
%    uav(iUav).coalitionMembers = [];
end
end

