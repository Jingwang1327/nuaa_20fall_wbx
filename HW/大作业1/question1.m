%%
clc,clear;

m = 10;       %�趨�״���� m
n = 10000;
dist = 5000;
Xn = zeros(10,3);
Sn = zeros(10,3);

% ȷ�����趨�㷨һ�ľ���
for i = 1:n
    [S,Rd,rd] = set_value(m,dist);
    X = overdetermined_equation(Rd,rd);
    Xn(i,:) = X;
    Sn(i,:) = S;
end
miu = mean((Xn-Sn),1);   % ����ƽ��ֵ
sigma = std((Xn-Sn),0,1); % ���ķ���

% ������׼���
function [S,Rd,rd] = set_value(m,dist)
R = dist*rand(m,3); %������׼�״�����
S = dist*rand(1,3)+5000; %������׼����������
r = sqrt(abs(sum((R-repmat(S,m,1)).^2,2))); %������׼����

Rd = R + sqrt(1)*randn(m,3); %�����������
rd = r + randn(m,1); %����������
end

function X = overdetermined_equation(Rd,rd)
m = size(Rd,1); 
A = 2.*(Rd(2:m,:) - repmat(Rd(1,:),m-1,1));
b = sum(Rd(2:m,:).^2 - repmat(Rd(1,:),m-1,1).^2,2) - rd(2:m,:).^2 + repmat(rd(1,:),m-1,1).^2;

M = A'*b;
N = A'*A;
X = N\M;
end
