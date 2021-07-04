function [arrivalTime] = compute_EAT(uav,targetLocation,Rmin) %计算无人机到目标位置的时间  uav特定无人机
%分2种情况：1、无人机航向角指向目标（无需使用dubins来求时间）  2、无人机航向角不指向目标（调用dubins_EAT来求时间）

x = uav.position(1);               %uav位置坐标及航向角
y = uav.position(2);
psi = uav.heading;
v = uav.velocity;
%Rmin = uav.turnRadius;
xt = targetLocation(1);            %目标位置
yt = targetLocation(2);

line_angle = atan2(yt-y,xt-x);
if line_angle == psi              %1、在一条直线上
    dis=sqrt((yt-y)^2+(xt-x)^2);  %无人机与目标点之间的距离
    arrivalTime = dis./v;
else                              %2、不在一条直线上
    arrivalTime = dubins_EAT(uav,targetLocation,Rmin);
end

end



