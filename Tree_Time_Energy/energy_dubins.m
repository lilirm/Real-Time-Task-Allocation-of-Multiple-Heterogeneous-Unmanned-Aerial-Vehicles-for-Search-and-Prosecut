function [energy] = energy_dubins(uav,targetLocation)   %计算按照dubins曲线飞行能耗
%分两段计算能耗：匀速圆周段+匀速直线段

%1、圆弧段，能耗公式：E=T[(c_1+c_2/(g^2*R^2))V^3+c_2/V]
     c_1=9.26*10^(-4);   %两个常量参数
     c_2=2250;           %两个常量参数
     g=9.8;              %重力加速度
     V=uav.velocity;
     R=uav.turnRadius;
     [direction,hudu,tangent_site,center] = dubins_msg(uav,targetLocation,R);
     T=(hudu.*R)./V;     %圆弧段时间
     E1=T.*((c_1+c_2./(g.^2.*R.^2))*V.^3+c_2./V);
%2、直线段，能耗公式：E=T.*(c_1.*V.^3+c_2./V)
    dis=sqrt((targetLocation(2)-tangent_site(2))^2+(targetLocation(1)-tangent_site(1))^2);  %切点与目标点之间的距离
    T1=dis./V;             %直线段时间
    E2=T1.*(c_1.*V.^3+c_2./V);
    energy = E1+E2;
end


