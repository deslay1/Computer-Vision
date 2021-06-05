%% Computer Exercise 2
load F
load compEx1data

%% Normalize image points
x1 = x{1};
m1 = mean(x1, 2);
s1 = std(x1,0,2);
x2 = x{2};
m2 = mean(x2, 2);
s2 = std(x2,0,2);

% Normalization
N1 = [1./s1(1) 0 -1./s1(1)*m1(1); 0 1./s1(2) -1./s1(2)*m1(2); 0 0 1];
N2 = [1./s2(1) 0 -1./s2(1)*m2(1); 0 1./s2(2) -1./s2(2)*m2(2); 0 0 1];
% Without normalization
% N1 = eye(3);
% N2 = eye(3);

x1norm = N1*x1;
x2norm = N2*x2;

%% Camera matrices and DLT
e2 = null(F.');
e2skew = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];

P1 = [eye(3) zeros(3,1)];
P2 = [e2skew*F e2];

[X, xproj1, xproj2] = DLT(P1,P2, x1, x2);

figure(1)
im1 = imread('kronan1.JPG');
imagesc(im1)
hold on
plot(x1(1,:), x1(2,:), 'b.', 'Markersize', 20)
plot(xproj1(1,:), xproj1(2,:), 'r*')

figure(2)
im2 = imread('kronan2.JPG');
imagesc(im2)
hold on
plot(x2(1,:), x2(2,:), 'b.', 'Markersize', 20)
plot(xproj2(1,:), xproj2(2,:), 'r*')

%% 3D plot of scene points
Xh = pflat(X);
figure(3)
plot3(Xh(1,:), Xh(2,:), Xh(3,:), '.')

%% Quasi Affine solutions
P1quasi = P1;
P1quasi(:,3:4) = P1quasi(:, [4 3]);

P2quasi = P2;
P2quasi(:,3:4) = P2quasi(:, [4 3]);

Xq = X;
Xq(3:4, :) = Xq([4 3], :);

Xh = pflat(Xq);
figure(4)
plot3(Xh(1,:), Xh(2,:), Xh(3,:), '.')