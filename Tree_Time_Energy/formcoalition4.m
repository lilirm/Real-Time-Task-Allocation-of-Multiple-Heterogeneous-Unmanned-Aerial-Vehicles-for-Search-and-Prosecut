function [coalition,cost,maxUavId,liliT,liliE] = formcoalition4(uav,target,attack_target,target_candidate)
%uav所有无人机，target所有目标，attack_target被攻击目标id，target_candidate候选无人机id，cost为联盟中最大代价
%以attack_target为根构造资源树，选取高度最小的满足资源需求的分支，计算目标函数值，然后在选取函数值最小的组合
%1、计算候选者到目标的最短时间 EAT (与formcoalition.m不同之处：此处使用时间EAT而不是长度) added 2020/5/26
can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);                         %cost指到达目标的时间
for i = 1:can_num
    target_candidate_cost(i) = compute_EAT(uav(target_candidate(i)),target(attack_target).location,uav(target_candidate(i)).turnRadius);
end
[target_candidate_cost,sortOrder] = sort(target_candidate_cost);  %将时间按升序排序
target_candidate = target_candidate(sortOrder);
% targetResourceRequired = target(attack_target).resource;
% coalitionMembers = [];
% coalitionResources = zeros(1,size(target(attack_target).resource,2));
% coalitionCost = [];

[coalition,coalitionCost,liliT,liliE] = resourcetree_target(target_candidate,target_candidate_cost,uav,target,attack_target);
[cost,pos] = max(coalitionCost);   %获取最大时间及最大时间无人机  added in 2020/6/1
maxUavId = coalition(pos); 


% iCandidate = 0;
% %2、选取最少时间联盟
% while sum(nonnegtive((targetResourceRequired-sum(coalitionResources,1))))>0
%     if coalitionResources == 0
%         coalitionResources = [];
%     end
%     iCandidate = iCandidate + 1;
%     coalitionMembers = [coalitionMembers target_candidate(iCandidate)];
%     coalitionResources = [coalitionResources; uav(target_candidate(iCandidate)).resource];
%     coalitionCost = [coalitionCost target_candidate_cost(iCandidate)];
% end
%3、基于第二步，选取最少个数联盟
% [coalitionMembers,coalitionResources,coalitionCost] = resourcetree(coalitionMembers,coalitionResources,coalitionCost,targetResourceRequired);
% [cost,pos] = max(coalitionCost);   %获取最大时间及最大时间无人机  added in 2020/5/27
% maxUavId = coalitionMembers(pos); 

end



