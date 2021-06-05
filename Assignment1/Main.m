%% Computer Exercise 1
load('compEx1.mat')

twoD = pflat(x2D);
figure(1)
subplot(1,2,1)
plot(twoD(1,:), twoD(2,:),'.');
title('2D plot of points in x2D');

threeD = pflat(x3D);
%figure(2)
subplot(1,2,2)
plot3(threeD(1,:), threeD(2,:), threeD(3,:), '.')
title('3D plot of points in x3D');

%% Computer Exercise 2
figure(1)
I = imread('compEx2.jpg');
imagesc(I);
colormap  gray

imagePoints = load('compEx2.mat');
p1 = imagePoints.p1;
p2 = imagePoints.p2;
p3 = imagePoints.p3;
hold on;
plot(p1(1,1), p1(2,1), 'rx','linewidth', 10);
plot(p1(1,2), p1(2,2), 'rx','linewidth', 10);
plot(p2(1,1), p2(2,1), 'bx','linewidth', 10);
plot(p2(1,2), p2(2,2), 'bx','linewidth', 10);
plot(p3(1,1), p3(2,1), 'gx','linewidth', 10);
plot(p3(1,2), p3(2,2), 'gx','linewidth', 10);

lines = zeros(3,3);
lines(:,1) = null(p1.');
lines(:,2) = null(p2.');
lines(:,3) = null(p3.');
rital(lines)

title('Plots for computer exercise 2');

poi = null([lines(:,2).'; lines(:,3).']);
poi_h = [pflat(poi); 1.0];
plot(poi_h(1), poi_h(2), 'yo','linewidth', 10)

% Distance between first line and intersection point poi_h
dist = abs(lines(1,1)*poi_h(1,1) + lines(2,1)*poi_h(2,1) + lines(3,1)) / sqrt(lines(1,1)^2 + lines(2,1)^2);

%% Computer Exercise 3
grid = load('CompEx3.mat');
sps = grid.startpoints;
eps = grid.endpoints;

% Transformation matrices
H1 = [sqrt(3) -1 1; 1 sqrt(3) 1; 0 0 2];
H2 = [1 -1 1; 1 1 0; 0 0 1];
H3 = [1 1 0; 0 2 0; 0 0 1];
H4 = [sqrt(3) -1 1; 1 sqrt(3) 1; 1/4 1/2 2];

% plot([sps(1,:);eps(1,:)] ,[sps(2,:);eps(2,:)], '-b')

% Convert to homogeneous coordinates for transformation
sps = [sps; ones(1,length(sps))];
eps = [eps; ones(1,length(eps))];

figure(1)
axis equal
subplot(2,2,1)
sps1 = pflat(H1*sps);
eps1 = pflat(H1*eps);
plot([sps1(1,:);eps1(1,:)] ,[sps1(2,:);eps1(2,:)], '-b')
title('Similarity transformation')

% figure(2)
% axis equal
subplot(2,2,2)
sps2 = pflat(H2*sps);
eps2 = pflat(H2*eps);
plot([sps2(1,:);eps2(1,:)] ,[sps2(2,:);eps2(2,:)], '-b')
title('Euclidean transformation')

% figure(3)
% axis equal
subplot(2,2,3)
sps3 = pflat(H3*sps);
eps3 = pflat(H3*eps);
plot([sps3(1,:);eps3(1,:)] ,[sps3(2,:);eps3(2,:)], '-b')
title('Affine transformation')


% figure(4)
% axis equal
subplot(2,2,4)
sps4 = pflat(H4*sps);
eps4 = pflat(H4*eps);
plot([sps4(1,:);eps4(1,:)] ,[sps4(2,:);eps4(2,:)], '-b')
title('Projective transformation')


%% Computer Exercise 4
im1 = imread('compEx4im1.JPG');
im2 = imread('compEx4im2.JPG');
load compEx4.mat

cameraCenter1 = pflat(null(P1));
cameraCenter2 = pflat(null(P2));
cameraCenter1 = [cameraCenter1; 1];
cameraCenter2 = [cameraCenter2; 1];

% Plot 3D points of U and cameracenters
figure(1)
Uh = pflat(U);
plot3(Uh(1,:), Uh(2,:), Uh(3,:), '.')
hold on
plot3(cameraCenter1(1), cameraCenter1(2), cameraCenter1(3), 'b-', 'linewidth', 10, 'Markersize' ,10)
plot3(cameraCenter2(1), cameraCenter2(2), cameraCenter2(3), 'r-', 'linewidth', 10, 'Markersize' ,10)

% Viewing directions
v1 = P1(3,1:3);
v2 = P2(3,1:3); 
quiver3(cameraCenter1(1), cameraCenter1(2), cameraCenter1(3), v1(1), v1(2), v1(3), 10)
quiver3(cameraCenter2(1), cameraCenter2(2), cameraCenter2(3), v2(1), v2(2), v2(3), 10)

% Project points in U into P1
figure(2)
subplot(1,2,1)
u1 = pflat(P1*U);
u1 = [u1; ones(1, length(u1))];
imagesc(im1)
hold on
plot3(u1(1,:),u1(2,:),u1(3,:))

% Project points in U into P2
% figure(3)
subplot(1,2,2)
u2 = pflat(P2*U);
u2 = [u2; ones(1, length(u2))];
imagesc(im2)
hold on
plot3(u2(1,:),u2(2,:),u2(3,:))