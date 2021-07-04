function [radius] =find_radius1(uav,target,arrivalTime,l)  %uav/target是特定无人机与目标，arrivalTime为联盟中最大EAT
%固定时间内无人机从当前点到目标点所需转弯半径
%调整uav的转弯半径，使其同时到达，使用二分法处理
%与find_radius.m不同之处;此处使用具体的时间调整路径，而前者前者计算时间使用总长度/速度，圆弧段长度当做直线处理，可能有误

deviation = 0.01;
type = 0;
cost_time = arrivalTime;                %cost即联盟中最大EAT(对于formcoalition3) added in 2020/5/26
short_d_max_r = short_D_max_R(uav,target)-10*deviation;   %短dubins路径，最大半径
short_d_max_r_t = dubins_EAT(uav,target.location,short_d_max_r);  %计算最大半径时，路径时间 added in 2020/5/26
if short_d_max_r_t < cost_time
    type = 2;
end
R_min = uav.turnRadius;
t_min = dubins_EAT(uav,target.location,R_min);  %二分法下界
R_max = 0;
t_max = 0;
if type==0
    R_max = short_d_max_r;
    t_max = short_d_max_r_t;
else
    R_max = l/2;
    t_max = dubins_EAT(uav,target.location,R_max);  %二分法上界
end

t = t_min;
R = R_min;
if t_min>cost_time || t_max<cost_time
    fprintf('error \n');
    fprintf('t_min=%2.2f,t_max=%2.2f,cost_time=%2.2f\n',t_min,t_max,cost_time);
    %退出程序执行
end
while abs(t-cost_time) > deviation
    if t<cost_time
        t_min = t;
        R_min = R;
    end
    if t>cost_time
        t_max = t;
        R_max = R;
    end
    R = (R_min+R_max)/2;
    t = dubins_EAT(uav,target.location,R);
end
radius = R;
end

function [max_R] = short_D_max_R(uav,target)
%返回短dubins路径的最大半径
phi0 = mod(uav.heading,2*pi);  %从（0,2pi）映射到（-pi,pi）
if phi0 > pi
    phi0 = phi0-2*pi;
end
r_target = atan2(target.location(2)-uav.position(2),target.location(1)-uav.position(1));  %目标点弧度
dis = sqrt((target.location(2)-uav.position(2))^2+(target.location(1)-uav.position(1))^2);
temp = cos((pi/2)-abs(phi0-r_target));
max_R = dis/2/temp;
end


