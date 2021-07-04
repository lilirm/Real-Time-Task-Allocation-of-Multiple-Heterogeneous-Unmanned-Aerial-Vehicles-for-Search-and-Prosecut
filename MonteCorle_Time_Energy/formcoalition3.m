function [coalitionMembers,cost,maxUavId] = formcoalition3(uav,target,attack_target,target_candidate)
%uav所有无人机，target所有目标，attack_target被攻击目标id，target_candidate候选无人机id，cost为联盟中最大代价
%按代价从小到大排序选取最小时间联盟----构造资源树选取最小size联盟
%1、计算候选者到目标的最短时间 EAT (与formcoalition.m不同之处：此处使用时间EAT而不是长度) added 2020/5/26
fprintf("攻击的目标：%d \n",attack_target);
disp("候选无人机：");
disp(target_candidate);
can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = compute_EAT(uav(target_candidate(i)),target(attack_target).location,uav(target_candidate(i)).turnRadius);
end
[target_candidate_cost,sortOrder] = sort(target_candidate_cost);  %将时间按升序排序
target_candidate = target_candidate(sortOrder);
targetResourceRequired = target(attack_target).resource;
coalitionMembers = [];
coalitionResources = zeros(1,size(target(attack_target).resource,2));
coalitionCost = [];
iCandidate = 0;
%2、选取最少时间联盟
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
%3、基于第二步，选取最少个数联盟
disp("最少时间联盟：");
disp(coalitionMembers);
[coalitionMembers,coalitionResources,coalitionCost] = resourcetree(coalitionMembers,coalitionResources,coalitionCost,targetResourceRequired);
[cost,pos] = max(coalitionCost);   %获取最大时间及最大时间无人机  added in 2020/5/27
maxUavId = coalitionMembers(pos); 
end

