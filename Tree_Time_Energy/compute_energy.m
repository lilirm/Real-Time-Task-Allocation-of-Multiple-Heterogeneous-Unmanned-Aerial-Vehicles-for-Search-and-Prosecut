function [energy] = compute_energy(uav,targetLocation) 
%计算无人机到目标位置的能耗  uav特定无人机
%分2种情况：1、无人机航向角指向目标（无需使用dubins来求能耗）  2、无人机航向角不指向目标（调用dubins_EAT来求能耗）

x = uav.position(1);               %uav位置坐标及航向角
y = uav.position(2);
psi = uav.heading;
%Rmin = uav.turnRadius;
xt = targetLocation(1);            %目标位置
yt = targetLocation(2);

line_angle = atan2(yt-y,xt-x);
if line_angle == psi              %1、在一条直线上
    energy = energy_straightLine(uav,targetLocation);
else                              %2、不在一条直线上
    energy = energy_dubins(uav,targetLocation);
end

end





