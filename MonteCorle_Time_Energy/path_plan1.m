function [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId)  %attack_taregt/coalition为编号 added 2020/5/26
%对联盟成员，路径进行规划，调整转弯半径，指定时间到达目标点，此处的cost是时间
%特殊情况：无人机的航向正好在无人机与目标位置的连线上，且方向指向目标，此时不用求转弯半径

% if length(coalition)==1
%     targetLocation = target(attack_target).location;
%     uavLocation = uav(coalition(1)).position;
%     line_angle = atan2(targetLocation(2)-uavLocation(2),targetLocation(1)-uavLocation(1));
%     if straightLine(uav(coalition(1)),target(attack_target)) == 1
%         uav(coalition(1)).target = attack_target;
%         [uav(coalition(1))] = straightline_path_plan_energy(uav(coalition(1)),target(attack_target));
%         return;
%     end
% end

for i=1:length(coalition)
    uav(coalition(i)).target = attack_target;
    uav(coalition(i)).destroyedTargets = [uav(coalition(i)).destroyedTargets attack_target];
    if coalition(i) == maxUavId && straightLine(uav(coalition(i)),target(attack_target)) == 1
        [uav(coalition(1))] = straightline_path_plan_energy(uav(coalition(1)),target(attack_target));
        continue;
    end
    radius = find_radius1(uav(coalition(i)),target(attack_target),cost,l); 
    [uav(coalition(i))] = dubins_path_plan_energy(uav(coalition(i)),target(attack_target),radius);
end
end

function [flag] = straightLine(uav,target)     %判断无人机的航向角是不是指向目标 uav特定无人机  target特定目标
    targetLocation = target.location;
    uavLocation = uav.position;
    line_angle = atan2(targetLocation(2)-uavLocation(2),targetLocation(1)-uavLocation(1));
    if line_angle == uav.heading              %指向
        flag = 1;
    else
        flag = 0;
    end
end

