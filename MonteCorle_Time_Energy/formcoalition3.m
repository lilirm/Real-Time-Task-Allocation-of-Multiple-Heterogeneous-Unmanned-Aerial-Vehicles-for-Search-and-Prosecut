function [coalitionMembers,cost,maxUavId] = formcoalition3(uav,target,attack_target,target_candidate)
%uav�������˻���target����Ŀ�꣬attack_target������Ŀ��id��target_candidate��ѡ���˻�id��costΪ������������
%�����۴�С��������ѡȡ��Сʱ������----������Դ��ѡȡ��Сsize����
%1�������ѡ�ߵ�Ŀ������ʱ�� EAT (��formcoalition.m��֮ͬ�����˴�ʹ��ʱ��EAT�����ǳ���) added 2020/5/26
fprintf("������Ŀ�꣺%d \n",attack_target);
disp("��ѡ���˻���");
disp(target_candidate);
can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = compute_EAT(uav(target_candidate(i)),target(attack_target).location,uav(target_candidate(i)).turnRadius);
end
[target_candidate_cost,sortOrder] = sort(target_candidate_cost);  %��ʱ�䰴��������
target_candidate = target_candidate(sortOrder);
targetResourceRequired = target(attack_target).resource;
coalitionMembers = [];
coalitionResources = zeros(1,size(target(attack_target).resource,2));
coalitionCost = [];
iCandidate = 0;
%2��ѡȡ����ʱ������
first = 1;
while sum(nonnegtive((targetResourceRequired-sum(coalitionResources,1))))>0
    if first == 1 
        coalitionResources = [];
        first = 2;
    end
    iCandidate = iCandidate + 1;
    coalitionMembers = [coalitionMembers target_candidate(iCandidate)];
    coalitionResources = [coalitionResources; uav(target_candidate(iCandidate)).resource];
    coalitionCost = [coalitionCost target_candidate_cost(iCandidate)];
end
%3�����ڵڶ�����ѡȡ���ٸ�������
disp("����ʱ�����ˣ�");
disp(coalitionMembers);
[coalitionMembers,coalitionResources,coalitionCost] = resourcetree(coalitionMembers,coalitionResources,coalitionCost,targetResourceRequired);
[cost,pos] = max(coalitionCost);   %��ȡ���ʱ�估���ʱ�����˻�  added in 2020/5/27
maxUavId = coalitionMembers(pos); 
end

