% 2021 UR3 matlab仿真
% 山东大学（威海）2018级 数据科学实验班 孙易泽
% UR3逆运动学求解

% 先用正运动学求出T06，再进行逆运动学求解
clc,clear
syms t1 t2 t3 t4 t5 t6
syms a2 a3 d1 d4 d5 d6
T0_1 = calTmatrix(90,0,d1,t1);
T1_2 = calTmatrix(0,a2,0,t2);
T2_3 = calTmatrix(0,a3,0,t3);
T3_4 = calTmatrix(90,0,d4,t4);
T4_5 = calTmatrix(-90,0,d5,t5);
T5_6 = calTmatrix(0,0,d6,t6);
T0_6 = T0_1*T1_2*T2_3*T3_4*T4_5*T5_6;
T0_6 = simplify(T0_6);
% 带入逆运动学函数
theta = inv_kinematics(T0_6)

function theta=inv_kinematics(T)
    % 输入dh参数表参数
    a=[0,-0.24365,-0.21300,0,0,0];
    d=[0.15190,0,0,0.08340,0.08340,0.08240];
    % 矩阵赋值便于计算
    nx=T(1,1);ny=T(2,1);nz=T(3,1);
    ox=T(1,2);oy=T(2,2);oz=T(3,2);
    ax=T(1,3);ay=T(2,3);az=T(3,3);
    px=T(1,4);py=T(2,4);pz=T(3,4);
    
    %求关节角1
    m=d(6)*ay-py;  n=ax*d(6)-px; 
    theta1(1,1)=atan2(m,n)-atan2(d(4),sqrt(m^2+n^2-(d(4))^2));
    theta1(1,2)=atan2(m,n)-atan2(d(4),-sqrt(m^2+n^2-(d(4))^2));
  
    %求关节角5
    theta5(1,1:2)=acos(ax*sin(theta1)-ay*cos(theta1));
    theta5(2,1:2)=-acos(ax*sin(theta1)-ay*cos(theta1));      
    
    %求关节角6
    mm=nx*sin(theta1)-ny*cos(theta1); nn=ox*sin(theta1)-oy*cos(theta1);
    %theta6=atan2(mm,nn)-atan2(sin(theta5),0);
    theta6(1,1:2)=atan2(mm,nn)-atan2(sin(theta5(1,1:2)),0);
    theta6(2,1:2)=atan2(mm,nn)-atan2(sin(theta5(2,1:2)),0);
    
    %求关节角3
    mmm(1,1:2)=d(5)*(sin(theta6(1,1:2)).*(nx*cos(theta1)+ny*sin(theta1))+cos(theta6(1,1:2)).*(ox*cos(theta1)+oy*sin(theta1))) ...
        -d(6)*(ax*cos(theta1)+ay*sin(theta1))+px*cos(theta1)+py*sin(theta1);
    nnn(1,1:2)=pz-d(1)-az*d(6)+d(5)*(oz*cos(theta6(1,1:2))+nz*sin(theta6(1,1:2)));
    mmm(2,1:2)=d(5)*(sin(theta6(2,1:2)).*(nx*cos(theta1)+ny*sin(theta1))+cos(theta6(2,1:2)).*(ox*cos(theta1)+oy*sin(theta1))) ...
        -d(6)*(ax*cos(theta1)+ay*sin(theta1))+px*cos(theta1)+py*sin(theta1);
    nnn(2,1:2)=pz-d(1)-az*d(6)+d(5)*(oz*cos(theta6(2,1:2))+nz*sin(theta6(2,1:2)));
    theta3(1:2,:)=acos((mmm.^2+nnn.^2-(a(2))^2-(a(3))^2)/(2*a(2)*a(3)));
    theta3(3:4,:)=-acos((mmm.^2+nnn.^2-(a(2))^2-(a(3))^2)/(2*a(2)*a(3)));
    
    %求关节角2
    mmm_s2(1:2,:)=mmm;
    mmm_s2(3:4,:)=mmm;
    nnn_s2(1:2,:)=nnn;
    nnn_s2(3:4,:)=nnn;
    s2=((a(3)*cos(theta3)+a(2)).*nnn_s2-a(3)*sin(theta3).*mmm_s2)./ ...
        ((a(2))^2+(a(3))^2+2*a(2)*a(3)*cos(theta3));
    c2=(mmm_s2+a(3)*sin(theta3).*s2)./(a(3)*cos(theta3)+a(2));
    theta2=atan2(s2,c2);   
    
    %整理关节角1 5 6 3 2
    theta(1:4,1)=theta1(1,1);theta(5:8,1)=theta1(1,2);
    theta(:,2)=[theta2(1,1),theta2(3,1),theta2(2,1),theta2(4,1),theta2(1,2),theta2(3,2),theta2(2,2),theta2(4,2)]';
    theta(:,3)=[theta3(1,1),theta3(3,1),theta3(2,1),theta3(4,1),theta3(1,2),theta3(3,2),theta3(2,2),theta3(4,2)]';
    theta(1:2,5)=theta5(1,1);theta(3:4,5)=theta5(2,1);
    theta(5:6,5)=theta5(1,2);theta(7:8,5)=theta5(2,2);
    theta(1:2,6)=theta6(1,1);theta(3:4,6)=theta6(2,1);
    theta(5:6,6)=theta6(1,2);theta(7:8,6)=theta6(2,2); 
    
    %求关节角4
    theta(:,4)=atan2(-sin(theta(:,6)).*(nx*cos(theta(:,1))+ny*sin(theta(:,1)))-cos(theta(:,6)).* ...
        (ox*cos(theta(:,1))+oy*sin(theta(:,1))),oz*cos(theta(:,6))+nz*sin(theta(:,6)))-theta(:,2)-theta(:,3);  
end
