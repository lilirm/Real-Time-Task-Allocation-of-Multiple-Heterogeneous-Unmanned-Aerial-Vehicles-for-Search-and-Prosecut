function [uav] = dubins_path_plan(uav,target,R)  %计算路径点坐标,并放入planning_route属性中
deviation = 0.01;
[direction,hudu,tangent_site,center] = dubins_msg(uav,target.location,R);
len_interval = uav.velocity * 0.1;  %0.01采样时间间隔
hudu_interval = len_interval/R;
theta0 = atan2(uav.position(2)-center(2),uav.position(1)-center(1));
theta_add = 0;
%添加弧线段
while abs(abs(theta_add)-hudu) > deviation && abs(theta_add) < hudu
    theta_add = theta_add + direction * hudu_interval;
    theta = theta0 + theta_add;
    point = [center(1) + R*cos(theta) center(2) + R*sin(theta)];
    uav.planning_route = [uav.planning_route; point];
end
%添加直线段
line_angle = atan2(target.location(2)-tangent_site(2),target.location(1)-tangent_site(1));
uav.heading = line_angle;
uav.condition = 2;

start_site = [uav.planning_route(size(uav.planning_route,1),1) uav.planning_route(size(uav.planning_route,1),2)];
tangent_now_dis = 0;
tangent_target_dis = sqrt((target.location(2)-tangent_site(2))^2 + (target.location(1)-tangent_site(1))^2);
while abs(tangent_now_dis-tangent_target_dis) > deviation && tangent_now_dis < tangent_target_dis
    new_point = [start_site(1) + len_interval*cos(line_angle) start_site(2) + len_interval*sin(line_angle)];
    uav.planning_route = [uav.planning_route; new_point];
    start_site = new_point;
    tangent_now_dis = sqrt((start_site(2)-tangent_site(2))^2 + (start_site(1)-tangent_site(1))^2);
end

end

