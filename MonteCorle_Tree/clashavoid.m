function [UAV_task] = clashavoid(find_targets,uav,target)  %����������
% 1�������˻���쵽���Ŀ��
% 2�������˻���쵽ͬһĿ��
% 3�������˻��յ�����������  ����formcoatiion�н����
% 4�������˻���쵽��Ŀ��     (����������1��2��)
UAV_task = [];
for ft = 1:length(find_targets)
  flag = 0;
  uavId = find_targets(ft).id;      %uav
  find_target = find_targets(ft).detect_target;   %Ŀ�꼯
  distance = zeros(1,size(find_target,2));     %���˻�uavId����Ŀ���ľ���
  for ds = 1:length(find_target)
      distance(ds) = dubins_len(uav(uavId),target(find_target(ds)).location,uav(uavId).turnRadius);
  end
  
  if length(find_target)>1
      [distance,sortOrder] = sort(distance);   %���վ���Զ�����򣬴ӽ���Զ
      find_target = find_target(sortOrder);
      find_targets(ft).detect_target = find_target;
      find_targets(ft).distance = distance;
      for t = 1:size(find_target,2)    %����Ŀ��
          %if uav(uavId).resource-target(find_target(t)).resource >=0 && uav(uavId).condition~=2
          if sum(nonnegtive(target(find_target(t)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
              UAV_task(ft).id = uavId;
              UAV_task(ft).target = find_target(t);
              UAV_task(ft).needcoalition = 1;   %������Ŀ����Դ���������������,0��ʾ��Ҫ��1��ʾ����Ҫ
              flag = 1;
              break
          end
      end
      if flag == 0   %û�ҵ�������Դ�����Ŀ��
        UAV_task(ft).id = uavId;
        UAV_task(ft).target = find_target(1);
        UAV_task(ft).needcoalition = 0;
      end
  else   %ֻ��쵽һ��Ŀ�ֱ꣬�ӷ��䣬��������
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
end    %���ϲ��ֽ��������1����uav��쵽��Ŀ�� 
%���²��ֽ������2
% final_target = [];
% for ut = 1:length(UAV_task)
%     final_target = [final_target UAV_task(ut).target];
% end
final_target = final(UAV_task);
while length(final_target)-length(unique(final_target)) >0  % >0��ʾ���ظ�ֵ��=0��ʾ���ظ�Ŀ��
    for k=1:length(final_target)
       repeat = find(final_target==final_target(k)); 
       len = length(repeat);
       if len>1   %��ʾ���ظ���Ŀ��
           % 1�������˻���ͬһĿ�꣬ѡ���������˻�
           % 2������̭�����˻����·���Ŀ��
           tempdis = zeros(1,len);
           tempcoa = zeros(1,len);
           
           for j=1:len  %�ó��ظ������˻�
               tempdis(j) = find_targets(repeat(j)).distance(find(find_targets(repeat(j)).detect_target==final_target(k)));
               tempcoa(j) = UAV_task(repeat(j)).needcoalition;
           end
           if sum(tempcoa) == 0 %ȫ����Ҫ��ѡ�������
               [~,pos] = min(tempdis);
           elseif sum(tempcoa) == 1
               pos = find(tempcoa==1);
           else
               mindis = inf;
               for j=1:len   %ѡ�������ͬʱ����Ҫ�����˵����˻�
                   if tempcoa(j)==1 && (tempdis(j)<mindis)
                       mindis = tempdis(j);
                       pos = j;
                   end
               end
           end
           %posΪrepeat��ѡ������������˻���λ��
           [find_targets,UAV_task] = changeTarget(find_targets,UAV_task,repeat,pos,uav,target);
           break
       end
    end
    final_target = final(UAV_task);
end

end

function [final_target] = final(UAV_task)              %���ձ������Ŀ��
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
          for t = 1:size(temp_target,2)    %����Ŀ��
              %if uav(uavId).resource-target(temp_target(t)).resource >=0 && uav(uavId).condition~=2
              if sum(nonnegtive(target(temp_target(t)).resource-uav(uavId).resource))==0 && uav(uavId).condition~=2
                  UAV_task(repeat(i)).target = temp_target(t);
                  UAV_task(repeat(i)).needcoalition = 1;   %������Ŀ����Դ���������������,0��ʾ��Ҫ��1��ʾ����Ҫ
                  flag = 1;
                  break
              end
          end
          if flag == 0   %û�ҵ�������Դ�����Ŀ��
            UAV_task(repeat(i)).target =temp_target(1);
            UAV_task(repeat(i)).needcoalition = 0;
          end
       else   %ֻ��쵽һ��Ŀ�ֱ꣬�ӷ��䣬��������        
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
