function [radius] = find_radius(uav,target,cost,l)  %uav/target���ض����˻���Ŀ�꣬costΪ������������
%�̶�ʱ�������˻��ӵ�ǰ�㵽Ŀ�������ת��뾶
%����uav��ת��뾶��ʹ��·������ƥ�䣬ʹ�ö��ַ�����

deviation = 0.01;
type = 0;
cost_time = cost/uav.velocity;   %cost·������(����formcoalition 0 1 2)
short_d_max_r = short_D_max_R(uav,target)-10*deviation;   %��dubins·�������뾶
short_d_max_r_t = dubins_len(uav,target.location,short_d_max_r)/uav.velocity;
if short_d_max_r_t < cost_time
    type = 2;
end
R_min = uav.turnRadius;
t_min = dubins_len(uav,target.location,R_min)/uav.velocity;  %���ַ��½�
R_max = 0;
t_max = 0;
if type==0
    R_max = short_d_max_r;
    t_max = short_d_max_r_t;
else
    R_max = l/2;
    t_max = dubins_len(uav,target.location,R_max)/uav.velocity;  %���ַ��Ͻ�
end

t = t_min;
R = R_min;
if t_min>cost_time || t_max<cost_time
    fprintf('error \n');
    fprintf('t_min=%2.2f,t_max=%2.2f,cost_time=%2.2f\n',t_min,t_max,cost_time);
    %�˳�����ִ��
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
    t = dubins_len(uav,target.location,R)/uav.velocity;
end
radius = R;
end

function [max_R] = short_D_max_R(uav,target)
%���ض�dubins·�������뾶
phi0 = mod(uav.heading,2*pi);  %�ӣ�0,2pi��ӳ�䵽��-pi,pi��
if phi0 > pi
    phi0 = phi0-2*pi;
end
r_target = atan2(target.location(2)-uav.position(2),target.location(1)-uav.position(1));  %Ŀ��㻡��
dis = sqrt((target.location(2)-uav.position(2))^2+(target.location(1)-uav.position(1))^2);
temp = cos((pi/2)-abs(phi0-r_target));
max_R = dis/2/temp;
end

