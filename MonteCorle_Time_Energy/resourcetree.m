function [coalitionMembers,coalitionResources,coalitionCost] = resourcetree(coalitionMembers,coalitionResources,coalitionCost,targetResource)
%����һ����Դ����ѡȡ���ٸ�������
nUav=length(coalitionMembers);
for i=1:nUav
    uav(i).id=i;                       %uav(i)���½�����ʱ�洢ѡ���������С����
    uav(i).resource=coalitionResources(i,:);
end
flag=0;                 %��־�Ƿ񻻲�
temp=zeros(1,nUav);        %��־��Щ�ڵ���Բ���
ptemp=[];               %ȫ�ָ��ڵ�
btemp=[];              %ȫ�����ֵܽڵ�
active=0;              %Ŀǰ���ĸ��ڵ�������½ڵ㣬�����ڵ㣬active�ı䣬��tempȫ��Ϊ0
first=0;               %��¼ÿһ��ĵ�һ���ڵ�
%p=[];
target_res=targetResource;
disp("Ŀ��������Դ��");
disp(target_res);
j=1;
while j<50000             %20�ǲ�������ڵ����
    if j==1            %��һ��
        tree(j).lbrother=btemp;
        tree(j).parent=ptemp;
        tree(j).data=nUav;
        tree(j).resource=uav(nUav).resource;
        tree(j).rbrother=-1;    %���ڱ任active��ֵ
        ptemp=[tree(j).parent j];   %.........................
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
            %��һ��0Ԫ������λ�ü�Ϊ����Ľڵ�
            pos=find(temp==0);
            if isempty(pos)==0
                tree(j).data=pos(1);
                tree(j).resource=uav(pos(1)).resource+tree(active).resource; %����Դ=�Լ�����Դ+���ڵ����Դ
                temp(pos(1))=1;
                btemp=[btemp pos(1)];
            end
        else            %�ǻ�����һ���ڵ�
           pos=find(temp==0);
           if isempty(pos)==0
               tree(j).lbrother=btemp;
               tree(j).parent=ptemp;
               tree(j).data=pos(1);
               tree(j).resource=uav(pos(1)).resource+tree(active).resource; %����Դ=�Լ�����Դ+���ڵ����Դ
               tree(j-1).rbrother=j;
               temp(pos(1))=1;
               btemp=[btemp pos(1)];
           else      %���һ���ڵ�
               temp(:)=0;
               if tree(active).rbrother==-1     %���������һ���ڵ�
                   tree(j-1).rbrother=-1;
                   active=first;
                   flag=1;
                   j=j-1;
               else
                   %tree(j-1).rbrother=j;
                   active=tree(active).rbrother;
                   j=j-1;
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
%     fprintf("j= %d \n",j);
%     disp("tree(j).resource=");
%     disp(tree(j).resource);
%     if isempty(tree(j).resource)
%         j=j+1;
%         continue;
%     end
    if (tree(j).resource-target_res)>=0    %����Ŀ����Դ����,���ѡ�еĽڵ㣬����
        fprintf("����0�������жϣ�j= %d \n",j);
        p=[tree(j).data];
        if isempty(tree(j).parent)==0     %�游�ڵ㲻Ϊ��ʱ�������游�ڵ�
            for k=1:size(tree(j).parent,2)
               p=[p tree(tree(j).parent(k)).data]; 
            end
        end
        % disp(p);
        break;
    end
    j=j+1;
end

disp("��ѡ���ˣ�");
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

