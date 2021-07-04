function [v] = nonnegtive(r)
%把向量r变成非负的
v = zeros(1,length(r));
for iElement = 1:length(r)
    if r(iElement)>0
        v(iElement) = r(iElement);
    end
end

end

