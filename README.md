# UR3 matlab仿真

## 坐标系建立

<table>
    <tr>
        <td ><center><img src="./essay/img/img2.png"  width="60%" > </center></td>
        <td ><center><img src="./essay/img/img3.png"  width="60%"></center></td>
    </tr>
    <tr>
        <td><center>UR3机械臂数据</center></td>
        <td><center>UR3坐标系建立</center> </td>
    </tr>
</table>

## D-H参数表

| #      | $\theta_i$ | $d_i(m)$ | $a_i(m)$ | $\alpha_i(rad)$ |
| :-: | :-: | :-: | :-:  | :-:  |
| 1 | $\theta_1$ | 0.15190 |0|$\frac{\pi}{2}$|
| 2 | $\theta_2$ | 0 |-0.24365|0|
| 3 | $\theta_3$ | 0 |-0.21300|0|
| 4 | $\theta_4$ | 0.08340 |0|$\frac{\pi}{2}$|
| 5 | $\theta_5$ | 0.08340 |0|$-\frac{\pi}{2}$|
| 6 | $\theta_6$ | 0.08240 |0|0|

## ${ }_{6}^{0} T$表达式推导

公式推导：
$$
_i^{i-1}T = 

\begin{bmatrix} 
cos(\theta_i)&-sin(\theta_i)&0&0 \\
sin(\theta_i)&cos(\theta_i)&0&0 \\
0&0&1&0 \\ 
0&0&0&1 \\ 
\end{bmatrix} 
\begin{bmatrix} 
1&0&0&0 \\
0&1&0&0 \\
0&0&1&d_i \\ 
0&0&0&1 \\ \end{bmatrix}
\begin{bmatrix} 
1&0&0&0 \\
0&cos(\alpha_i)&-sin(\alpha_i)&0 \\
0&sin(\alpha_i)&cos(\alpha_i)&0 \\ 
0&0&0&1 \\ \end{bmatrix}
\begin{bmatrix} 
1&0&0&a_i \\
0&1&0&0 \\
0&0&1&0 \\ 
0&0&0&1 \\ \end{bmatrix} \\
$$

