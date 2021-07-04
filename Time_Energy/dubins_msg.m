function [direction,hudu,tangent_site,center] = dubins_msg(uav,targetLocation,Rmin)
x = uav.position(1);               %uavλ�����꼰�����
y = uav.position(2);
psi = uav.heading;
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
vec1 = [x-xc,y-yc];
direction = sign(vec1(1)*sin(psi)-vec1(2)*cos(psi));  %Բ������1��ʾ��ʱ�룬-1��ʾ˳ʱ��
hudu = theta;
tangent_site = [xe ye];
center = [xc yc];
%len = Rmin*theta+sqrt((xt-xe)^2+(yt-ye)^2);  %·������=Բ������+ֱ�߳���
end

