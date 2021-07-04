function [uav] = border_path_plan_energy(center,hudu,direction,uav,time_interval) %uav特定无人机
deviation = 0.01;
R = uav.turnRadius;
[uav] = compute_energy_consume(uav,hudu,R);
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
uav.condition = 3;
uav.heading = uav.heading + direction*hudu;
end

function [uav] = compute_energy_consume(uav,hudu,R)      %根据dubins曲线计算这段路径上的能耗

%圆弧段，能耗公式：E=T[(c_1+c_2/(g^2*R^2))V^3+c_2/V]
     c_1=9.26*10^(-4);   %两个常量参数
     c_2=2250;           %两个常量参数
     g=9.8;              %重力加速度
     V=uav.velocity;
     T=(hudu.*R)./V;     %圆弧段时间
     E=T.*((c_1+c_2./(g.^2.*R.^2))*V.^3+c_2./V);
     uav.energyConsume = uav.energyConsume+E;
end
