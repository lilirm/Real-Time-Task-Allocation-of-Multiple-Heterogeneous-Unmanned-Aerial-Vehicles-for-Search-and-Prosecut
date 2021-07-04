function [detect_target] = searchtarget(uav,target)  %uav�������˻���target����Ŀ��

Rsen = uav.detectRadius;       % sensor range
x = uav.position(1);
y = uav.position(2);

detect_target = [];                 %��ʱ���ض�uav���ֵ�Ŀ��
for iTarget = 1:length(target)
    if target(iTarget).visit == 0   %û���������Ŀ��
        dis = sqrt((target(iTarget).location(1)-x)^2+(target(iTarget).location(2)-y)^2);
        if dis <= Rsen
            detect_target = [detect_target iTarget];
        end
    end
end

end

