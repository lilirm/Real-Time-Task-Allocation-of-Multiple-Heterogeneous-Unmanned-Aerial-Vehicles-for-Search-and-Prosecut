function [coalitionMembers,cost] = formcoalition1(uav,target,attack_target,target_candidate)
%uav所有无人机，target所有目标，attack_target被攻击目标id，target_candidate候选无人机id，cost为联盟中最大代价
%1、计算候选者到目标的代价
can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = dubins_len(uav(target_candidate(i)),target(attack_target).location,uav(target_candidate(i)).turnRadius);
end
[target_candidate_cost,sortOrder] = sort(target_candidate_cost);  %将代价按升序排序
target_candidate = target_candidate(sortOrder);
targetResourceRequired = target(attack_target).resource;
coalitionMembers = [];
coalitionResources = zeros(1,size(target(attack_target).resource,2));
coalitionCost = [];
iCandidate = 0;
%2、选取最少时间联盟
while sum(nonnegtive((targetResourceRequired-sum(coalitionResources,1))))>0
    if coalitionResources == 0
        coalitionResources = [];
    end
    iCandidate = iCandidate + 1;
    coalitionMembers = [coalitionMembers target_candidate(iCandidate)];
    coalitionResources = [coalitionResources; uav(target_candidate(iCandidate)).resource];
    coalitionCost = [coalitionCost target_candidate_cost(iCandidate)];
end
%3、通过去除冗余成员(资源和最小)最小化联盟size
while sum(coalitionResources,1)>=targetResourceRequired
    toRemove = find(sum(coalitionResources,2)==min(sum(coalitionResources,2)));
    remResources = setdiff(coalitionResources, coalitionResources(toRemove,:),'rows');
    totalRemResources = sum(remResources);
    oldCoalitionMembers = coalitionMembers;
    oldCoalitionResources = coalitionResources;
    oldCoalitionCost = coalitionCost;
    if totalRemResources >= targetResourceRequired
        coalitionMembers(toRemove) = [];
        coalitionResources(toRemove,:) = [];
        coalitionCost(toRemove) = [];
        oldCoalitionMembers = coalitionMembers;
        oldCoalitionResources = coalitionResources;
        oldCoalitionCost = coalitionCost;
    else
        break;
    end
end
coalitionMembers = oldCoalitionMembers;
coalitionResources = oldCoalitionResources;
coalitionCost = oldCoalitionCost;
cost = max(coalitionCost);
end

