function [hudu,direction] = border_hudu(c,position,phi,theta,R,temp,type,border)
%计算旋转的方向和弧度大小
vec1 = position - c;
vec2 = [cos(phi) sin(phi)];
direction = sign(vec1(1)*vec2(2) - vec1(2)*vec2(1));
if direction ==1
    %1是逆时针，-1顺时针
    theta = pi-theta;
    temp = border(mod(type,2)+1,2) - border(mod(type,2)+1,1) - temp;
end
temp1 = 2*theta*(sign1(temp - 2*R*sin(theta)) + 1)/2;
temp2 = theta + pi - asin(sat(((temp - R*sin(theta))/R)));
temp3 = (sign2(2*R*sin(theta) - temp) + 1)/2;
hudu = temp1 + temp2 *temp3;
end

function x = sign1(x)
if x>=0
    x = 1;
else
    x = -1;
end
end

function x = sign2(x)
if x>0
    x = 1;
else
    x = -1;
end
end

function x = sat(x)
if x>1
    x = 1;
elseif x<-1
    x = -1;
end
end

