function [uav] = straightline_path_plan_energy(uav,target)   %uav/target�ض����˻�/Ŀ��
%ֱ�߶�·���滮�����˻���������ָ��Ŀ��

if uav.condition == 3      %�����Ѵ��ڱ߽紦��״̬�����˻�����Ϊ�����¹滮·��ǰ��Ҫ���ԭ�ȵ�uav.planning_route added 2020/5/28
  uav.planning_route = [];  
end

deviation = 0.01;
uav.condition = 2;
uavLocation = uav.position;
line_angle = uav.heading;
len_interval = uav.velocity * 0.1;
[uav] = compute_energy_consume(uav,target);

start_site = [uavLocation(1) uavLocation(2)];
tangent_now_dis = 0;
tangent_target_dis = sqrt((target.location(2)-uavLocation(2))^2 + (target.location(1)-uavLocation(1))^2);
while abs(tangent_now_dis-tangent_target_dis) > deviation && tangent_now_dis < tangent_target_dis
    new_point = [start_site(1) + len_interval*cos(line_angle) start_site(2) + len_interval*sin(line_angle)];
    uav.planning_route = [uav.planning_route; new_point];
    start_site = new_point;
    tangent_now_dis = sqrt((start_site(2)-tangent_site(2))^2 + (start_site(1)-tangent_site(1))^2);
end
end

function [uav] = compute_energy_consume(uav,target)      %����ֱ�߶�·���ϵ��ܺ�
%ֱ�߶Σ��ܺĹ�ʽ��E=T.*(c_1.*V.^3+c_2./V)
    c_1=9.26*10^(-4);   %������������
    c_2=2250;           %������������
    V=uav.velocity;
    targetLocation = target.location;
    uavLocation = uav.position;
    dis=sqrt((targetLocation(2)-uavLocation(2))^2+(targetLocation(1)-uavLocation(1))^2);  %���˻���Ŀ���֮��ľ���
    T=dis./V;             %ֱ�߶�ʱ��
    E=T.*(c_1.*V.^3+c_2./V);
    uav.energyConsume = uav.energyConsume+E;
end

