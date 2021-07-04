clc
clear

[uav,target,l,b] = initialize();

targetResource = [];
for iTarget = 1:length(target)
        targetResource = [targetResource; target(iTarget).resource];
end

runTime = 110;  %����ʱ��
dt=0.1;          %�������
deviation =0.01;  %���

for t = 0:dt:runTime
    
    find_targets = [];
    count = 0;
    %1��ִ������
    for iUav = 1:length(uav)
        %if uav(iUav).condition == 1
        %����״̬�����˻�����ִ����������ֻ��ִ�������е����˻�������Ϊ��ѡ��
        [detect_target] = searchtarget(uav(iUav),target);
        if ~isempty(detect_target)
            count = count+1;
            find_targets(count).id = iUav;
            find_targets(count).detect_target = detect_target;
        end
        %end
    end
    
    % tʱ��û�����˻���쵽Ŀ�꣬������һ��
    if isempty(find_targets)
       for iUav=1:length(uav)
          uav(iUav) = move(uav(iUav),dt,l,b);
       end
       continue
    end
    
    %2�������ͻ
    UAV_task = clashavoid(find_targets,uav,target);   %�����������
    
    %3���������˺�ѡ��,������ͨ��Ҫ��
    candidate = [];
    for iUav = 1:length(uav)
        if uav(iUav).condition ~= 2
            candidate = [candidate iUav];
        end
    end
    for cp = 1:length(UAV_task)        %ȥ�����е�leader
        temp = find(candidate==UAV_task(cp).id);
        if ~isempty(temp)
            candidate(temp(1)) = [];
        end
    end
    
    %4���齨����
    for cp = 1:length(UAV_task)
        leader = UAV_task(cp).id;             %leader uav id
        attack_target = UAV_task(cp).target;  %����Ŀ��
        if UAV_task(cp).needcoalition == 0    %��Ҫ�齨����
            target_candidate = candidate;     %��Ŀ��ĺ�ѡ��
            if uav(leader).condition ~= 2     %��leader�����ѡ��
                target_candidate = [leader target_candidate];
            end
            candidate_resource = zeros(1,size(uav(leader).resource,2)); %�����ѡ������Դ���Ƿ�����Ŀ���������������齨����
            for i = 1:length(target_candidate)
                candidate_resource = candidate_resource + uav(target_candidate(i)).resource;
            end
            if candidate_resource-target(attack_target).resource >= 0
                %����Ŀ����Դ�����齨����
                [coalition,cost] = formcoalition(uav,target,attack_target,target_candidate);
                %[coalition,cost] = formcoalition1(uav,target,attack_target,target_candidate);
                %[coalition,cost] = formcoalition2(uav,target,attack_target,target_candidate);
               % path_plan(attack_target,coalition,cost);
            else
                continue
            end
        else
            %����uav������Ŀ����Դ���������齨����
            coalition = leader;
            cost = dubins_len(uav(leader),target(attack_target).location,uav(leader).turnRadius);  %�˴���cost��ʾ����
        end
        [uav,target] = path_plan(attack_target,coalition,cost,uav,target,l);
        
        coalitionResource = [];    %��������Դ
        for j=1:length(coalition)
            coalitionResource = [coalitionResource; uav(coalition(j)).resource];
        end
        resource_sum = sum(coalitionResource);  %�Ծ��������
        for i=1:length(coalition)
            uav(coalition(i)).condition = 2;    %���˻���Ϊ����״̬
            if ismember(coalition(i),candidate)  %ȥ��candidate���ѷ�������˻�
                candidate(candidate==coalition(i)) = [];
            end
            %uav����Դ����
            for k=1:length(resource_sum)
                uav(coalition(i)).resource(k) = uav(coalition(i)).resource(k)-((uav(coalition(i)).resource(k))/resource_sum(k))*target(attack_target).resource(k);
            end
        end
        target(attack_target).resource(1,:) = 0;   %Ŀ����Դ����
        targetResource(attack_target,:) = 0;
        target(attack_target).visit = 1;   %Ŀ��״̬��1��ʾ�ѱ�����
        
        if ~ismember(leader,coalition) && uav(leader).condition~=2
            candidate = [candidate leader];     %leader����coalition�в���leader��������״̬����leader�����ѡ��
        end
        
        fprintf('����Ŀ�� %d\n',attack_target);
    end
    % plotscene1(uav,target,l,b);
    %ÿ��uav��һ��
    for iUav=1:length(uav)
        uav(iUav) = move(uav(iUav),dt,l,b);
    end
    
    %�ж�Ŀ���Ƿ�ȫ����ִ�У���ֹ��������
%     if sum(sum(targetResource))==0
%         break
%     end
end

fprintf('����ʱ�� %f\n',t);
plotscene2(uav,target,l,b);
