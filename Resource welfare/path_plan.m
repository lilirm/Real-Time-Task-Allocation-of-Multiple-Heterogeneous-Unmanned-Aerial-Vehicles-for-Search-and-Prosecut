function [uav,target] = path_plan(attack_target,coalition,cost,uav,target,l) %attack_taregt/coalition为编号
%对联盟成员，路径进行规划，调整转弯半径，指定时间到达目标点,此处得cost是路径长度
for i=1:length(coalition)
    radius = find_radius(uav(coalition(i)),target(attack_target),cost,l);
    [uav(coalition(i))] = dubins_path_plan(uav(coalition(i)),target(attack_target),radius);
end
end

