clc,clear,clf,close all;

[x,y] = meshgrid(-10:0.1:10);
xyz_limit = [-10 10 -10 10 -100 100];
z1 = x.^2-2*y.^2;
% for slice by z
for i = -100:10:100
    a = i;
    z2 = a*ones(size(x));
    r0 = abs(z1-z2)<=1;
    zz = r0.*z2;
    xx = r0.*x;
    yy = r0.*y;
    if a > 0
        figure(1)
    elseif a < 0
        figure(2)
    elseif a == 0
        figure(3)
    end
    subplot(1,2,1);
    mesh(x,y,z1);
    grid,hold on;
    mesh(x,y,z2);
    hidden off;
    h2=plot3(xx(r0~=0),yy(r0~=0),zz(r0~=0),'.');
    xlabel('X'),ylabel('Y'),zlabel('Z');
    title('马鞍面的横向平行截面');
    axis(xyz_limit);
    grid on;
    subplot(1,2,2);
    h4=plot3(xx(r0~=0),yy(r0~=0),zz(r0~=0),'o');
    xlabel('X'),ylabel('Y'),zlabel('Z');
    if a > 0
        title('Z > 0 的截面情况');
    elseif a < 0
        title('Z < 0 的截面情况');
    elseif a == 0
        title('Z = 0 的截面情况');
    end
    set(h4,'markersize',2);
    hold on;
    axis(xyz_limit);
    grid on;
end

% for slice by y
[X,Z] = meshgrid(-10:0.1:10,-100:100);
[x,y1] = meshgrid(-10:0.1:10);
z = x.^2-2*y1.^2;
for i = -5:5:5
    a = i;
    y2 = a*ones(size(Z));
    r0 = abs(y1-y2)<=0.1;
    zz = r0.*z;
    xx = r0.*x;
    yy = r0.*y2;
    figure(4)
    subplot(1,2,1);
    mesh(x,y1,z);
    grid,hold on;
    mesh(X,y2,Z);
    hidden off;
    h2=plot3(xx(r0~=0),yy(r0~=0),zz(r0~=0),'.');
    xlabel('X'),ylabel('Y'),zlabel('Z');
    title('马鞍面的纵向平行截面');
    axis(xyz_limit);
    grid on;
    subplot(1,2,2);
    h4=plot3(xx(r0~=0),yy(r0~=0),zz(r0~=0),'o');
    xlabel('X'),ylabel('Y'),zlabel('Z');
    set(h4,'markersize',2);
    hold on;
    axis(xyz_limit);
    grid on;
end



