% 2021 UR3 matlab仿真
% 山东大学（威海）2018级 数据科学实验班 孙易泽
% UR3机械臂仿真

clc,clear,close all;
% 输入dh参数，用Link函数构建机械臂
L(1) = Link('d',151.9,'a',0,'alpha',pi/2,'standard');
L(2) = Link('d',0,'a',-243.65,'alpha',0,'offset',-pi/2,'standard');
L(3) = Link('d',0,'a',-213,'alpha',0,'standard');
L(4) = Link('d',83.4,'a',0,'alpha',pi/2,'offset',-pi/2,'standard');
L(5) = Link('d',83.4,'a',0,'alpha',-pi/2,'standard');
L(6) = Link('d',82.4,'a',0,'alpha',0,'standard');
robot = SerialLink(L,'name','ur3','manufacturer','innfos');

% 选取所需执行的轨迹图片
img = 'shanda_icon.png';

% % 以下代码为python程序计算输入图片的轨迹，如果没有path_cal.mat，请先运行以下代码
% % 如果报错，则需要先配置python环境
% % command = ['pip install -r requirements.txt'];
% % status = system(command);
% % 执行python文件
% command = ['python cal_flat_path.py -f',img];
% status = system(command);

% 定义球面半径和球面球心
cen = [300 0 000];
r = 150;

% 加载平面上对应的轨迹
load('path_cal.mat');
P2=writing_path * 2 * r - r;

% 将二维平面轨迹映射到三维球面
for i=1:length(P2)
    P3(i,1) = P2(i,1)+cen(1);
    P3(i,2) = P2(i,2)+cen(2);
    calsqr = r^2- (P3(i, 1)-cen(1))^2 - (P3(i, 2)-cen(2))^2;
    % 判断是否超出球面大小，如果未超过，则增加球面z轴高度
    if calsqr > 0
        P3(i, 3) = sqrt(calsqr)+cen(3)+5;
    else
        P3(i, 3) = cen(3)+5;
    end
end

% 进行机械臂求解
ikInitGuess=zeros(1,6);
for i=1:length(P3)
    % 调整机械臂末端位姿，保持末端始终朝下
    T1(:,:,i)=transl(P3(i,:))*rpy2tr([pi,0,0]);
    config=robot.ikunc(T1(:,:,i),ikInitGuess);
    ikInitGuess=config;
    qrt(i,:)=config;
end

% 球面绘图
figure('color','w');
hold on
[X,Y,Z] = sphere;
X2 = X * r;
Y2 = Y * r;
Z2 = Z * r;
surf(X2+cen(1),Y2+cen(2),Z2+cen(3))
xlim([-800 800]) 
ylim([-800 800])
zlim([-800 800])
% 使球面更平滑
grid off 
shading interp 

% 将机械臂轨迹可视化
W = [-800, +800, -800, +800, -800, +800];
hold on
robot.plot(qrt, 'tilesize', 150, 'workspace', W, 'trail', '-r', 'jointdiam', 1)
robot.plot(qrt, 'tilesize', 150, 'workspace', W, 'trail', '-r', 'jointdiam', 1)
