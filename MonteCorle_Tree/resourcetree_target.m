function [coalitionM,coalitionC] = resourcetree_target(coalitionMembers,coalitionCost,uav,target,attack_target)
%以目标为根，构建一颗资源树，选取最小目标函数联盟，同时兼顾联盟size最小
disp("要执行的目标：");
disp(attack_target);
disp("目标资源需求：");
disp(target(attack_target).resource);
disp("候选无人机：");
disp(coalitionMembers);
finalCoalition = [];
xy=[];
nUav=length(coalitionMembers);
totalres = [];
for i=1:nUav
    uavTemp(i).id=i;                       %uav(i)是新建的临时存储选择出来的最小联盟
    uavTemp(i).resource=uav(coalitionMembers(i)).resource;
     totalres = [totalres;uavTemp(i).resource];
end
disp("候选总资源：");
disp(sum(totalres));
flag=0;                    %标志是否换层
flag2=0;                   %标志是否到达满足目标资源需求的层
temp=zeros(1,nUav);        %标志哪些节点可以插入
ptemp=[];                  %全局父节点
btemp=[];                  %全局左兄弟节点
active=0;                  %目前在哪个节点上添加新节点，即父节点，active改变，则temp全变为0
first=0;                   %记录每一层的第一个节点
nolastone=0;
%p=[];
target_res=target(attack_target).resource;
j=1;
while j<20000          %20是插入的最大节点个数
    if j==1            %第一层放目标点target
%       tree(j).lbrother=btemp;
%       tree(j).parent=ptemp;
%       tree(j).data=nUav;
        tree(j).resource=target_res;
        tree(j).rbrother=-1;    %便于变换active的值
        %ptemp=[tree(j).parent j];   %.........................
        %temp(1,5)=1;
        %temp(1,1)=1;
        flag=1;
        active=1;
    else        
        if flag==1        %换层后第一个节点
            flag=0;
            first=j;
            btemp=[];
            tree(j).lbrother=btemp;
            tree(j).parent=ptemp;
            %整合父节点
            if active ~= 1      %除去根节点
                p=[tree(active).data  tree(active).lbrother];    %父节点及其左兄弟节点
                if isempty(tree(active).parent)==0     %祖父节点不为空时，整合祖父节点及其左兄弟
                    for k=1:size(tree(active).parent,2)
                       p=[p tree(tree(active).parent(k)).data tree(tree(active).parent(k)).lbrother]; 
                    end
                end
            
            %p=[tree(active).data tree(active).parent tree(active).lbrother];
                for k=1:size(p,2)
                    temp(p(k))=1;
                end
            end
            %第一个0元素所在位置即为插入的节点
            pos=find(temp==0);
            if isempty(pos)==0
                tree(j).data=pos(1);
                tree(j).resource=tree(active).resource-uavTemp(pos(1)).resource; %总资源=父节点的资源-本身拥有的资源
                temp(pos(1))=1;
                btemp=[btemp pos(1)];
            end
        else            %非换层后第一个节点
           pos=find(temp==0);
           if isempty(pos)==0
               tree(j).lbrother=btemp;
               tree(j).parent=ptemp;
               tree(j).data=pos(1);
               tree(j).resource=tree(active).resource-uavTemp(pos(1)).resource; %总资源=父节点的资源-本身拥有的资源
               tree(j-1).rbrother=j;
               temp(pos(1))=1;
               btemp=[btemp pos(1)];
           else      %最后一个节点
               temp(:)=0;
               if tree(active).rbrother==-1     %真正的最后一个节点
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
                   nolastone=1;                                      %解决父节点在同一层跳转时错位问题第（j-1）个树节点重复计算，算入finalCoalition中
                   %整合父节点
                   p=[tree(active).data  tree(active).lbrother];     %父节点及其左兄弟节点
                   if isempty(tree(active).parent)==0                %祖父节点不为空时，整合祖父节点及其左兄弟
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
    if tree(j).resource <= 0    %满足目标资源需求,则只搜索到此层，记录下此层中满足目标资源需求的联盟
        if nolastone==1
            j=j+1;
            nolastone=0;
            continue;
        end 
        xx=[j];                           %记录对应的树节点
        p=[tree(j).data];
        if isempty(tree(j).parent)==0     %祖父节点不为空时，整合祖父节点
            xx=[xx tree(j).parent];
            for k=1:size(tree(j).parent,2)
               p=[p tree(tree(j).parent(k)).data]; 
            end
        end
        % disp(p);
        finalCoalition = [finalCoalition;p];
        xy=[xy;xx];
        flag2 = 1;  %到达满足目标的层
        %break;
    end
    j=j+1;
    nolastone=0;
