function [uav,target] = move_energy(uav,target,time_interval,l,b)   %uav特定无人机,target所有目标
uav.path = [uav.path; uav.position];
if uav.condition == 1
    uav.position = uav.position + uav.velocity * time_interval * [cos(uav.heading) sin(uav.heading)];
    [uav] = compute_energy_consume(uav,time_interval);
    %边界处理
    uav = border_process_energy(uav,l,b,time_interval);
else
    uav.position = uav.planning_route(1,:);
    uav.planning_route(1,:) = [];
    if size(uav.planning_route,1) == 0
        uav.condition = 1;              %转为搜索状态
        if uav.target ~= 0              %目标此刻被执行
            fprintf('目标 %d 被执行\n',uav.target);
            target(uav.target).isAttacked=1;
            uav.target=0;         
        end
    end
end
%%%%%%%%%%%%%判断无人机此刻的位置是否在目标处%%%%%%%%%%%%%%%%%%%%%%%%
% for iTarget=1:length(target)
%     if norm(uav.position-target(iTarget).location)==0
%          target(iTarget).isAttacked=1;
%          fprintf('目标 %d 被执行\n',iTarget);
%          break;
%     end
% end
end

function [uav] = compute_energy_consume(uav,time_interval)      %计算dt时间内的能耗
%直线段，能耗公式：E=T.*(c_1.*V.^3+c_2./V)

    c_1=9.26*10^(-4);   %两个常量参数
    c_2=2250;           %两个常量参数
    V=uav.velocity;
    E=time_interval.*(c_1.*V.^3+c_2./V);
    uav.energyConsume = uav.energyConsume+E;
end
