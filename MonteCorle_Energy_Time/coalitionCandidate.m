function [candidate] = coalitionCandidate(UAV_task,uav,target,targetId)   %构建联盟候选集
%uav所有无人机，targetId被侦察到的目标id,target所有目标
flag=0;
candidate = [];
targetRes = target(targetId).resource;
    for iUav = 1:length(uav)
        if uav(iUav).condition ~= 2                 %uav不处于执行任务状态并且拥有目标所需资源
            uavRes=uav(iUav).resource;
            for res=1:length(uavRes)
                if targetRes(res)~=0 && uavRes(res)~=0
                    flag=1;
                    break;
                end
            end
            if flag == 1
                candidate = [candidate iUav];                              
           end
           flag=0; 
        end
    end
    for cp = 1:length(UAV_task)        %去除所有的leader
        temp = find(candidate==UAV_task(cp).id);
        if ~isempty(temp)
            candidate(temp(1)) = [];
        end
    end
end

