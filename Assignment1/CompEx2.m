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