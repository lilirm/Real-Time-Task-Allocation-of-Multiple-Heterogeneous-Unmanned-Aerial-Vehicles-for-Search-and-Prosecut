function [arrivalTime] = dubins_EAT(uav,targetLocation,Rmin) %�������˻���Ŀ��λ�õ�ʱ��(Բ����ʱ��+ֱ�߶�ʱ��) added 2020/5/26

x = uav.position(1);               %uavλ�����꼰�����
y = uav.position(2);
psi = uav.heading;
v = uav.velocity;
%Rmin = uav.turnRadius;
xt = targetLocation(1);          %Ŀ��λ��
yt = targetLocation(2);

if sum(cross([cos(psi) sin(psi) 0],[xt-x yt-y 0]))>0
    
    xc = x+Rmin*sin(psi);         %Բ������
    yc = y-Rmin*cos(psi);
    
    theta1 = acos(Rmin/sqrt((xt-xc)^2+(yt-yc)^2));
    theta2 = pi/2-psi;
    theta3 = atan2(yt-yc,xt-xc);
    if theta3<0
        theta3 = theta3+2*pi;
    end

    theta = 2*pi - (theta2-(pi-theta1)+theta3);   %����
    
    if theta>2*pi
        theta = theta-2*pi;
    elseif theta<0
        theta = theta+2*pi;
    end

    xe = xc - Rmin*cos(theta1-(pi-theta3));      %�е�����
    ye = yc - Rmin*sin(theta1-(pi-theta3));

else
    
    xc = x-Rmin*sin(psi);            %Բ��
    yc = y+Rmin*cos(psi);

    theta1 = acos(Rmin/sqrt((xt-xc)^2+(yt-yc)^2));
    theta2 = pi/2-psi;
    theta3 = atan2(yt-yc,xt-xc);
    if theta3<0
        theta3 = theta3+2*pi;
    end

    theta = 2*pi - (theta1-(theta2+theta3));  %����

    if theta>2*pi
        theta = theta-2*pi;
    elseif theta<0
        theta = theta+2*pi;
    end

    xe = xc + Rmin*cos(theta1-theta3);      %�е�����
    ye = yc - Rmin*sin(theta1-theta3);

end

time1=(theta.*Rmin)./v;   %Բ����ʱ��
dis=sqrt((xt-xe)^2+(yt-ye)^2);
time2=dis./v;             %ֱ�߶�ʱ��
arrivalTime=time1+time2;
end

