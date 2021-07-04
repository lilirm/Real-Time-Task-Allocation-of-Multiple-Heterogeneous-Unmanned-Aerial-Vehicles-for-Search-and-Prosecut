function [uav,target] = path_plan2(attack_target,coalition,uav,target,l)  %attack_taregt/coalition为编号 added 2020/5/28
%对选出的最小能耗联盟，先求出同时到达时间，在规划路径

can_num = length(coalition);
coalition_cost = zeros(1,can_num);
for i = 1:can_num
    coalition_cost(i) = compute_EAT(uav(coalition(i)),target(attack_target).location,uav(coalition(i)).turnRadius);
end
[cost,pos] = max(coalition_cost);   %获取最大时间及最大时间无人机  
maxUavId = coalition(pos); 
[uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId);

end


