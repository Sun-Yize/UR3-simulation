% »­Ô²º¯Êý
function T = drawing_circle(n,r,c,step)
    theta=(0:2*pi/step:2*pi)';
    a=cross(n,[0 1 0]);
    if ~any(a)
        a = cross(n,[0 1 0]);
    end
    b=cross(n,a);
    a=a/norm(a);
    b=b/norm(b);
    c1=c(1)*ones(size(theta,1),1);
    c2=c(2)*ones(size(theta,1),1);
    c3=c(3)*ones(size(theta,1),1);
    x=c1+r*a(1)*cos(theta)+r*b(1)*sin(theta);
    y=c2+r*a(2)*cos(theta)+r*b(2)*sin(theta);
    z=c3+r*a(3)*cos(theta)+r*b(3)*sin(theta);
    points = [x y z];
    T = points;
end
