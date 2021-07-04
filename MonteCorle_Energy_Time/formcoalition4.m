function [coalitionMembers] = formcoalition4(uav,target,attack_target,target_candidate) 
% 0 1 �����滮ѡȡ�ܺ���С����
%uav�������˻���target����Ŀ�꣬attack_target������Ŀ��id��target_candidate��ѡ���˻�id
disp("���˺�ѡ�ߣ�");
disp(target_candidate);

can_num = length(target_candidate);
target_candidate_cost = zeros(1,can_num);
for i = 1:can_num
    target_candidate_cost(i) = compute_energy(uav(target_candidate(i)),target(attack_target).location);  %����ÿ����ѡ�ߵ�Ŀ����ܺ�
end

%ʹ��intliprog����ѡȡ�ܺĺ���С����
f = target_candidate_cost;
%���첻��ʽԼ����ֻ�ܹ���<=��
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
disp("��ѡ���ˣ�");
disp(x);
disp(coalitionMembers);
end


