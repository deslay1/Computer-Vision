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