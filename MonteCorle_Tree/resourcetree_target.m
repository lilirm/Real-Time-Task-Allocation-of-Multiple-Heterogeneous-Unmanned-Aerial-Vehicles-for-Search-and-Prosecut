function [coalitionM,coalitionC] = resourcetree_target(coalitionMembers,coalitionCost,uav,target,attack_target)
%��Ŀ��Ϊ��������һ����Դ����ѡȡ��СĿ�꺯�����ˣ�ͬʱ�������size��С
disp("Ҫִ�е�Ŀ�꣺");
disp(attack_target);
disp("Ŀ����Դ����");
disp(target(attack_target).resource);
disp("��ѡ���˻���");
disp(coalitionMembers);
finalCoalition = [];
xy=[];
nUav=length(coalitionMembers);
totalres = [];
for i=1:nUav
    uavTemp(i).id=i;                       %uav(i)���½�����ʱ�洢ѡ���������С����
    uavTemp(i).resource=uav(coalitionMembers(i)).resource;
     totalres = [totalres;uavTemp(i).resource];
end
disp("��ѡ����Դ��");
disp(sum(totalres));
flag=0;                    %��־�Ƿ񻻲�
flag2=0;                   %��־�Ƿ񵽴�����Ŀ����Դ����Ĳ�
temp=zeros(1,nUav);        %��־��Щ�ڵ���Բ���
ptemp=[];                  %ȫ�ָ��ڵ�
btemp=[];                  %ȫ�����ֵܽڵ�
active=0;                  %Ŀǰ���ĸ��ڵ�������½ڵ㣬�����ڵ㣬active�ı䣬��tempȫ��Ϊ0
first=0;                   %��¼ÿһ��ĵ�һ���ڵ�
nolastone=0;
%p=[];
target_res=target(attack_target).resource;
j=1;
while j<20000          %20�ǲ�������ڵ����
    if j==1            %��һ���Ŀ���target
%       tree(j).lbrother=btemp;
%       tree(j).parent=ptemp;
%       tree(j).data=nUav;
        tree(j).resource=target_res;
        tree(j).rbrother=-1;    %���ڱ任active��ֵ
        %ptemp=[tree(j).parent j];   %.........................
        %temp(1,5)=1;
        %temp(1,1)=1;
        flag=1;
        active=1;
    else        
        if flag==1        %������һ���ڵ�
            flag=0;
            first=j;
            btemp=[];
            tree(j).lbrother=btemp;
            tree(j).parent=ptemp;
            %���ϸ��ڵ�
            if active ~= 1      %��ȥ���ڵ�
                p=[tree(active).data  tree(active).lbrother];    %���ڵ㼰�����ֵܽڵ�
                if isempty(tree(active).parent)==0     %�游�ڵ㲻Ϊ��ʱ�������游�ڵ㼰�����ֵ�
                    for k=1:size(tree(active).parent,2)
                       p=[p tree(tree(active).parent(k)).data tree(tree(active).parent(k)).lbrother]; 
                    end
                end
            
            %p=[tree(active).data tree(active).parent tree(active).lbrother];
                for k=1:size(p,2)
                    temp(p(k))=1;
                end
            end
            %��һ��0Ԫ������λ�ü�Ϊ����Ľڵ�
            pos=find(temp==0);
            if isempty(pos)==0
                tree(j).data=pos(1);
                tree(j).resource=tree(active).resource-uavTemp(pos(1)).resource; %����Դ=���ڵ����Դ-����ӵ�е���Դ
                temp(pos(1))=1;
                btemp=[btemp pos(1)];
            end
        else            %�ǻ�����һ���ڵ�
           pos=find(temp==0);
           if isempty(pos)==0
               tree(j).lbrother=btemp;
               tree(j).parent=ptemp;
               tree(j).data=pos(1);
               tree(j).resource=tree(active).resource-uavTemp(pos(1)).resource; %����Դ=���ڵ����Դ-����ӵ�е���Դ
               tree(j-1).rbrother=j;
               temp(pos(1))=1;
               btemp=[btemp pos(1)];
           else      %���һ���ڵ�
               temp(:)=0;
               if tree(active).rbrother==-1     %���������һ���ڵ�
                   if flag2 == 1
                       break;
                   end
                   tree(j-1).rbrother=-1;
                   active=first;
                   flag=1;
                   j=j-1;
               else
                   %tree(j-1).rbrother=j;
                   active=tree(active).rbrother;
                   j=j-1;
                   nolastone=1;                                      %������ڵ���ͬһ����תʱ��λ����ڣ�j-1�������ڵ��ظ����㣬����finalCoalition��
                   %���ϸ��ڵ�
                   p=[tree(active).data  tree(active).lbrother];     %���ڵ㼰�����ֵܽڵ�
                   if isempty(tree(active).parent)==0                %�游�ڵ㲻Ϊ��ʱ�������游�ڵ㼰�����ֵ�
                       for k=1:size(tree(active).parent,2)
                           p=[p tree(tree(active).parent(k)).data tree(tree(active).parent(k)).lbrother]; 
                       end
                   end
                   for k=1:size(p,2)
                       temp(p(k))=1;
                   end
               end
               %active=first;
               %flag=1;
               %temp(:)=0;
               btemp=[];
               ptemp=[active tree(active).parent];
           end
        end
    end
    if tree(j).resource <= 0    %����Ŀ����Դ����,��ֻ�������˲㣬��¼�´˲�������Ŀ����Դ���������
        if nolastone==1
            j=j+1;
            nolastone=0;
            continue;
        end 
        xx=[j];                           %��¼��Ӧ�����ڵ�
        p=[tree(j).data];
        if isempty(tree(j).parent)==0     %�游�ڵ㲻Ϊ��ʱ�������游�ڵ�
            xx=[xx tree(j).parent];
            for k=1:size(tree(j).parent,2)
               p=[p tree(tree(j).parent(k)).data]; 
            end
        end
        % disp(p);
        finalCoalition = [finalCoalition;p];
        xy=[xy;xx];
        flag2 = 1;  %��������Ŀ��Ĳ�
        %break;
    end
    j=j+1;
    nolastone=0;
