function [uav] = border_process(uav,l,b,time_interval)  %uav�ض����˻�
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
phi = mod(phi,2*pi);  %�ѽǶȱ�Ϊ��0,2pi��

theta_reduced = [0 -pi/2 pi pi/2];
type = -1;
theta = phi;
temp = 0;
if position(2) >= border(2,2) && phi>0 && phi < pi  %����y���Ͻ�
    type = 0;
    temp = border(1,2) - position(1);
elseif position(1) >= border(1,2) && ((phi>0 && phi<(pi/2)) || (phi>(3*pi/2) && phi<=(2*pi)))
    type = 1;     %����x�Ͻ�
    temp = position(2) - border(2,1);
elseif position(2) <= border(2,1) && phi >= pi && phi <= 2*pi
    type = 2;     %С��y�½�
    temp = position(1) - border(1,1);
elseif position(1) <= border(1,1) && phi >= pi/2 && phi <= (3*pi/2)
    type = 3;     %С��x�½�
    temp = border(2,2) - position(2);
end

if type ~= -1
    theta =  mod((theta-theta_reduced(type+1)),(2*pi));  %thetaΪ�ٶȷ���˳ʱ����ת���߽��ߵĻ���
    %ȷ��Բ�ĺͶ�Ӧ��˳ʱ����ʱ�룬�Լ�����
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

