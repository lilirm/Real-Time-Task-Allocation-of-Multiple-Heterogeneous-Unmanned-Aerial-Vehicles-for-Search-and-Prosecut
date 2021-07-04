function [coalitionMembers,cost,maxUavId,uav] = formcoalition4(uav,target,attack_target,target_candidate)
%uav�������˻���target����Ŀ�꣬attack_target������Ŀ��id��target_candidate��ѡ���˻�id��costΪ������������
%�践��uav����Ϊ��formcoalition4�ж����˻�ӵ�е���Դ���������¼���
%ʵ��resource welfare based task allocation�㷨
%��1����ѡ��size��С�Ŀ�������
%��2��ѡȡ����������Ŀ�꺯��ֵ��С������

%1��ѡȡsize��С�Ŀ�������
can_num = length(target_candidate);
targetResourceRequired = target(attack_target).resource;
resourceNum = size(targetResourceRequired,2);   %��Դ������
eligibleCoalition = [];
for i = 1:can_num
    tempCoalition = nchoosek(target_candidate,i);
    for j=1:size(tempCoalition,1)        %j��ʾÿһ�к�ѡ������
        temp = tempCoalition(j,:);
        resource = zeros(1,resourceNum);
        for k=1:i                        %k��ʾÿһ�����˵�����
            resource = resource + uav(temp(k)).resource;
        end
        if resource - targetResourceRequired >=0
            eligibleCoalition = [eligibleCoalition ; temp];
        end
    end
    if isempty(eligibleCoalition)==0
        break;
    end
end

%2����eligibleCoalition��ѡȡĿ�꺯��ֵ��С������
% if isempty(eligibleCoalition)==1       %Ϊ��  ��������Ϊ�գ���Ϊformcoalition4�ڱ�����֮ǰ�Ѿ��������жϣ�
%     
% else
   groupNum = size(eligibleCoalition,1);           %����
   coalitionResourceWelfare = zeros(groupNum,1);   %��¼ÿһ���Ŀ�꺯��ֵ
   %(1)����ÿһ����Դ��ʣ��  
   num = size(eligibleCoalition,2);                %ÿһ�����˳�Ա����
   count = 1;
   first = 0;
   for row=1:groupNum
       temp1 = eligibleCoalition(row,:);           %�ó�һ������
       temp1resource = zeros(1,resourceNum);
       first = count;   %��¼�����һ��Ԫ�ص�λ��
       for i=1:num
           temp1resource = temp1resource + uav(temp1(i)).resource;  %��������Դ
           tempUav(count).resource = uav(temp1(i)).resource;
           count=count+1;
       end
       compareResource = zeros(1,resourceNum);     
       for j=1:resourceNum
           compareResource(j) = (temp1resource(j)-targetResourceRequired(j))/num;
       end
       NckNum = zeros(1,resourceNum);        %ͳ�Ƹ���Nck
       NckResource = zeros(1,resourceNum);   %ͳ��ck�е�����Դ
       finalResource = zeros(1,resourceNum); %ͳ��������Դ��ÿһ����Դ������
       for k=1:resourceNum  
           for t=1:num
               if uav(temp1(t)).resource(k)>=compareResource(k)
                   NckNum(k) = NckNum(k)+1;
                   NckResource(k) = NckResource(k) + uav(temp1(t)).resource(k);
               end
           end
       end
       for x=1:num                        %����������Դ��
           for y=1:resourceNum 
               if uav(temp1(x)).resource(y)>=compareResource(y)
                  tempUav(first).resource(y) = (NckResource(y)-targetResourceRequired(y))/NckNum(y);
               end
               finalResource(y) = finalResource(y) + tempUav(first).resource(y);   
           end
           first = first+1;
       end
       funcValue = 0;
       for z=1:resourceNum
           funcValue = funcValue + exp(finalResource(z)/num);            %(2)����ÿһ����Դ��resource welfare
       end
       coalitionResourceWelfare(row) = (1/resourceNum)*funcValue;        %(3)����Ŀ�꺯��
   end
   [~,pos] = max(coalitionResourceWelfare);
   coalitionMembers = eligibleCoalition(pos,:);   %��ѡ�е�����
   for i=1:num                                    %�������˻���Դ
       uav(coalitionMembers(i)).resource = tempUav((pos-1)*num+i).resource;
   end
   
   coalitionCost = zeros(1,num);
   for i = 1:num
       coalitionCost(i) = compute_EAT(uav(coalitionMembers(i)),target(attack_target).location,uav(coalitionMembers(i)).turnRadius);
   end
   [cost,pos1] = max(coalitionCost);            %��ȡ���ʱ�估���ʱ�����˻�id  
   maxUavId = coalitionMembers(pos1);

end

