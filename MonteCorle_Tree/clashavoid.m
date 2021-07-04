function [UAV_task] = clashavoid(find_targets,uav,target)  %解决死锁情况
% 1、单无人机侦察到多个目标
% 2、多无人机侦察到同一目标
% 3、单无人机收到多联盟请求  （在formcoatiion中解决）
% 4、多无人机侦察到多目标     (隐含在问题1、2中)
UAV_task = [];
for ft = 1:length(find_targets)
  flag = 0;
  uavId = find_targets(ft).id;      %uav
  find_target = find_targets(ft).detect_target;   %目标集
  distance = zeros(1,size(find_target,2));     %无人机uavId到各目标点的距离
  for ds = 1:length(find_target)
      distance(ds) = dubins_len(uav(uavId),target(find_target(ds)).location,uav(uavId).turnRadius);
  end
  
  if length(find_target)>1
      [distance,sortOrder] = sort(distance);   %按照距离远近排序，从近到远
      find_target = find_target(sortOrder);
      find_targets(ft).detect_target = find_target;
      find_targets(ft).distance = distance;
      for t = 1:size(find_target,2)    %分配目标
          %if uav(uavId).resource-target(find_target(t)).resource >=0 && uav(uavId).condition~=2
          if sum(nonnegtive(target(find_target(t)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
              UAV_task(ft).id = uavId;
              UAV_task(ft).target = find_target(t);
              UAV_task(ft).needcoalition = 1;   %已满足目标资源需求，无需分配联盟,0表示需要，1表示不需要
              flag = 1;
              break
          end
      end
      if flag == 0   %没找到满足资源需求的目标
        UAV_task(ft).id = uavId;
        UAV_task(ft).target = find_target(1);
        UAV_task(ft).needcoalition = 0;
      end
  else   %只侦察到一个目标，直接分配，无需排序
        find_targets(ft).distance = distance;
        UAV_task(ft).id = uavId;
        UAV_task(ft).target = find_target(1);
        %if uav(uavId).resource-target(find_target(1)).resource >=0  && uav(uavId).condition~=2
        if sum(nonnegtive(target(find_target(1)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
            UAV_task(ft).needcoalition = 1;
        else
            UAV_task(ft).needcoalition = 0;
        end
  end
end    %以上部分解决了问题1：单uav侦察到多目标 
%以下部分解决问题2
% final_target = [];
% for ut = 1:length(UAV_task)
%     final_target = [final_target UAV_task(ut).target];
% end
final_target = final(UAV_task);
while length(final_target)-length(unique(final_target)) >0  % >0表示有重复值，=0表示无重复目标
    for k=1:length(final_target)
       repeat = find(final_target==final_target(k)); 
       len = length(repeat);
       if len>1   %表示有重复的目标
           % 1、多无人机对同一目标，选择最优无人机
           % 2、被淘汰的无人机重新分配目标
           tempdis = zeros(1,len);
           tempcoa = zeros(1,len);
           
           for j=1:len  %拿出重复的无人机
               tempdis(j) = find_targets(repeat(j)).distance(find(find_targets(repeat(j)).detect_target==final_target(k)));
               tempcoa(j) = UAV_task(repeat(j)).needcoalition;
           end
           if sum(tempcoa) == 0 %全都需要，选择最近的
               [~,pos] = min(tempdis);
           elseif sum(tempcoa) == 1
               pos = find(tempcoa==1);
           else
               mindis = inf;
               for j=1:len   %选择最近的同时不需要组联盟的无人机
                   if tempcoa(j)==1 && (tempdis(j)<mindis)
                       mindis = tempdis(j);
                       pos = j;
                   end
               end
           end
           %pos为repeat中选择出的最优无人机的位置
           [find_targets,UAV_task] = changeTarget(find_targets,UAV_task,repeat,pos,uav,target);
           break
       end
    end
    final_target = final(UAV_task);
end

end

function [final_target] = final(UAV_task)              %最终被分配的目标
final_target = [];
for ut = 1:length(UAV_task)
    final_target = [final_target UAV_task(ut).target];
end
end

function [find_targets,UAV_task] = changeTarget(find_targets,UAV_task,repeat,pos,uav,target)
for i=1:length(repeat)
    flag = 0;
    if i~=pos
        u = find_targets(repeat(i));
        coor = find(u.detect_target==UAV_task(repeat(pos)).target);
        find_targets(repeat(i)).detect_target(coor) = [];
        find_targets(repeat(i)).distance(coor) = [];
        if isempty(find_targets(repeat(i)).detect_target)
            if repeat(i)<=length(UAV_task)
               UAV_task(repeat(i)).target = [];
            end
            continue
        end
        temp_target = find_targets(repeat(i)).detect_target;
        uavId = find_targets(repeat(i)).id;
        if length(temp_target)>1
          for t = 1:size(temp_target,2)    %分配目标
              %if uav(uavId).resource-target(temp_target(t)).resource >=0 && uav(uavId).condition~=2
              if sum(nonnegtive(target(temp_target(t)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
                  UAV_task(repeat(i)).target = temp_target(t);
                  UAV_task(repeat(i)).needcoalition = 1;   %已满足目标资源需求，无需分配联盟,0表示需要，1表示不需要
                  flag = 1;
                  break
              end
          end
          if flag == 0   %没找到满足资源需求的目标
            UAV_task(repeat(i)).target =temp_target(1);
            UAV_task(repeat(i)).needcoalition = 0;
          end
       else   %只侦察到一个目标，直接分配，无需排序        
            UAV_task(repeat(i)).target = temp_target(1);
            %if uav(uavId).resource-target(temp_target(1)).resource >=0 && uav(uavId).condition~=2
            if sum(nonnegtive(target(temp_target(1)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
                UAV_task(repeat(i)).needcoalition = 1;
            else
                UAV_task(repeat(i)).needcoalition = 0;
            end
       end
    end
end
end
