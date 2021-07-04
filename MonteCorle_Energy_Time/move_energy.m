function [uav,target] = move_energy(uav,target,time_interval,l,b)   %uav�ض����˻�,target����Ŀ��
uav.path = [uav.path; uav.position];
if uav.condition == 1
    uav.position = uav.position + uav.velocity * time_interval * [cos(uav.heading) sin(uav.heading)];
    [uav] = compute_energy_consume(uav,time_interval);
    %�߽紦��
    uav = border_process_energy(uav,l,b,time_interval);
else
    uav.position = uav.planning_route(1,:);
    uav.planning_route(1,:) = [];
    if size(uav.planning_route,1) == 0
        uav.condition = 1;              %תΪ����״̬
        if uav.target ~= 0              %Ŀ��˿̱�ִ��
            fprintf('Ŀ�� %d ��ִ��\n',uav.target);
            target(uav.target).isAttacked=1;
            uav.target=0;         
        end
    end
end
%%%%%%%%%%%%%�ж����˻��˿̵�λ���Ƿ���Ŀ�괦%%%%%%%%%%%%%%%%%%%%%%%%
% for iTarget=1:length(target)
%     if norm(uav.position-target(iTarget).location)==0
%          target(iTarget).isAttacked=1;
%          fprintf('Ŀ�� %d ��ִ��\n',iTarget);
%          break;
%     end
% end
end

function [uav] = compute_energy_consume(uav,time_interval)      %����dtʱ���ڵ��ܺ�
%ֱ�߶Σ��ܺĹ�ʽ��E=T.*(c_1.*V.^3+c_2./V)

    c_1=9.26*10^(-4);   %������������
    c_2=2250;           %������������
    V=uav.velocity;
    E=time_interval.*(c_1.*V.^3+c_2./V);
    uav.energyConsume = uav.energyConsume+E;
end
