%Resource welfare based task allocation�㷨ʵ��
clc
clear
[uav,target,l,b] = initialize();  %��ʼ�����˻���Ŀ�ꡢ��������
runTime = 200;                    %����ʱ��
dt=0.1;                           %�������
deviation =0.01;                  %���

for t = 0:dt:runTime
    
    %�ж�Ŀ���Ƿ�ȫ����ִ�У���ֹ��������
    count=0;
    for i= 1:length(target)
        count = count + target(i).isAttacked;
    end
    if count == length(target)
        fprintf('���������ѱ�ִ�У��������\n');
        break;
    end
    
    %plotscene1(uav,target,l,b);
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
          [uav(iUav),target] = move_energy(uav(iUav),target,dt,l,b);
       end
       continue
    end
    
    %2�������ͻ
    UAV_task = clashavoid1(find_targets,uav,target);   %�����������,��֤ÿ������쵽��Ŀ��ֻ�����һ�����˻�
    
    %3���������˺�ѡ��,������ͨ��Ҫ��,�˴����������ÿһ��Ŀ�궼Ӧ�ý���һ�κ�ѡ�����
    
    %4���齨����
    for cp = 1:length(UAV_task)
        leader = UAV_task(cp).id;             %leader uav id
        attack_target = UAV_task(cp).target;  %����Ŀ��
        if UAV_task(cp).needcoalition == 0    %��Ҫ�齨����
            %target_candidate = candidate;     %��Ŀ������˺�ѡ��
            target_candidate = coalitionCandidate(UAV_task,uav,target,attack_target);     %3���������˺�ѡ��,������ͨ��Ҫ��.��Ŀ������˺�ѡ��
            if uav(leader).condition ~= 2     %��leader�����ѡ��
                target_candidate = [leader target_candidate];
            end
            candidate_resource = zeros(1,size(uav(leader).resource,2)); %�����ѡ������Դ���Ƿ�����Ŀ���������������齨����
            for i = 1:length(target_candidate)
                candidate_resource = candidate_resource + uav(target_candidate(i)).resource;
            end
            if candidate_resource-target(attack_target).resource >= 0
                %����Ŀ����Դ�����齨����
                tic
                [coalition,cost,maxUavId,uav] = formcoalition4(uav,target,attack_target,target_candidate);  % added 2020/5/26
                [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId);
                toc
            else
                continue
            end
        else
            %����uav������Ŀ����Դ���������齨����
            coalition = leader;
            cost = compute_EAT(uav(leader),target(attack_target).location,uav(leader).turnRadius); % added 2020/5/26 cost��ʾʱ��
            [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,leader);
            %������Դ 2020/6/4
            uav(leader).resource = uav(leader).resource - target(attack_target).resource;
        end
        %[uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l);
        
        coalitionResource = [];    %��������Դ
        for j=1:length(coalition)
            coalitionResource = [coalitionResource; uav(coalition(j)).resource];
        end
        resource_sum = sum(coalitionResource);  %�Ծ��������
        for i=1:length(coalition)
            uav(coalition(i)).condition = 2;    %���˻���Ϊ����״̬
            %uav����Դ���ģ����������� (Resource Welfare�в���Ҫ������formcoalition4�и�����Դ����)
%             for k=1:length(resource_sum)
%                 uav(coalition(i)).resource(k) = uav(coalition(i)).resource(k)-((uav(coalition(i)).resource(k))/resource_sum(k))*target(attack_target).resource(k);
%             end
        end
        target(attack_target).visit = 1;   %Ŀ��״̬��1��ʾ�ѱ�����      
        fprintf('Ŀ�� %d ������\n',attack_target);
    end
    %plotscene1(uav,target,l,b);
    %ÿ��uav��һ��
    for iUav=1:length(uav)
        [uav(iUav),target] = move_energy(uav(iUav),target,dt,l,b);
    end
    
end

totalEnergyConsume = 0;              %ͳ���������˻����ܺ�
for iUav = 1:length(uav)
    totalEnergyConsume = totalEnergyConsume + uav(iUav).energyConsume;
end

fprintf('����ʱT=��%f\n',t);
fprintf('�滮��ʱT=��%f\n',toc);
fprintf('���ܺ�E=��%f\n',totalEnergyConsume);
plotscene3(uav,target,l,b);
