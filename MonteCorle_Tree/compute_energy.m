function [energy] = compute_energy(uav,targetLocation) 
%�������˻���Ŀ��λ�õ��ܺ�  uav�ض����˻�
%��2�������1�����˻������ָ��Ŀ�꣨����ʹ��dubins�����ܺģ�  2�����˻�����ǲ�ָ��Ŀ�꣨����dubins_EAT�����ܺģ�

x = uav.position(1);               %uavλ�����꼰�����
y = uav.position(2);
psi = uav.heading;
%Rmin = uav.turnRadius;
xt = targetLocation(1);            %Ŀ��λ��
yt = targetLocation(2);

line_angle = atan2(yt-y,xt-x);
if line_angle == psi              %1����һ��ֱ����
    energy = energy_straightLine(uav,targetLocation);
else                              %2������һ��ֱ����
    energy = energy_dubins(uav,targetLocation);
end

end





