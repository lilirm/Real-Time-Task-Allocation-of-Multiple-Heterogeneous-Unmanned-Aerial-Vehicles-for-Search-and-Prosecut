function [energy] = energy_straightLine(uav,targetLocation)   %计算匀速直线飞行能耗
     c_1=9.26*10^(-4);   %两个常量参数
     c_2=2250;           %两个常量参数
     V=uav.velocity;
%直线段，能耗公式：E=T.*(c_1.*V.^3+c_2./V)
    dis=sqrt((targetLocation(2)-uav.position(2))^2+(targetLocation(1)-uav.position(1))^2);  %无人机与目标点之间的距离
    T1=dis./V;             %直线段时间
    energy=T1.*(c_1.*V.^3+c_2./V);
end

