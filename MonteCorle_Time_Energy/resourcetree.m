function [coalitionMembers,coalitionResources,coalitionCost] = resourcetree(coalitionMembers,coalitionResources,coalitionCost,targetResource)
%构建一颗资源树，选取最少个数联盟
nUav=length(coalitionMembers);
for i=1:nUav
    uav(i).id=i;                       %uav(i)是新建的临时存储选择出来的最小联盟
    uav(i).resource=coalitionResources(i,:);
end
flag=0;                 %标志是否换层
temp=zeros(1,nUav);        %标志哪些节点可以插入
ptemp=[];               %全局父节点
btemp=[];              %全局左兄弟节点
active=0;              %目前在哪个节点上添加新节点，即父节点，active改变，则temp全变为0
first=0;               %记录每一层的第一个节点
%p=[];
target_res=targetResource;
disp("目标需求资源：");
disp(target_res);
j=1;
while j<50000             %20是插入的最大节点个数
    if j==1            %第一层
        tree(j).lbrother=btemp;
        tree(j).parent=ptemp;
        tree(j).data=nUav;
        tree(j).resource=uav(nUav).resource;
        tree(j).rbrother=-1;    %便于变换active的值
        ptemp=[tree(j).parent j];   %.........................
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
            %第一个0元素所在位置即为插入的节点
            pos=find(temp==0);
            if isempty(pos)==0
                tree(j).data=pos(1);
                tree(j).resource=uav(pos(1)).resource+tree(active).resource; %总资源=自己的资源+父节点的资源
                temp(pos(1))=1;
                btemp=[btemp pos(1)];
            end
        else            %非换层后第一个节点
           pos=find(temp==0);
           if isempty(pos)==0
               tree(j).lbrother=btemp;
               tree(j).parent=ptemp;
               tree(j).data=pos(1);
               tree(j).resource=uav(pos(1)).resource+tree(active).resource; %总资源=自己的资源+父节点的资源
               tree(j-1).rbrother=j;
               temp(pos(1))=1;
               btemp=[btemp pos(1)];
           else      %最后一个节点
               temp(:)=0;
               if tree(active).rbrother==-1     %真正的最后一个节点
                   tree(j-1).rbrother=-1;
                   active=first;
                   flag=1;
                   j=j-1;
               else
                   %tree(j-1).rbrother=j;
                   active=tree(active).rbrother;
                   j=j-1;
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
%     fprintf("j= %d \n",j);
%     disp("tree(j).resource=");
%     disp(tree(j).resource);
%     if isempty(tree(j).resource)
%         j=j+1;
%         continue;
%     end
    if (tree(j).resource-target_res)>=0    %满足目标资源需求,输出选中的节点，结束
        fprintf("大于0进入了判断，j= %d \n",j);
        p=[tree(j).data];
        if isempty(tree(j).parent)==0     %祖父节点不为空时，整合祖父节点
            for k=1:size(tree(j).parent,2)
               p=[p tree(tree(j).parent(k)).data]; 
            end
        end
        % disp(p);
        break;
    end
    j=j+1;
end

disp("所选联盟：");
disp(p);

coalitionM = [];
coalitionR = [];
coalitionC = [];
for i=1:size(p,2)
    coalitionM = [coalitionM coalitionMembers(p(i))];
    coalitionR = [coalitionR ; coalitionResources(p(i),:)];
    coalitionC = [coalitionC coalitionCost(p(i))];
end
coalitionMembers = coalitionM;
coalitionResources = coalitionR;
coalitionCost = coalitionC;

end

