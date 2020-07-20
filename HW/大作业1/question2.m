clc,clear

% 算法二 3 sigema 法则

syms A Rd rd x y z;

%% 初始化
m = 10; %设定雷达个数
Xn = [];
mistake_re = [];
[Rd,rd] = set_value(m); %模拟真实的雷达数据

% 计算飞行器坐标，并用3sigma法则排除异常值
[Xn,mistake_re]= equations_sol(m,Rd,rd,Xn,mistake_re,x,y,z);

Xn = sigma3_method(Xn);
% 判断存在问题的雷达
[Jnum,Jmis_num] = Judge_radar(mistake_re);

%% 计算飞行器坐标，并用3sigma法则排除异常值;
function Xn = sigma3_method(Xn)
    miu1 = mean((Xn),1); % 误差的平均值
    sigma1 = std((Xn),0,1); % 误差的方差

    for i = 1:3
        id = (Xn(:,i)<(miu1(1,i)-sigma1(1,i))) | (Xn(:,i)>(miu1(1,i)+sigma1(1,i))); % 排除异常值
        Xn(id,:) = [];
    end

    miu2 = mean((Xn),1); % 误差的平均值
    sigma2 = std((Xn),0,1); % 误差的方差
end


%% 按照三个方程一组计算飞行器的坐标
function [Xn,mistake_re] = equations_sol(m,Rd,rd,Xn,mistake_re,x,y,z)
    result = [NaN NaN NaN];
    for i = 1:m
        eq1 = sum((Rd(i,:) - [x y z]).^2) - rd(i).^2 == 0;
        for j = i+1:m
            eq2 = sum((Rd(j,:) - [x y z]).^2) - rd(j).^2 == 0;
            for k = j+1:m
                eq3 = sum((Rd(k,:) - [x y z]).^2) - rd(k).^2 == 0;
                sol = solve(eq1,eq2,eq3,x,y,z);
                for g = 1:2
                    a = vpa(sol.x(g,1));b = vpa(sol.y(g,1)); c = vpa(sol.z(g,1));
                    if (a>0 && b >0 && c>0 && isreal(a))
                        result = [double(vpa(sol.x(g,1))) double(vpa(sol.y(g,1))) double(vpa(sol.z(g,1)))];
                        Xn = [Xn;result];
                    elseif g == 2
                        mistake_re = [mistake_re,[i j k]];
                    end
                end
            end
        end
    end
end

%% 模拟真实的雷达数据
function [Rd,rd] = set_value(m)
    R = 5000*rand(m,3); %产生标准雷达坐标
    S = 5000*rand(1,3)+5000; %产生标准飞行器坐标
    r = sqrt(abs(sum((R-repmat(S,m,1)).^2,2))); %产生标准距离

    Rd = R + sqrt(1)*randn(m,3); %引入坐标误差
    rd = r + randn(m,1); %引入距离误差
    rd(2) = rd(2) + 3000; %设定存在问题的雷达
    rd(10) = rd(10) + 3000; %设定存在问题的雷达
end

%% 判断存在问题的雷达
function [Jnum,Jmis_num] = Judge_radar(mistake_re)
    num=unique(mistake_re(:))'; %汇总存在问题的雷达类型
    mis_num=histc(mistake_re(:),num); %计算各个雷达出错相应的次数

    miu_num = mean(mis_num); % 误差的平均值
    sigma_num = std(mis_num); % 误差的方差
    id = mis_num(:)>(miu_num+sigma_num);

    Jnum = num(id');
    Jmis_num = mis_num(id)';
end