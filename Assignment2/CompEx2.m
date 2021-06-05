%% Computer Exercise 2
load CompEx1data.mat

%% Cameras from solutions in exercise 1 (using camera 4)
format short g
T1 = [1 0 0 0; 0 4 0 0; 0 0 1 0; 1/10 1/10 0 1];
T2 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1];
Porig = P{4};
Pnew1 = P{4}/T1;
Pnew2 = P{4}/T2;

[K1, Q1] = rq(Porig);
[K2, Q2] = rq(Pnew1);
[K3, Q3] = rq(Pnew2);
K1 = K1./K1(3,3);
K2 = K2./K2(3,3);
K3 = K3./K3(3,3);