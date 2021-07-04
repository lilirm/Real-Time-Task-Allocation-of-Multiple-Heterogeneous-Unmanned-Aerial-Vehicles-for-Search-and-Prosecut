function [uav] = border_path_plan(center,hudu,direction,uav,time_interval) %uav特定无人机
deviation = 0.01;
R = uav.turnRadius;
len_interval = uav.velocity * time_interval;
hudu_interval = len_interval/R;
theta0 = atan2(uav.position(2)-center(2),uav.position(1)-center(1));
theta_add = 0;
%添加弧线段
while abs(abs(theta_add)-hudu) > deviation && abs(theta_add) < hudu
    theta_add = theta_add + direction*hudu_interval;
    theta = theta0 + theta_add;
    point = [center(1)+R*cos(theta) center(2)+R*sin(theta)];
    uav.planning_route = [uav.planning_route; point];
end
uav.condition = 2;
uav.heading = uav.heading + direction*hudu;
end

