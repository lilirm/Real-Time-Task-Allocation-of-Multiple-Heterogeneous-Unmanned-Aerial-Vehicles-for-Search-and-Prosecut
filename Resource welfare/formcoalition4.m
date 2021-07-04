function [coalitionMembers,cost,maxUavId,uav] = formcoalition4(uav,target,attack_target,target_candidate)
%uav所有无人机，target所有目标，attack_target被攻击目标id，target_candidate候选无人机id，cost为联盟中最大代价
%需返回uav，因为在formcoalition4中对无人机拥有的资源进行了重新计算
%实现resource welfare based task allocation算法
%（1）先选出size最小的可行联盟
%（2）选取可行联盟中目标函数值最小的联盟

%1、选取size最小的可行联盟
can_num = length(target_candidate);
targetResourceRequired = target(attack_target).resource;
resourceNum = size(targetResourceRequired,2);   %资源种类数
eligibleCoalition = [];
for i = 1:can_num
    tempCoalition = nchoosek(target_candidate,i);
    for j=1:size(tempCoalition,1)        %j表示每一行候选的联盟
        temp = tempCoalition(j,:);
        resource = zeros(1,resourceNum);
        for k=1:i                        %k表示每一行联盟的列数
            resource = resource + uav(temp(k)).resource;
        end
        if resource - targetResourceRequired >=0
            eligibleCoalition = [eligibleCoalition ; temp];
        end
    end
    if isempty(eligibleCoalition)==0
        break;
    end
end

%2、从eligibleCoalition中选取目标函数值最小的联盟
% if isempty(eligibleCoalition)==1       %为空  （不可能为空，因为formcoalition4在被调用之前已经进行了判断）
%     
% else
   groupNum = size(eligibleCoalition,1);           %组数
   coalitionResourceWelfare = zeros(groupNum,1);   %记录每一组的目标函数值
   %(1)计算每一种资源的剩余  
   num = size(eligibleCoalition,2);                %每一组联盟成员个数
   count = 1;
   first = 0;
   for row=1:groupNum
       temp1 = eligibleCoalition(row,:);           %拿出一组联盟
       temp1resource = zeros(1,resourceNum);
       first = count;   %记录此组第一个元素的位置
       for i=1:num
           temp1resource = temp1resource + uav(temp1(i)).resource;  %组内总资源
           tempUav(count).resource = uav(temp1(i)).resource;
           count=count+1;
       end
       compareResource = zeros(1,resourceNum);     
       for j=1:resourceNum
           compareResource(j) = (temp1resource(j)-targetResourceRequired(j))/num;
       end
       NckNum = zeros(1,resourceNum);        %统计个数Nck
       NckResource = zeros(1,resourceNum);   %统计ck中的总资源
       finalResource = zeros(1,resourceNum); %统计消耗资源后每一种资源的总数
       for k=1:resourceNum  
           for t=1:num
               if uav(temp1(t)).resource(k)>=compareResource(k)
                   NckNum(k) = NckNum(k)+1;
                   NckResource(k) = NckResource(k) + uav(temp1(t)).resource(k);
               end
           end
       end
       for x=1:num                        %重新设置资源数
           for y=1:resourceNum 
               if uav(temp1(x)).resource(y)>=compareResource(y)
                  tempUav(first).resource(y) = (NckResource(y)-targetResourceRequired(y))/NckNum(y);
               end
               finalResource(y) = finalResource(y) + tempUav(first).resource(y);   
           end
           first = first+1;
       end
       funcValue = 0;
       for z=1:resourceNum
           funcValue = funcValue + exp(finalResource(z)/num);            %(2)计算每一种资源的resource welfare
       end
       coalitionResourceWelfare(row) = (1/resourceNum)*funcValue;        %(3)计算目标函数
   end
   [~,pos] = max(coalitionResourceWelfare);
   coalitionMembers = eligibleCoalition(pos,:);   %被选中的联盟
   for i=1:num                                    %更新无人机资源
       uav(coalitionMembers(i)).resource = tempUav((pos-1)*num+i).resource;
   end
   
   coalitionCost = zeros(1,num);
   for i = 1:num
       coalitionCost(i) = compute_EAT(uav(coalitionMembers(i)),target(attack_target).location,uav(coalitionMembers(i)).turnRadius);
   end
   [cost,pos1] = max(coalitionCost);            %获取最大时间及最大时间无人机id  
   maxUavId = coalitionMembers(pos1);

end

