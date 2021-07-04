function [energy] = energy_straightLine(uav,targetLocation)   %��������ֱ�߷����ܺ�
     c_1=9.26*10^(-4);   %������������
     c_2=2250;           %������������
     V=uav.velocity;
%ֱ�߶Σ��ܺĹ�ʽ��E=T.*(c_1.*V.^3+c_2./V)
    dis=sqrt((targetLocation(2)-uav.position(2))^2+(targetLocation(1)-uav.position(1))^2);  %���˻���Ŀ���֮��ľ���
    T1=dis./V;             %ֱ�߶�ʱ��
    energy=T1.*(c_1.*V.^3+c_2./V);
end

