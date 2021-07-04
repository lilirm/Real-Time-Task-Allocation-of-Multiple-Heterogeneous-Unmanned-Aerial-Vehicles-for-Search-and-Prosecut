function [coalitionMembers,cost] = formcoalition2(uav,target,attack_target,target_candidate)
%uav�������˻���target����Ŀ�꣬attack_target������Ŀ��id��target_candidate��ѡ���˻�id��costΪ������������
%1�������ѡ�ߵ�Ŀ��Ĵ���
can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = dubins_len(uav(target_candidate(i)),target(attack_target).location,uav(target_candidate(i)).turnRadius);
end
[target_candidate_cost,sortOrder] = sort(target_candidate_cost);  %�����۰���������
target_candidate = target_candidate(sortOrder);
targetResourceRequired = target(attack_target).resource;
coalitionMembers = [];
coalitionResources = zeros(1,size(target(attack_target).resource,2));
coalitionCost = [];
iCandidate = 0;
%2��ѡȡ����ʱ������
while sum(nonnegtive((targetResourceRequired-sum(coalitionResources,1))))>0
    if coalitionResources == 0
        coalitionResources = [];
    end
    iCandidate = iCandidate + 1;
    coalitionMembers = [coalitionMembers target_candidate(iCandidate)];
    coalitionResources = [coalitionResources; uav(target_candidate(iCandidate)).resource];
    coalitionCost = [coalitionCost target_candidate_cost(iCandidate)];
end
%3��ͨ��ȥ�������Ա(�ӵ�һ����ʼ)��С������size
j=1;
count=0;
m=length(coalitionMembers);
while sum(nonnegtive((targetResourceRequired-sum(coalitionResources,1))))==0
    oldCoalitionMembers = coalitionMembers;
    oldCoalitionResources = coalitionResources;
    oldCoalitionCost = coalitionCost;
    coalitionMembers(j) = [];
    coalitionResources(j,:) = [];
    coalitionCost(j) = [];
    if sum(coalitionResources,1)-targetResourceRequired<0  %��������Դ����
        coalitionMembers = oldCoalitionMembers;
        coalitionResources = oldCoalitionResources;
        coalitionCost = oldCoalitionCost;
        j=j+1;
    end
    count=count+1;
    if count==m
        break
    end
end
coalitionMembers = oldCoalitionMembers;
coalitionResources = oldCoalitionResources;
coalitionCost = oldCoalitionCost;
cost = max(coalitionCost);
end

