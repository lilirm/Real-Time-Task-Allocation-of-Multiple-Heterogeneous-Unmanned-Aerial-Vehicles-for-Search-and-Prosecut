function [energy] = energy_dubins(uav,targetLocation)   %���㰴��dubins���߷����ܺ�
%�����μ����ܺģ�����Բ�ܶ�+����ֱ�߶�

%1��Բ���Σ��ܺĹ�ʽ��E=T[(c_1+c_2/(g^2*R^2))V^3+c_2/V]
     c_1=9.26*10^(-4);   %������������
     c_2=2250;           %������������
     g=9.8;              %�������ٶ�
     V=uav.velocity;
     R=uav.turnRadius;
     [direction,hudu,tangent_site,center] = dubins_msg(uav,targetLocation,R);
     T=(hudu.*R)./V;     %Բ����ʱ��
     E1=T.*((c_1+c_2./(g.^2.*R.^2))*V.^3+c_2./V);
%2��ֱ�߶Σ��ܺĹ�ʽ��E=T.*(c_1.*V.^3+c_2./V)
    dis=sqrt((targetLocation(2)-tangent_site(2))^2+(targetLocation(1)-tangent_site(1))^2);  %�е���Ŀ���֮��ľ���
    T1=dis./V;             %ֱ�߶�ʱ��
    E2=T1.*(c_1.*V.^3+c_2./V);
    energy = E1+E2;
end


