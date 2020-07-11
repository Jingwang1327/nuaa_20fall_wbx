%Here I considered the same objective function as in the article
clear all 
close all
clc
format bank
%Data
load('loaddata.mat')
Pmax=[40; 93; 225; 72; 165]; %in Mw
Pmin=[0; 0; 0; 0; 0];
Vmax=[1753; 133; 21; 10; 519]; %in Mm3
Hmax=[51; 78; 140; 35; 151]; %in m
Hmin=[25; 61; 131; 31; 134]; %in m
Qmax=[198.8; 161.82; 189; 265.68; 132]; %in m3/s
eta=[0.85; 0.9; 0.92; 0.89; 0.9];
Loaddata=Loaddata{:,:};
Pload=300*Loaddata(1:24,1);
I=5;
K=24;
X=3;
Vinit=[1173; 118; 13; 4; 420]; %in Mm3
a=0;
b=15;
r=zeros(I,K); %in m3/s  
to=[2 0 0 4];
Coeff_single=[0.0145788783841956 0.118284880985982 0.425311386020036 0.449703164671501 0.0499028234746773;
              28.8820402594909 63.0107253739769 131.885041670776 31.6539751723080 125.839852904077];
Coeff_multiple=[0.288608733559383 0.608274765062066 1.22450147095732 0.293059162285558 1.25544793476585;
                0.513498224693994 0.653645281922514 0.827395629287059 1.06516763797122 0.566795954800038;
                -17.8581059662019 -45.2558962557572 -112.309759682700 -35.8008294986081 -80.6538723580304];


    %Decision variables
    for i=1:1:I
        for k=1:1:K
           h=sdpvar(I,K);
           p=sdpvar(I,K);
           V=sdpvar(I,K);
           q=sdpvar(I,K);
           s=sdpvar(I,K);
           z=binvar(I,K);
       end
    end
    %Initializing objective and constraints
    objective=0;
    constraints=[];
    epsilon=0.001;
    n=100;
    tolerance=0.1;
    
    for i=1:I
        for k=1:K
            
            
            objective=objective-h(i,k)+1e8*s(i,k);



                 
             if k==1 

                    constraints=[constraints,V(i,k)==Vinit(i)];

                 elseif i==1

                    constraints=[constraints,V(i,k)==V(i,k-1)+3600*1e-6*r(i,k)-3600*1e-6*q(i,k)-3600*1e-6*s(i,k)];

                 else

                    constraints=[constraints, V(i,k)==V(i,k-1)+3600*1e-6*r(i,k)+3600*1e-6*q(i-1,k-to(i-1))+3600*1e-6*s(i-1,k-to(i-1))-3600*1e-6*q(i,k)-3600*1e-6*s(i,k)];

                 end
                constraints=[constraints, h(i,k)==Coeff_single(1,i)*V(i,k)+Coeff_single(2,i),
                    0<=V(i,k)<=Vmax(i), s(i,k)>=0,0<=h(i,k)<=Hmax(i),
                    p(i,k)<=Pmax(i)*z(i,k),
                    p(i,k)>=Pmin(i)*z(i,k),
                    p(i,k)<=Coeff_multiple(1,i)*q(i,k)+Coeff_multiple(2,i)*h(i,k)+Coeff_multiple(3,i)-Pmin(i)*(1-z(i,k)),
                    p(i,k)>=Coeff_multiple(1,i)*q(i,k)+Coeff_multiple(2,i)*h(i,k)+Coeff_multiple(3,i)-Pmax(i)*(1-z(i,k)),
                    z(i,k)*0.1<=q(i,k)<=z(i,k)*Qmax(i),
                    p(1,k)+p(2,k)+p(3,k)+p(4,k)+p(5,k)==Pload(k),
                    s(i,k)>=0];
                
                
                   
               
        end
    end
    
    
    optimize(constraints, objective);
    


P1=value(p);
Q1=value(q);
Vol1=value(V);
H1=value(h);
Z1=value(z);
S1 = value(s);


    
 save('res1.mat','H1','P1','S1','Vol1','Q1','Z1')

