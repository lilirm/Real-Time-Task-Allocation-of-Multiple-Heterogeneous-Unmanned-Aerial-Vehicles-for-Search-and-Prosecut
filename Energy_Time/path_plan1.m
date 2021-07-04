function [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId)  %attack_taregt/coalitionΪ��� added 2020/5/26
%�����˳�Ա��·�����й滮������ת��뾶��ָ��ʱ�䵽��Ŀ��㣬�˴���cost��ʱ��
%������������˻��ĺ������������˻���Ŀ��λ�õ������ϣ��ҷ���ָ��Ŀ�꣬��ʱ������ת��뾶

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

function [flag] = straightLine(uav,target)     %�ж����˻��ĺ�����ǲ���ָ��Ŀ�� uav�ض����˻�  target�ض�Ŀ��
    targetLocation = target.location;
    uavLocation = uav.position;
    line_angle = atan2(targetLocation(2)-uavLocation(2),targetLocation(1)-uavLocation(1));
    if line_angle == uav.heading              %ָ��
        flag = 1;
    else
        flag = 0;
    end
end

