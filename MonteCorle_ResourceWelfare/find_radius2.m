function [radius] =find_radius2(uav,target,arrivalTime,l)  %uav/target���ض����˻���Ŀ�꣬arrivalTimeΪ���������EAT
%�̶�ʱ�������˻��ӵ�ǰ�㵽Ŀ�������ת��뾶
%����uav��ת��뾶��ʹ��ͬʱ������

targetLocation = target.location;
turnRadius = uav.turnRadius;
time = dubins_EAT(uav,targetLocation,turnRadius);

while time<arrivalTime
    turnRadius = turnRadius + 0.1;        %�����ֵ���Ұ뾶
    time = dubins_EAT(uav,targetLocation,turnRadius);
end
radius = turnRadius;
end






