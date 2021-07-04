function [radius] =find_radius2(uav,target,arrivalTime,l)  %uav/target是特定无人机与目标，arrivalTime为联盟中最大EAT
%固定时间内无人机从当前点到目标点所需转弯半径
%调整uav的转弯半径，使其同时到达，穷举

targetLocation = target.location;
turnRadius = uav.turnRadius;
time = dubins_EAT(uav,targetLocation,turnRadius);

while time<arrivalTime
    turnRadius = turnRadius + 0.1;        %穷举试值，找半径
    time = dubins_EAT(uav,targetLocation,turnRadius);
end
radius = turnRadius;
end