$$
\begin{equation}
{ }_{i}^{i-1} T=\left[\begin{array}{llll}
\cos \left(\theta_{i}\right) & -\sin \left(\theta_{i}\right) \cos \left(\alpha_{i}\right) & \sin \left(\theta_{i}\right) \sin \left(\alpha_{i}\right) & a_{i} \cos \left(\theta_{i}\right) \\
\sin \left(\theta_{i}\right) & \cos \left(\theta_{i}\right) \cos \left(\alpha_{i}\right) & -\cos \left(\theta_{i}\right) \sin \left(\alpha_{i}\right) & a_{i} \sin \left(\theta_{i}\right) \\
0 & \sin \left(\alpha_{i}\right) & \cos \left(\alpha_{i}\right) & d_{i} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

matlab计算，得：
$$
\begin{equation}
{ }_{1}^{0} T=\left[\begin{array}{llll}
\cos \left(\theta_{1}\right) & 0 & \sin \left(\theta_{1}\right) & 0 \\
\sin \left(\theta_{1}\right) & 0 & -\cos \left(\theta_{1}\right) & 0 \\
0 & 1 & 0 & d_{1} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

$$
\begin{equation}
{ }_{2}^{1} T=\left[\begin{array}{llll}
\cos \left(\theta_{2}\right) & -\sin \left(\theta_{2}\right) & 0 & a_{2} \cos \left(\theta_{2}\right) \\
\sin \left(\theta_{2}\right) & \cos \left(\theta_{2}\right) & 0 & a_{2} \sin \left(\theta_{2}\right) \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

$$
\begin{equation}
{ }_{3}^{2} T=\left[\begin{array}{llll}
\cos \left(\theta_{3}\right) & -\sin \left(\theta_{3}\right) & 0 & a_{3} \cos \left(\theta_{3}\right) \\
\sin \left(\theta_{3}\right) & \cos \left(\theta_{3}\right) & 0 & a_{3} \sin \left(\theta_{3}\right) \\
0 & 0 & 1 & 0 \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

$$
\begin{equation}
{ }_{4}^{3} T=\left[\begin{array}{llll}
\cos \left(\theta_{4}\right) & 0 & \sin \left(\theta_{4}\right) & 0 \\
\sin \left(\theta_{4}\right) & 0 & -\cos \left(\theta_{4}\right) & 0 \\
0 & 1 & 0 & d_{4} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

$$
\begin{equation}
{ }_{5}^{4} T=\left[\begin{array}{llll}
\cos \left(\theta_{5}\right) & 0 & -\sin \left(\theta_{5}\right) & 0 \\
\sin \left(\theta_{5}\right) & 0 & \cos \left(\theta_{5}\right) & 0 \\
0 & -1 & 0 & d_{5} \\
0 & 0 & 0  & 1
\end{array}\right]
\end{equation}
$$

$$
\begin{equation}
{ }_{6}^{5} T=\left[\begin{array}{llll}
\cos \left(\theta_{6}\right) & -\sin \left(\theta_{6}\right) & 0 & 0 \\
\sin \left(\theta_{6}\right) & \cos \left(\theta_{6}\right) & 0 & 0 \\
0 & 0 & 1 & d_{6} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$

最终，得：
$$
\begin{equation}
\begin{aligned}
{ }_{6}^{0} T=&{ }_{1}^{0} T \cdot{ }_{2}^{1} T \cdot{ }{ }_{3}^{2} T \cdot{ }_{4}^{3} T \cdot{ }_{5}^{4} T \cdot_{6}^{5} T \\
&=\left[\begin{array}{cccc}
n_{x} & o_{x} & a_{x} & p_{x} \\
n_{y} & o_{y} & a_{y} & p_{y} \\
n_{z} & o_{z} & a_{z} & p_{z} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{aligned}
\end{equation}
$$

用matlab求解，得：

$$
r1=\begin{equation}
c (\theta_{6})(s (\theta_{1})s (\theta_{5})+c (\theta_{2}+\theta_{3}+\theta_{4})s (\theta_{1})c (\theta_{5}))-s (\theta_{2}+\theta_{3}+\theta_{4})c (\theta_{1})s(\theta_{6})
\end{equation}
$$

## 逆运动学求解

机器人的逆运动学求解，即根据给定的机械臂末端位置和姿态，求出与该姿态对应的六个关节的角度。在本题中，使用解析法进行推导，并用matlab进行验证。

### 解析法求解

#### 求关节角1

已知：
$$
\begin{equation}
{ }_{6}^{0} T=\left[\begin{array}{cccc}
n_{x} & o_{x} & a_{x} & p_{x} \\
n_{y} & o_{y} & a_{y} & p_{y} \\
n_{z} & o_{z} & a_{z} & p_{z} \\
0 & 0 & 0 & 1
\end{array}\right]={ }_{1}^{0} T \cdot{ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T \cdot{ }_{5}^{4} T \cdot{ }_{6}^{5} T
\end{equation}
$$
所以有：
$$
\begin{equation}
{ }_{1}^{0} T^{-1} \cdot T \cdot{ }_{6}^{5} T^{-1}={ }_{5}^{1} T={ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }{ }_{4}^{3} T \cdot{ }_{5}^{4} T
\end{equation}
$$
因为：
$$
\begin{equation}
{ }_{1}^{0} T^{-1}=\left[\begin{array}{cccc}
\cos \theta_{1} & \sin \theta_{1} & 0 & 0 \\
0 & 0 & 1 & -d_{1} \\
\sin \theta_{1} & -\cos \theta_{1} & 0 & 0 \\
0 & 0 & 0 & 1
\end{array}\right], \quad{ }_{6}^{5} T^{-1}=\left[\begin{array}{cccc}
\cos \theta_{6} & \sin \theta_{6} & 0 & 0 \\
-\sin \theta_{6} & \cos \theta_{6} & 0 & 0 \\
0 & 0 & 1 & -d_{6} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$
所以：
$$
\begin{equation}
{ }_{1}^{0} T^{-1} \cdot T \cdot{ }_{6}^{5} T^{-1}=
\left[\begin{array}{cccc}
c_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)-s_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right) & s_{s}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{j} s_{1}\right) & a_{x} c_{1}+a_{j} s_{1} & p_{x} c_{1}-d_{6}\left(a_{s} c_{1}+a_{j} s_{1}\right)+p_{y} s_{1} \\
n_{x} c_{6}-o_{z} s_{6} & o_{z} c_{6}+n_{z} s_{6} & a_{i} & p_{z}-d_{1}-a_{i} d_{6} \\
s_{6}\left(o_{y} c_{1}-o_{z} s_{1}\right)-c_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right) & -s_{6}\left(n_{y} c_{1}-n_{2} s_{1}\right)-c_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right) & a_{x} s_{1}-a_{2} c_{1} & -p_{y} c_{1}+d_{6}\left(a_{y} c_{1}-a_{i} s_{1}\right)+p_{x} s_{1} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$
而：
$$
\begin{equation}
{ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T \cdot{ }_{5}^{4} T=\left[\begin{array}{cccc}
c_{234} c_{5} & -s_{234} & -c_{234} s_{5} & a_{3} c_{23}+a_{2} c_{2}+d_{2} s_{234} \\
s_{234} c_{5} & c_{234} & -s_{234} s_{5} & a_{3} s_{23}+a_{2} s_{2}-d_{5} c_{234} \\
s_{5} & 0 & c_{5} & d_{4} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$
根据两式第三行第四列相等，有
$$
\begin{equation}
d_{4}=-p_{y} c_{1}+d_{6}\left(a_{y} c_{1}-a_{x} s_{1}\right)+p_{x} s_{1}
\end{equation}
$$
令$m=d_{6} a_{y}-p_{y}, n=a_{x} d_{6}-p_{x}$，有
$$
\begin{equation}
\theta_{1}=a \tan 2(m, n)-a \tan 2\left(d_{4}, \pm \sqrt{m^{2}+n^{2}-d_{4}^{2}}\right)
\end{equation}
$$
共有两个解

#### 求关节角5

根据两式第三行第三列相等，有$c_{5}=a_{x} s_{1}-a_{y} c_{1}$，有
$$
\begin{equation}
\theta_{5}=\pm \arccos \left(a_{x} s_{1}-a_{y} c_{1}\right)
\end{equation}
$$
共有四个解。

#### 求关节角6

根据两式第三行第一列相等，有$s_{5}=s_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right)-c_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right)$

令$m m=n_{x} s_{1}-n_{y} c_{1}, \quad n n=o_{x} s_{1}-o_{y} c_{1}$，有：
$$
\begin{equation}
\theta_{6}=a \tan 2(m m, n n)-a \tan 2\left(s_{5}, 0\right)
\end{equation}
$$
共有四个解

#### 求关节角3

目前已知：
$$
\begin{equation}
{ }_{6}^{0} T=\left[\begin{array}{cccc}
n_{x} & o_{x} & a_{x} & p_{x} \\
n_{y} & o_{y} & a_{y} & p_{y} \\
n_{z} & o_{z} & a_{z} & p_{z} \\
0 & 0 & 0 & 1
\end{array}\right]={ }_{1}^{0} T \cdot{ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T \cdot{ }_{5}^{4} T \cdot{ }_{6}^{5} T
\end{equation}
$$
所以有：
$$
\begin{equation}
{ }_{1}^{0} T^{-1} \cdot T \cdot{ }_{6}^{5} T^{-1} \cdot{ }_{5}^{4} T^{-1}={ }_{4}^{1} T={ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T
\end{equation}
$$
因为：
$$
\begin{equation}
{ }_{5}^{4} T^{-1}=\left[\begin{array}{cccc}
\cos \theta_{5} & \sin \theta_{5} & 0 & 0 \\
0 & 0 & -1 & d_{5} \\
-\sin \theta_{5} & \cos \theta_{5} & 0 & 0 \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$
所以：
$$
\begin{equation}
{ }_{1}^{0} T^{-1} \cdot T \cdot{ }_{6}^{5} T^{-1} \cdot{ }_{5}^{4} T^{-1}=
\begin{aligned}
&\left[\begin{array}{ccc}
c_{5}\left(c_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)-s_{6}\left(0_{x} c_{1}+o_{y} s_{1}\right)\right)-s_{5}\left(a_{x} c_{1}+a_{y} s_{1}\right) & s_{5}\left(c_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)-s_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)\right)+c_{5}\left(a_{x} c_{1}+a_{y} s_{1}\right) \\
c_{5}\left(n_{x} c_{6}-o_{z} s_{6}\right)-s_{5} a_{z} & s_{5}\left(n_{x} c_{6}-o_{z} s_{6}\right)+c_{5} a_{z} & \\
c_{5}\left(s_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right)-c_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right)\right)-s_{5}\left(a_{x} s_{1}-a_{y} c_{1}\right) & s_{5}\left(s_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right)-c_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right)\right)+c_{5}\left(a_{x} s_{1}-a_{y} c_{1}\right) \\
0 & 0
\end{array}\right.\\
&\left.\begin{array}{cc}
-\left(s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)\right) & d_{5}\left(s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)\right)+p_{x} c_{1}-d_{6}\left(a_{x} c_{1}+a_{y} s_{1}\right)+p_{y} s_{1} \\
-\left(o_{z} c_{6}+n_{z} s_{6}\right) & d_{5}\left(o_{z} c_{6}+n_{z} s_{6}\right)+p_{z}-d_{1}-a_{6} d_{6} \\
s_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right)+c_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right) & d_{5}\left(-s_{6}\left(n_{y} c_{1}-n_{x} s_{1}\right)-c_{6}\left(o_{y} c_{1}-o_{x} s_{1}\right)\right)-p_{y} c_{1}+d_{6}\left(a_{y} c_{1}-a_{x} s_{1}\right)+p_{x} s_{1} \\
0 & 1
\end{array}\right]
\end{aligned}
\end{equation}
$$
因为：
$$
\begin{equation}
{ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T=\left[\begin{array}{cccc}
c_{234} & 0 & s_{234} & a_{3} c_{23}+a_{2} c_{2} \\
s_{234} & 0 & -c_{234} & a_{3} s_{23}+a_{2} s_{2} \\
0 & 1 & 0 & d_{4} \\
0 & 0 & 0 & 1
\end{array}\right]
\end{equation}
$$
根据两式第一行第四列相等，第二行第四列相等，有：
$$
\begin{equation}
d_{5}\left(s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)\right)+p_{x} c_{1}-d_{6}\left(a_{x} c_{1}+a_{y} s_{1}\right)+p_{y} s_{1}=a_{3} c_{23}+a_{2} c_{2}
\end{equation}
$$

