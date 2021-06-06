% 2021 UR3 matlab仿真
% 山东大学（威海）2018级 数据科学实验班 孙易泽
% UR3机械臂仿真-利用simscape可视化

% 如果文件夹已有UR3.slx文件，该程序可以不用执行
clear,clc;
% 加载事先用solidwork导出的urdf模型
robot = importrobot('UR3/urdf/UR3.urdf');
showdetails(robot);
show(robot,'Frames','on','Visuals','on');
robot_sm = smimport('UR3/urdf/UR3.urdf');

