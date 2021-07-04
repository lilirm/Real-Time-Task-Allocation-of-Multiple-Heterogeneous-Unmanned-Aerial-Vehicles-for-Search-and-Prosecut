function [uav] = dubins_path_plan_energy(uav,target,R)  %����·��������,������planning_route������
                                                        %uav/target�ض������˻���Ŀ��,R����������˻�ת��뾶

if uav.condition == 3      %�����Ѵ��ڱ߽紦��״̬�����˻�����Ϊ�����¹滮·��ǰ��Ҫ���ԭ�ȵ�uav.planning_route added 2020/5/28
  uav.planning_route = [];  
end

deviation = 0.01;
[direction,hudu,tangent_site,center] = dubins_msg(uav,target.location,R);
[uav] = compute_energy_consume(uav,hudu,tangent_site,R,target.location);
len_interval = uav.velocity * 0.1;  %0.01����ʱ����
hudu_interval = len_interval/R;
theta0 = atan2(uav.position(2)-center(2),uav.position(1)-center(1));
theta_add = 0;
%��ӻ��߶�
while abs(abs(theta_add)-hudu) > deviation && abs(theta_add) < hudu
    theta_add = theta_add + direction * hudu_interval;
    theta = theta0 + theta_add;
    point = [center(1) + R*cos(theta) center(2) + R*sin(theta)];
    uav.planning_route = [uav.planning_route; point];
end
%���ֱ�߶�
line_angle = atan2(target.location(2)-tangent_site(2),target.location(1)-tangent_site(1));
uav.heading = line_angle;
uav.condition = 2;

if isempty(uav.planning_route)
    start_site = [uav.position(1) uav.position(2)];
else
    start_site = [uav.planning_route(size(uav.planning_route,1),1) uav.planning_route(size(uav.planning_route,1),2)];
end

% start_site = [uav.planning_route(size(uav.planning_route,1),1) uav.planning_route(size(uav.planning_route,1),2)];
tangent_now_dis = 0;
tangent_target_dis = sqrt((target.location(2)-tangent_site(2))^2 + (target.location(1)-tangent_site(1))^2);
while abs(tangent_now_dis-tangent_target_dis) > deviation && tangent_now_dis < tangent_target_dis
    new_point = [start_site(1) + len_interval*cos(line_angle) start_site(2) + len_interval*sin(line_angle)];
    uav.planning_route = [uav.planning_route; new_point];
    start_site = new_point;
    tangent_now_dis = sqrt((start_site(2)-tangent_site(2))^2 + (start_site(1)-tangent_site(1))^2);
end

end

function [uav] = compute_energy_consume(uav,hudu,tangent_site,R,targetLocation)      %����dubins���߼������·���ϵ��ܺ�
%�����μ����ܺģ�����Բ�ܶ�+����ֱ�߶�
%1��Բ���Σ��ܺĹ�ʽ��E=T[(c_1+c_2/(g^2*R^2))V^3+c_2/V]
     c_1=9.26*10^(-4);   %������������
     c_2=2250;           %������������
     g=9.8;              %�������ٶ�
     V=uav.velocity;
     T=(hudu.*R)./V;     %Բ����ʱ��
     E1=T.*((c_1+c_2./(g.^2.*R.^2))*V.^3+c_2./V);
%2��ֱ�߶Σ��ܺĹ�ʽ��E=T.*(c_1.*V.^3+c_2./V)
    dis=sqrt((targetLocation(2)-tangent_site(2))^2+(targetLocation(1)-tangent_site(1))^2);  %�е���Ŀ���֮��ľ���
    T1=dis./V;             %ֱ�߶�ʱ��
    E2=T1.*(c_1.*V.^3+c_2./V);
    uav.energyConsume = uav.energyConsume+E1+E2;
end