end
fprintf("����j: %d \n",j);

%[coalition] = compute_target_fun(finalCoalition,coalitionMembers,uav,target(attack_target).location);
[coalition] = compute_target_fun2(finalCoalition,coalitionMembers,coalitionCost,uav,target(attack_target).location);
coalitionM = [];    %����ѡ��������
coalitionC = [];    %��Ӧ��ʱ��
for i=1:length(coalition)
    coalitionM = [coalitionM coalitionMembers(coalition(i))];
    coalitionC = [coalitionC coalitionCost(coalition(i))];
end

disp("����ѡ������ˣ�");
disp(coalitionM);
% disp("��Ӧ�����ڵ㣺");
% disp(xy);

end

function [coalition] = compute_target_fun(finalCoalition,coalitionMembers,uav,targetLocation)  
%finalCoalition�е�ÿһ��Ϊһ������Ŀ����Դ��������ˣ�����ű�ʾ
%Ŀ�꺯����max(EAT)+sum(E),����max(EAT)ת��Ϊmax(E),���⣺����max��EAT����Ӧ��uav��һ����max(E)��Ӧ��
    %disp(finalCoalition);
    coalitionCost = zeros(1,size(coalitionMembers,2));
    groupNum = size(finalCoalition,1);
    groupFunValues = zeros(groupNum,1);
    for i=1:groupNum                %����ÿһ�е�Ŀ��ֵ
        temp = finalCoalition(i,:);
        tempValue = zeros(1,size(temp,2));
        for j=1:size(temp,2)
            %disp(num2str(uav(coalitionMembers(temp(j))).id));
            if coalitionCost(temp(j))~=0
                tempValue(j) = coalitionCost(temp(j));
            else
                tempValue(j) = compute_energy(uav(coalitionMembers(temp(j))),targetLocation);
                coalitionCost(temp(j)) = tempValue(j);
            end
        end
        groupFunValues(i) = sum(tempValue) + max(tempValue);    %����Ŀ�꺯��ֵ
    end
    [~,pos] = min(groupFunValues);
    coalition = finalCoalition(pos,:);
end

function [coalition] = compute_target_fun2(finalCoalition,coalitionMembers,coalitionCost,uav,targetLocation)  
%finalCoalition�е�ÿһ��Ϊһ������Ŀ����Դ��������ˣ�����ű�ʾ
%�仯Ŀ�꺯����max(EAT)+sum(E),����max(EAT)ת��Ϊ���Ӧ�����˻����ܺ�
%     disp("��ѡ���ˣ�");
%     disp(finalCoalition);
    coalitionC = zeros(1,size(coalitionMembers,2));
    groupNum = size(finalCoalition,1);      %���е�������ϸ���
    groupFunValues = zeros(groupNum,1);     %ÿһ���Ŀ�꺯��ֵ
    for i=1:groupNum                        %����ÿһ�е�Ŀ��ֵ
        temp = finalCoalition(i,:);         %�ó�һ�п��е��������
        tempValue = zeros(1,size(temp,2));  %��������ÿ�����˻����ܺ�
        for j=1:size(temp,2)                %���������ÿ�����˻����ܺ�
            if coalitionC(temp(j))~=0
                tempValue(j) = coalitionC(temp(j));
            else
                tempValue(j) = compute_energy(uav(coalitionMembers(temp(j))),targetLocation);
                coalitionC(temp(j)) = tempValue(j);
            end
        end
        tempCost = [];              %��¼�����ÿ�����˻���ʱ��EAT
        for k=1:size(temp,2)
            tempCost = [tempCost coalitionCost(temp(k))];
        end
        [~,pos] = max(tempCost);    %�ҳ�EAT�������˻�
        groupFunValues(i) = 0.7.*tempValue(pos) + 0.3.*sum(tempValue);    %����Ŀ�꺯��ֵ:max(EAT)+sum(E)�������Ҫ��Ȩ�أ����ڴ��д��봦���
    end
    [~,pos] = min(groupFunValues);
    coalition = finalCoalition(pos,:);
end

