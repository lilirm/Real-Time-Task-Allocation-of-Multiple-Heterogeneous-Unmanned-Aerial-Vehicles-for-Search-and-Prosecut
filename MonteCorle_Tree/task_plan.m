function [missionTime,energyComsume,flag,planTime] = task_plan(uav,target,ur,tr,l,b)   

runTime = 2000;                   %����ʱ��
dt=0.1;                          %�������
deviation =0.01;                 %���
flag=0;                          %��־ȫ�������Ƿ����
planTime = 0;

numUav = length(uav);
numTarget = length(target);

for iUav=1:numUav           %��ʼ�����˻�����Դ
    uav(iUav).resource = ur(iUav,:);
end
for iTarget=1:numTarget     %��ʼ��Ŀ����Դ
    target(iTarget).resource = tr(iTarget,:);
end

for t = 0:dt:runTime
    
    %�ж�Ŀ���Ƿ�ȫ����ִ�У���ֹ��������
    count=0;
    for i= 1:numTarget
        count = count + target(i).isAttacked;
    end
    if count == numTarget
        fprintf('���������ѱ�ִ�У��������\n');
        break;
    end
    
    %plotscene1(uav,target,l,b);
    find_targets = [];
    count = 0;
    %1��ִ������
    for iUav = 1:numUav
        %if uav(iUav).condition == 1
        %����״̬�����˻�����ִ����������ֻ��ִ�������е����˻�������Ϊ��ѡ��
        [detect_target] = searchtarget(uav(iUav),target);
        if ~isempty(detect_target)
            count = count+1;
            find_targets(count).id = iUav;
            find_targets(count).detect_target = detect_target;
            fprintf('��%fsʱ�� %d�����˻�����Ŀ�꣺ \n',t,iUav);
            disp(detect_target);   %����ֱ����fprintf���������Ϊdetec_target��С���ܲ�һ����1
        end
        %end
    end
    
    % tʱ��û�����˻���쵽Ŀ�꣬������һ��
    if isempty(find_targets)
       for iUav=1:numUav
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
        if UAV_task(cp).target == 0
            continue;
        end
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
                [coalition,cost,maxUavId] = formcoalition4(uav,target,attack_target,target_candidate);  % added 2020/6/1
                %[uav,target] = path_plan2(attack_target,coalition,uav,target,l);         %ʱ��û��Ҫ��path_plan2�н����ظ�����
                [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId);
                toc
                planTime = planTime + toc;
            else
                continue
            end
        else
            %����uav������Ŀ����Դ���������齨����
            coalition = leader;
            cost = compute_EAT(uav(leader),target(attack_target).location,uav(leader).turnRadius); % added 2020/5/26 cost��ʾʱ��
            tic
            [uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,leader);
            toc
            planTime = planTime + toc;
        end
        %[uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l);
        
        coalitionResource = [];            %��������Դ
        coalitionNum = length(coalition);  %���˳�Ա����  2020/6/15
        targetResourceRequired = target(attack_target).resource;
        for j=1:coalitionNum
            coalitionResource = [coalitionResource; uav(coalition(j)).resource];
        end
        resourceKindNum = size(coalitionResource,2);   %��Դ������  2020/6/15
        resource_sum = sum(coalitionResource);  %�Ծ��������
        
        %��2����Դ���䷽ʽ  2020/6/15
%         if coalitionNum == 1                    %������ֻ��һ�����˻�
%             uav(coalition(1)).condition = 2;    %���˻���Ϊ����״̬
%             uav(coalition(1)).resource = uav(coalition(1)).resource - targetResourceRequired;
%         else
%            compareResource = zeros(1,resourceKindNum);     
%            for j=1:resourceKindNum
%                compareResource(j) = (resource_sum(j)-targetResourceRequired(j))/coalitionNum;
%            end
%            NckNum = zeros(1,resourceKindNum);        %ͳ�Ƹ���Nck
%            NckResource = zeros(1,resourceKindNum);   %ͳ��ck�е�����Դ
%            for k=1:resourceKindNum  
%                for n=1:coalitionNum
%                    if uav(coalition(n)).resource(k)>=compareResource(k)
%                        NckNum(k) = NckNum(k)+1;
%                        NckResource(k) = NckResource(k) + uav(coalition(n)).resource(k);
%                    end
%                end
%            end
%            for x=1:coalitionNum                        %����������Դ��
%                uav(coalition(x)).condition = 2;    %���˻���Ϊ����״̬
%                for y=1:resourceKindNum
%                    if uav(coalition(x)).resource(y)>=compareResource(y)
%                       uav(coalition(x)).resource(y) = (NckResource(y)-targetResourceRequired(y))/NckNum(y);
%                    end  
%                end
%            end
%         end
        
        for i=1:coalitionNum
            uav(coalition(i)).condition = 2;    %���˻���Ϊ����״̬
            %uav����Դ���ģ�����������
            for k=1:length(resource_sum)
                uav(coalition(i)).resource(k) = uav(coalition(i)).resource(k)-((uav(coalition(i)).resource(k))/resource_sum(k))*target(attack_target).resource(k);
            end        
        end
        target(attack_target).visit = 1;   %Ŀ��״̬��1��ʾ�ѱ�����   
        %fprintf('Ŀ�� %d ������\n',attack_target);
    end
    %ÿ��uav��һ��
    for iUav=1:length(uav)
        [uav(iUav),target] = move_energy(uav(iUav),target,dt,l,b);
    end

end

totalEnergyConsume = 0;                 %ͳ���������˻����ܺ�
for iUav = 1:length(uav)
    totalEnergyConsume = totalEnergyConsume + uav(iUav).energyConsume;
end

energyComsume = totalEnergyConsume;
missionTime = t;

% if t>=1000
%     flag=0;
% else
%     flag=1;
% end
    %�ж�Ŀ���Ƿ�ȫ����ִ�У���ֹ��������
    cou=0;
    for i= 1:numTarget
        cou = cou+ target(i).isAttacked;
    end
    if cou== numTarget %�������
        flag=1;
    else
        flag=0;        %����δ���
    end
%     zzuav=uav;
%     zztarget=target;
%plotscene3(uav,target,l,b);
end

