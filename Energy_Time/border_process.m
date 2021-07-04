function [uav] = border_process(uav,l,b,time_interval)  %uav特定无人机
border = zeros(2,2);
% border(1,1) = -l/2;
% border(1,2) = l/2;
% border(2,1) = -b/2;
% border(2,2) = b/2;

border(1,1) = 0;
border(1,2) = 3200;
border(2,1) = 0;
border(2,2) = 3200;

position = uav.position;
phi = uav.heading;
R = uav.turnRadius;
phi = mod(phi,2*pi);  %把角度变为（0,2pi）

theta_reduced = [0 -pi/2 pi pi/2];
type = -1;
theta = phi;
temp = 0;
if position(2) >= border(2,2) && phi>0 && phi < pi  %大于y的上界
    type = 0;
    temp = border(1,2) - position(1);
elseif position(1) >= border(1,2) && ((phi>0 && phi<(pi/2)) || (phi>(3*pi/2) && phi<=(2*pi)))
    type = 1;     %大于x上界
    temp = position(2) - border(2,1);
elseif position(2) <= border(2,1) && phi >= pi && phi <= 2*pi
    type = 2;     %小于y下界
    temp = position(1) - border(1,1);
elseif position(1) <= border(1,1) && phi >= pi/2 && phi <= (3*pi/2)
    type = 3;     %小于x下界
    temp = border(2,2) - position(2);
end

if type ~= -1
    theta =  mod((theta-theta_reduced(type+1)),(2*pi));  %theta为速度方向顺时针旋转到边界线的弧度
    %确定圆心和对应的顺时针逆时针，以及弧度
    c1 = [position(1)+R*sin(phi) position(2)-R*cos(phi)];
    [hudu1,direction1] = border_hudu(c1,position,phi,theta,R,temp,type,border);
    
    c2 = [position(1)-R*sin(phi) position(2)+R*cos(phi)];
    [hudu2,direction2] = border_hudu(c2,position,phi,theta,R,temp,type,border);
    
    if hudu1 > hudu2
        uav = border_path_plan(c2,hudu2,direction2,uav,time_interval);
    else
        uav = border_path_plan(c1,hudu1,direction1,uav,time_interval);
    end
end

end

