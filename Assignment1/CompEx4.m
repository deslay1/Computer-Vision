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
plot3(u1(1,:),u1(2,:),u1(3,:),'.')

% Project points in U into P2
% figure(3)
subplot(1,2,2)
u2 = pflat(P2*U);
u2 = [u2; ones(1, length(u2))];
imagesc(im2)
hold on
plot3(u2(1,:),u2(2,:),u2(3,:),'.')