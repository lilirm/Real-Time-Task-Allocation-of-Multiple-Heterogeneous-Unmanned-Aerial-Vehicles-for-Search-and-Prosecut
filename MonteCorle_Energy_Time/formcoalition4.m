function [coalitionMembers] = formcoalition4(uav,target,attack_target,target_candidate) 
% 0 1 整数规划选取能耗最小联盟
%uav所有无人机，target所有目标，attack_target被攻击目标id，target_candidate候选无人机id
disp("联盟候选者：");
disp(target_candidate);

can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = compute_energy(uav(target_candidate(i)),target(attack_target).location);  %计算每个候选者到目标的能耗
end

%使用intliprog函数选取能耗和最小联盟
f = target_candidate_cost;
%构造不等式约束（只能构造<=）
candidateResource = [];
for i = 1:can_num
    candidateResource = [candidateResource ; uav(target_candidate(i)).resource];
end
intcon = 1:can_num;
A=(candidateResource.*(-1))';
b=(target(attack_target).resource.*(-1))';
lb=zeros(can_num,1);
ub=ones(can_num,1);
[x,val,exitflag] = intlinprog(f,intcon,A,b,[],[],lb,ub);

coalitionMembers = [];
for i = 1:can_num
    if x(i) ~=0
       coalitionMembers = [coalitionMembers target_candidate(i)]; 
    end
end
disp("所选联盟：");
disp(x);
disp(coalitionMembers);
end


