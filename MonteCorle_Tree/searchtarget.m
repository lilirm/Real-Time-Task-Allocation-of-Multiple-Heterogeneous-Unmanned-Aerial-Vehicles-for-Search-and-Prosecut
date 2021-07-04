function [detect_target] = searchtarget(uav,target)  %uav单个无人机，target所有目标

Rsen = uav.detectRadius;       % sensor range
x = uav.position(1);
y = uav.position(2);

detect_target = [];                 %本时刻特定uav发现的目标
for iTarget = 1:length(target)
    if target(iTarget).visit == 0   %没被分配过的目标
        dis = sqrt((target(iTarget).location(1)-x)^2+(target(iTarget).location(2)-y)^2);
        if dis <= Rsen
            detect_target = [detect_target iTarget];
        end
    end
end

end

