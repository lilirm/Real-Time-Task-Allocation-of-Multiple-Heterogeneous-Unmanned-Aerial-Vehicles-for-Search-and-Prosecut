function [uav,target] = path_plan2(attack_target,coalition,uav,target,l)  %attack_taregt/coalitionΪ��� added 2020/5/28
%��ѡ������С�ܺ����ˣ������ͬʱ����ʱ�䣬�ڹ滮·��

can_num = length(coalition);
coalition_cost = zeros(1,can_num);
for i = 1:can_num
    coalition_cost(i) = compute_EAT(uav(coalition(i)),target(attack_target).location,uav(coalition(i)).turnRadius);
end
[cost,pos] = max(coalition_cost);   %��ȡ���ʱ�估���ʱ�����˻�  
maxUavId = coalition(pos); 
[uav,target] = path_plan1(attack_target,coalition,cost,uav,target,l,maxUavId);

end


