function [radius] =find_radius1(uav,target,arrivalTime,l)  %uav/target���ض����˻���Ŀ�꣬arrivalTimeΪ���������EAT
%�̶�ʱ�������˻��ӵ�ǰ�㵽Ŀ�������ת��뾶
%����uav��ת��뾶��ʹ��ͬʱ���ʹ�ö��ַ�����
%��find_radius.m��֮ͬ��;�˴�ʹ�þ����ʱ�����·������ǰ��ǰ�߼���ʱ��ʹ���ܳ���/�ٶȣ�Բ���γ��ȵ���ֱ�ߴ�����������

deviation = 0.01;
type = 0;
cost_time = arrivalTime;                %cost�����������EAT(����formcoalition3) added in 2020/5/26
short_d_max_r = short_D_max_R(uav,target)-10*deviation;   %��dubins·�������뾶
short_d_max_r_t = dubins_EAT(uav,target.location,short_d_max_r);  %�������뾶ʱ��·��ʱ�� added in 2020/5/26
if short_d_max_r_t < cost_time
    type = 2;
end
R_min = uav.turnRadius;
t_min = dubins_EAT(uav,target.location,R_min);  %���ַ��½�
R_max = 0;
t_max = 0;
if type==0
    R_max = short_d_max_r;
    t_max = short_d_max_r_t;
else
    R_max = l/2;
    t_max = dubins_EAT(uav,target.location,R_max);  %���ַ��Ͻ�
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
    t = dubins_EAT(uav,target.location,R);
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


