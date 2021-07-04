function [arrivalTime] = compute_EAT(uav,targetLocation,Rmin) %�������˻���Ŀ��λ�õ�ʱ��  uav�ض����˻�
%��2�������1�����˻������ָ��Ŀ�꣨����ʹ��dubins����ʱ�䣩  2�����˻�����ǲ�ָ��Ŀ�꣨����dubins_EAT����ʱ�䣩

x = uav.position(1);               %uavλ�����꼰�����
y = uav.position(2);
psi = uav.heading;
v = uav.velocity;
%Rmin = uav.turnRadius;
xt = targetLocation(1);            %Ŀ��λ��
yt = targetLocation(2);

line_angle = atan2(yt-y,xt-x);
if line_angle == psi              %1����һ��ֱ����
    dis=sqrt((yt-y)^2+(xt-x)^2);  %���˻���Ŀ���֮��ľ���
    arrivalTime = dis./v;
else                              %2������һ��ֱ����
    arrivalTime = dubins_EAT(uav,targetLocation,Rmin);
end

end



