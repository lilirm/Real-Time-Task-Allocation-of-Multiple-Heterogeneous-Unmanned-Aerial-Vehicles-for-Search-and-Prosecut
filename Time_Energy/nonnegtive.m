function [v] = nonnegtive(r)
%������r��ɷǸ���
v = zeros(1,length(r));
for iElement = 1:length(r)
    if r(iElement)>0
        v(iElement) = r(iElement);
    end
end

end

