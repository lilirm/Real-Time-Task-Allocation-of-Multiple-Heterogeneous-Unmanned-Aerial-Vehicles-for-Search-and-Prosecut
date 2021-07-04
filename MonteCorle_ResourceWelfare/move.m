function [uav] = move(uav,time_interval,l,b)   %uav�ض����˻�
uav.path = [uav.path; uav.position];
if uav.condition == 1
    uav.position = uav.position + uav.velocity * time_interval * [cos(uav.heading) sin(uav.heading)];
    %�߽紦��
    uav = border_process(uav,l,b,time_interval);
else
    uav.position = uav.planning_route(1,:);
    uav.planning_route(1,:) = [];
    if size(uav.planning_route,1) == 0
        uav.condition = 1;  %תΪ����״̬
    end
end
end

