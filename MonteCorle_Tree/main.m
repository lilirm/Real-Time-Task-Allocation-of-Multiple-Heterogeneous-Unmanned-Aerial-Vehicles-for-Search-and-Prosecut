clc
clear

[uav,target,l,b] = initialize();

targetResource = [];
for iTarget = 1:length(target)
        targetResource = [targetResource; target(iTarget).resource];
end

runTime = 110;  %仿真时间
dt=0.1;          %采样间隔
deviation =0.01;  %误差

for t = 0:dt:runTime
    
    find_targets = [];
    count = 0;
    %1、执行搜索
    for iUav = 1:length(uav)
        %if uav(iUav).condition == 1
        %所有状态的无人机都可执行搜索任务，只是执行任务中的无人机不能作为候选者
        [detect_target] = searchtarget(uav(iUav),target);
        if ~isempty(detect_target)
            count = count+1;
            find_targets(count).id = iUav;
            find_targets(count).detect_target = detect_target;
        end
        %end
    end
    
    % t时刻没有无人机侦察到目标，各自走一步
    if isempty(find_targets)
       for iUav=1:length(uav)
          uav(iUav) = move(uav(iUav),dt,l,b);
       end
       continue
    end
    
    %2、避免冲突
    UAV_task = clashavoid(find_targets,uav,target);   %解决死锁问题
    
    %3、构建联盟候选集,不考虑通信要求
    candidate = [];
    for iUav = 1:length(uav)
        if uav(iUav).condition ~= 2
            candidate = [candidate iUav];
        end
    end
    for cp = 1:length(UAV_task)        %去除所有的leader
        temp = find(candidate==UAV_task(cp).id);
        if ~isempty(temp)
            candidate(temp(1)) = [];
        end
    end
    
    %4、组建联盟
    for cp = 1:length(UAV_task)
        leader = UAV_task(cp).id;             %leader uav id
        attack_target = UAV_task(cp).target;  %攻击目标
        if UAV_task(cp).needcoalition == 0    %需要组建联盟
            target_candidate = candidate;     %此目标的候选集
            if uav(leader).condition ~= 2     %把leader加入候选集
                target_candidate = [leader target_candidate];
            end
            candidate_resource = zeros(1,size(uav(leader).resource,2)); %计算候选集总资源，是否满足目标需求，如若满足组建联盟
            for i = 1:length(target_candidate)
                candidate_resource = candidate_resource + uav(target_candidate(i)).resource;
            end
            if candidate_resource-target(attack_target).resource >= 0
                %满足目标资源需求，组建联盟
                [coalition,cost] = formcoalition(uav,target,attack_target,target_candidate);
                %[coalition,cost] = formcoalition1(uav,target,attack_target,target_candidate);
                %[coalition,cost] = formcoalition2(uav,target,attack_target,target_candidate);
               % path_plan(attack_target,coalition,cost);
            else
                continue
            end
        else
            %单个uav已满足目标资源需求，无需组建联盟
            coalition = leader;
            cost = dubins_len(uav(leader),target(attack_target).location,uav(leader).turnRadius);  %此处的cost表示长度
        end
        [uav,target] = path_plan(attack_target,coalition,cost,uav,target,l);
        
        coalitionResource = [];    %联盟总资源
        for j=1:length(coalition)
            coalitionResource = [coalitionResource; uav(coalition(j)).resource];
        end
        resource_sum = sum(coalitionResource);  %对矩阵按列求和
        for i=1:length(coalition)
            uav(coalition(i)).condition = 2;    %无人机变为攻击状态
            if ismember(coalition(i),candidate)  %去除candidate中已分配的无人机
                candidate(candidate==coalition(i)) = [];
            end
            %uav的资源消耗
            for k=1:length(resource_sum)
                uav(coalition(i)).resource(k) = uav(coalition(i)).resource(k)-((uav(coalition(i)).resource(k))/resource_sum(k))*target(attack_target).resource(k);
            end
        end
        target(attack_target).resource(1,:) = 0;   %目标资源清零
        targetResource(attack_target,:) = 0;
        target(attack_target).visit = 1;   %目标状态，1表示已被攻击
        
        if ~ismember(leader,coalition) && uav(leader).condition~=2
            candidate = [candidate leader];     %leader不在coalition中并且leader不是联盟状态，把leader加入候选集
        end
        
        fprintf('攻击目标 %d\n',attack_target);
    end
    % plotscene1(uav,target,l,b);
    %每个uav走一步
    for iUav=1:length(uav)
        uav(iUav) = move(uav(iUav),dt,l,b);
    end
    
    %判断目标是否全部被执行，终止程序运行
%     if sum(sum(targetResource))==0
%         break
%     end
end

fprintf('总用时： %f\n',t);
plotscene2(uav,target,l,b);
