function [uav] = border_path_plan_energy(center,hudu,direction,uav,time_interval) %uav�ض����˻�
deviation = 0.01;
R = uav.turnRadius;
[uav] = compute_energy_consume(uav,hudu,R);
len_interval = uav.velocity * time_interval;
hudu_interval = len_interval/R;
theta0 = atan2(uav.position(2)-center(2),uav.position(1)-center(1));
theta_add = 0;
%��ӻ��߶�
while abs(abs(theta_add)-hudu) > deviation && abs(theta_add) < hudu
    theta_add = theta_add + direction*hudu_interval;
    theta = theta0 + theta_add;
    point = [center(1)+R*cos(theta) center(2)+R*sin(theta)];
    uav.planning_route = [uav.planning_route; point];
end
uav.condition = 3;
uav.heading = uav.heading + direction*hudu;
end

function [uav] = compute_energy_consume(uav,hudu,R)      %����dubins���߼������·���ϵ��ܺ�

%Բ���Σ��ܺĹ�ʽ��E=T[(c_1+c_2/(g^2*R^2))V^3+c_2/V]
     c_1=9.26*10^(-4);   %������������
     c_2=2250;           %������������
     g=9.8;              %�������ٶ�
     V=uav.velocity;
     T=(hudu.*R)./V;     %Բ����ʱ��
     E=T.*((c_1+c_2./(g.^2.*R.^2))*V.^3+c_2./V);
     uav.energyConsume = uav.energyConsume+E;
end
