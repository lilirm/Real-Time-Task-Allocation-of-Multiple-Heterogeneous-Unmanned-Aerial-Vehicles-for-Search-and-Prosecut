function [uav,target] = path_plan(attack_target,coalition,cost,uav,target,l) %attack_taregt/coalitionΪ���
%�����˳�Ա��·�����й滮������ת��뾶��ָ��ʱ�䵽��Ŀ���,�˴���cost��·������
for i=1:length(coalition)
    radius = find_radius(uav(coalition(i)),target(attack_target),cost,l);
    [uav(coalition(i))] = dubins_path_plan(uav(coalition(i)),target(attack_target),radius);
end
end

