function [candidate] = coalitionCandidate(UAV_task,uav,target,targetId)   %�������˺�ѡ��
%uav�������˻���targetId����쵽��Ŀ��id,target����Ŀ��
flag=0;
candidate = [];
targetRes = target(targetId).resource;
    for iUav = 1:length(uav)
        if uav(iUav).condition ~= 2                 %uav������ִ������״̬����ӵ��Ŀ��������Դ
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
    for cp = 1:length(UAV_task)        %ȥ�����е�leader
        temp = find(candidate==UAV_task(cp).id);
        if ~isempty(temp)
            candidate(temp(1)) = [];
        end
    end
end