$$
\begin{equation}
d_{5}\left(o_{z} c_{6}+n_{z} s_{6}\right)+p_{z}-d_{1}-a_{z} d_{6}=a_{3} s_{23}+a_{2} s_{2}
\end{equation}
$$

令$\mathrm{mmm}=d_{5}\left(s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)\right)+p_{x} c_{1}-d_{6}\left(a_{x} c_{1}+a_{y} s_{1}\right)+p_{y} s_{1}$，$n n n=d_{5}\left(o_{z} c_{6}+n_{z} s_{6}\right)+p_{z}-d_{1}-a_{z} d_{6}$，有：
$$
\begin{equation}
\theta_{3}=\pm \arccos \left(\frac{m m m^{2}+n n n^{2}-a_{2}^{2}-a_{3}^{2}}{2 a_{2} a_{3}}\right)
\end{equation}
$$
共有8个解。

#### 求关节角2

同时，有：
$$
\begin{equation}
s_{2}=\frac{\left(a_{3} c_{3}+a_{2}\right) n n n-a_{3} s_{3} m m m}{a_{2}^{2}+a_{3}^{2}+2 a_{2} a_{3} c_{3}}, c_{2}=\frac{m m m+a_{3} s_{3} s_{2}}{a_{3} c_{3}+a_{2}}
\end{equation}
$$
所以：
$$
\begin{equation}
\theta_{2}=a \tan 2\left(s_{2}, c_{2}\right)
\end{equation}
$$
共有八个解。

#### 求关节角4

根据${ }_{1}^{0} T^{-1} \cdot T \cdot{ }_{6}^{5} T^{-1}={ }_{5}^{1} T={ }_{2}^{1} T \cdot{ }_{3}^{2} T \cdot{ }_{4}^{3} T \cdot{ }_{5}^{4} T$，有
$$
\begin{equation}
-s_{234}=s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)+c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right)
\end{equation}
$$

$$
c_{234}=o_{z} c_{6}+n_{z} s_{6}
$$

所以，有：
$$
\begin{equation}
\theta_{4}=a \tan 2\left(-s_{6}\left(n_{x} c_{1}+n_{y} s_{1}\right)-c_{6}\left(o_{x} c_{1}+o_{y} s_{1}\right), o_{z} c_{6}+n_{z} s_{6}\right)-\theta_{2}-\theta_{3}
\end{equation}
$$
共有八个解。
