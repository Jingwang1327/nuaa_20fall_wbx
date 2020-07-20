clc,clear

% �㷨�� 3 sigema ����

syms A Rd rd x y z;

%% ��ʼ��
m = 10; %�趨�״����
Xn = [];
mistake_re = [];
[Rd,rd] = set_value(m); %ģ����ʵ���״�����

% ������������꣬����3sigma�����ų��쳣ֵ
[Xn,mistake_re]= equations_sol(m,Rd,rd,Xn,mistake_re,x,y,z);

Xn = sigma3_method(Xn);
% �жϴ���������״�
[Jnum,Jmis_num] = Judge_radar(mistake_re);

%% ������������꣬����3sigma�����ų��쳣ֵ;
function Xn = sigma3_method(Xn)
    miu1 = mean((Xn),1); % ����ƽ��ֵ
    sigma1 = std((Xn),0,1); % ���ķ���

    for i = 1:3
        id = (Xn(:,i)<(miu1(1,i)-sigma1(1,i))) | (Xn(:,i)>(miu1(1,i)+sigma1(1,i))); % �ų��쳣ֵ
        Xn(id,:) = [];
    end

    miu2 = mean((Xn),1); % ����ƽ��ֵ
    sigma2 = std((Xn),0,1); % ���ķ���
end


%% ������������һ����������������
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

%% ģ����ʵ���״�����
function [Rd,rd] = set_value(m)
    R = 5000*rand(m,3); %������׼�״�����
    S = 5000*rand(1,3)+5000; %������׼����������
    r = sqrt(abs(sum((R-repmat(S,m,1)).^2,2))); %������׼����

    Rd = R + sqrt(1)*randn(m,3); %�����������
    rd = r + randn(m,1); %����������
    rd(2) = rd(2) + 3000; %�趨����������״�
    rd(10) = rd(10) + 3000; %�趨����������״�
end

%% �жϴ���������״�
function [Jnum,Jmis_num] = Judge_radar(mistake_re)
    num=unique(mistake_re(:))'; %���ܴ���������״�����
    mis_num=histc(mistake_re(:),num); %��������״������Ӧ�Ĵ���

    miu_num = mean(mis_num); % ����ƽ��ֵ
    sigma_num = std(mis_num); % ���ķ���
    id = mis_num(:)>(miu_num+sigma_num);

    Jnum = num(id');
    Jmis_num = mis_num(id)';
end