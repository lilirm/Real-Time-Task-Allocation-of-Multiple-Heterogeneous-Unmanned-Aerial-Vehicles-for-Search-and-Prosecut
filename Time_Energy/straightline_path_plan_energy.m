function [uav] = straightline_path_plan_energy(uav,target)   %uav/target特定无人机/目标
%直线段路径规划，无人机方向正好指向目标

if uav.condition == 3      %对于已处在边界处理状态的无人机，在为其重新规划路径前，要清空原先的uav.planning_route added 2020/5/28
  uav.planning_route = [];  
end

deviation = 0.01;
uav.condition = 2;
uavLocation = uav.position;
line_angle = uav.heading;
len_interval = uav.velocity * 0.1;
[uav] = compute_energy_consume(uav,target);

start_site = [uavLocation(1) uavLocation(2)];
tangent_now_dis = 0;
tangent_target_dis = sqrt((target.location(2)-uavLocation(2))^2 + (target.location(1)-uavLocation(1))^2);
while abs(tangent_now_dis-tangent_target_dis) > deviation && tangent_now_dis < tangent_target_dis
    new_point = [start_site(1) + len_interval*cos(line_angle) start_site(2) + len_interval*sin(line_angle)];
    uav.planning_route = [uav.planning_route; new_point];
    start_site = new_point;
    tangent_now_dis = sqrt((start_site(2)-tangent_site(2))^2 + (start_site(1)-tangent_site(1))^2);
end
end

function [uav] = compute_energy_consume(uav,target)      %计算直线段路径上的能耗
%直线段，能耗公式：E=T.*(c_1.*V.^3+c_2./V)
    c_1=9.26*10^(-4);   %两个常量参数
    c_2=2250;           %两个常量参数
    V=uav.velocity;
    targetLocation = target.location;
    uavLocation = uav.position;
    dis=sqrt((targetLocation(2)-uavLocation(2))^2+(targetLocation(1)-uavLocation(1))^2);  %无人机与目标点之间的距离
    T=dis./V;             %直线段时间
    E=T.*(c_1.*V.^3+c_2./V);
    uav.energyConsume = uav.energyConsume+E;
end