end
fprintf("最终j: %d \n",j);

%[coalition] = compute_target_fun(finalCoalition,coalitionMembers,uav,target(attack_target).location);
[coalition] = compute_target_fun2(finalCoalition,coalitionMembers,coalitionCost,uav,target(attack_target).location);
coalitionM = [];    %最终选出的联盟
coalitionC = [];    %对应的时间
for i=1:length(coalition)
    coalitionM = [coalitionM coalitionMembers(coalition(i))];
    coalitionC = [coalitionC coalitionCost(coalition(i))];
end

disp("最终选择的联盟：");
disp(coalitionM);
% disp("对应的树节点：");
% disp(xy);

end

function [coalition] = compute_target_fun(finalCoalition,coalitionMembers,uav,targetLocation)  
%finalCoalition中的每一行为一个满足目标资源需求的联盟，用序号表示
%目标函数：max(EAT)+sum(E),其中max(EAT)转化为max(E),问题：但是max（EAT）对应的uav不一定是max(E)对应的
    %disp(finalCoalition);
    coalitionCost = zeros(1,size(coalitionMembers,2));
    groupNum = size(finalCoalition,1);
    groupFunValues = zeros(groupNum,1);
    for i=1:groupNum                %计算每一行的目标值
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
        groupFunValues(i) = sum(tempValue) + max(tempValue);    %计算目标函数值
    end
    [~,pos] = min(groupFunValues);
    coalition = finalCoalition(pos,:);
end

function [coalition] = compute_target_fun2(finalCoalition,coalitionMembers,coalitionCost,uav,targetLocation)  
%finalCoalition中的每一行为一个满足目标资源需求的联盟，用序号表示
%变化目标函数：max(EAT)+sum(E),其中max(EAT)转化为其对应的无人机的能耗
%     disp("候选联盟：");
%     disp(finalCoalition);
    coalitionC = zeros(1,size(coalitionMembers,2));
    groupNum = size(finalCoalition,1);      %可行的联盟组合个数
    groupFunValues = zeros(groupNum,1);     %每一组的目标函数值
    for i=1:groupNum                        %计算每一行的目标值
        temp = finalCoalition(i,:);         %拿出一行可行的联盟组合
        tempValue = zeros(1,size(temp,2));  %存放组合中每个无人机的能耗
        for j=1:size(temp,2)                %计算组合中每个无人机的能耗
            if coalitionC(temp(j))~=0
                tempValue(j) = coalitionC(temp(j));
            else
                tempValue(j) = compute_energy(uav(coalitionMembers(temp(j))),targetLocation);
                coalitionC(temp(j)) = tempValue(j);
            end
        end
        tempCost = [];              %记录组合中每个无人机的时间EAT
        for k=1:size(temp,2)
            tempCost = [tempCost coalitionCost(temp(k))];
        end
        [~,pos] = max(tempCost);    %找出EAT最大的无人机
        groupFunValues(i) = 0.7.*tempValue(pos) + 0.3.*sum(tempValue);    %计算目标函数值:max(EAT)+sum(E)，如果需要加权重，则在此行代码处添加
    end
    [~,pos] = min(groupFunValues);
    coalition = finalCoalition(pos,:);
end

