%Resource welfare based task allocation算法实现
clc
clear
[uav,target,l,b] = initialize();  %初始化无人机、目标、任务区域
runTime = 200;                    %仿真时间
dt=0.1;                           %采样间隔
deviation =0.01;                  %误差

for t = 0:dt:runTime
    
    %判断目标是否全部被执行，终止程序运行
    count=0;
    for i= 1:length(target)
        count = count + target(i).isAttacked;
    end
    if count == length(target)
        fprintf('所有任务都已被执行，程序结束\n');
        break;
    end
    
    %plotscene1(uav,target,l,b);
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
          [uav(iUav),target] = move_energy(uav(iUav),target,dt,l,b);
       end
       continue
    end
    
    %2、避免冲突
    UAV_task = clashavoid1(find_targets,uav,target);   %解决死锁问题,保证每个被侦察到的目标只分配给一个无人机
    
    %3、构建联盟候选集,不考虑通信要求,此处不合理，针对每一个目标都应该进行一次候选集组成
    
    %4、组建联盟
    for cp = 1:length(UAV_task)
        leader = UAV_task(cp).id;             %leader uav id
        attack_target = UAV_task(cp).target;  %攻击目标
        if UAV_task(cp).needcoalition == 0    %需要组建联盟
            %target_candidate = candidate;     %此目标的联盟候选集
            target_candidate = coalitionCandidate(UAV_task,uav,target,attack_target);     %3、构建联盟候选集,不考虑通信要求.此目标的联盟候选集
            if uav(leader).condition ~= 2     %把leader加入候选集
                target_candidate = [leader target_candidate];
            end
            candidate_resource = zeros(1,size(uav(leader).resource,2)); %计算候选集总资源，是否满足目标需求，如若满足组建联盟
            for i = 1:length(target_candidate)
                candidate_resource = candidate_resource + uav(target_candidate(i)).resource;
            end
            if candidate_resource-target(attack_target).resource >= 0
                %满足目标资源需求，组建联盟
                tic
                [coalition,cost,maxUavId,uav] = formcoalition4(uav,target,attack_target,target_candidate);  % added 2020/5/26
                [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId);
                toc
            else
                continue
            end
        else
            %单个uav已满足目标资源需求，无需组建联盟
            coalition = leader;
            cost = compute_EAT(uav(leader),target(attack_target).location,uav(leader).turnRadius); % added 2020/5/26 cost表示时间
            [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,leader);
            %更新资源 2020/6/4
            uav(leader).resource = uav(leader).resource - target(attack_target).resource;
        end
        %[uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l);
        
        coalitionResource = [];    %联盟总资源
        for j=1:length(coalition)
            coalitionResource = [coalitionResource; uav(coalition(j)).resource];
        end
        resource_sum = sum(coalitionResource);  %对矩阵按列求和
        for i=1:length(coalition)
            uav(coalition(i)).condition = 2;    %无人机变为攻击状态
            %uav的资源消耗，按比例分配 (Resource Welfare中不需要，已在formcoalition4中更新资源数量)
%             for k=1:length(resource_sum)
%                 uav(coalition(i)).resource(k) = uav(coalition(i)).resource(k)-((uav(coalition(i)).resource(k))/resource_sum(k))*target(attack_target).resource(k);
%             end
        end
        target(attack_target).visit = 1;   %目标状态，1表示已被分配      
        fprintf('目标 %d 被分配\n',attack_target);
    end
    %plotscene1(uav,target,l,b);
    %每个uav走一步
    for iUav=1:length(uav)
        [uav(iUav),target] = move_energy(uav(iUav),target,dt,l,b);
    end
    
end

totalEnergyConsume = 0;              %统计所有无人机总能耗
for iUav = 1:length(uav)
    totalEnergyConsume = totalEnergyConsume + uav(iUav).energyConsume;
end

fprintf('总用时T=：%f\n',t);
fprintf('规划用时T=：%f\n',toc);
fprintf('总能耗E=：%f\n',totalEnergyConsume);
plotscene3(uav,target,l,b);
