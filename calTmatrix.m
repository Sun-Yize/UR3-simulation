% 定义Ti_i-1表达式
function [T] = calTmatrix(alpha,a,d,t)
T=[cos(t) -sin(t)*cosd(alpha) sin(t)*sind(alpha) a*cos(t);
    sin(t) cos(t)*cosd(alpha) -cos(t)*sind(alpha) a*sin(t);
    0 sind(alpha) cosd(alpha) d;
    0 0 0 1];
end
