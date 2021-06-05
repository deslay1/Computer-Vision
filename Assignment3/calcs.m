%% Exercise 1
P1 = [eye(3) zeros(3,1)];
P2 = [1 1 0 0; 0 2 0 2; 0 0 1 0];

A = P2(1:3,1:3);
e2 = P2(:,end);
e2skew = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];
F = e2skew*A;

x = [1 1 1].';
epi = F*x;

x1 = [2 0 1];
x2 = [2 1 1];
x3 = [4 2 1];
x1*epi
x2*epi
x3*epi

%% Exercise 2
P1 = [eye(3) zeros(3,1)];
P2 = [1 1 1 2; 0 2 0 2; 0 0 1 0];
A = P2(1:3,1:3);
t = P2(:,end);

center1 = [pflat(null(P1)); 1];
center2 = [-A\t; 1];
% not always good...
% center2 = [pflat(null(P2)); 1];

e2 = P2*center1;
e1 = P1*center2;
e2s = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];
F = e2s*A
det(F)

% Verify
e2.'*F
F*e1

%% Exercise 4
Ft = [0 1 0; 1 0 1; 1 0 1];
null(Ft)

%% Exercise 6
U = [1/sqrt(2) -1/sqrt(2) 0; 1/sqrt(2) 1/sqrt(2) 0; 0 0 1];
V = [1 0 0; 0 0 -1; 0 1 0];
W = [0 -1 0; 1 0 0; 0 0 1];
P2 =[U*W.'*V.' -U(:,3)];
P2*[0 0 1 -1/sqrt(2)].'