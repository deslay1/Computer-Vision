%% Computer Exercise 1
load CompEx1data.mat

%% Plot 3D reconstruction points
figure(1)
axis equal
X3 = pflat(X);
plot3(X3(1,:), X3(2,:), X3(3,:), '.', 'Markersize', 2);
hold on
plotcams(P);

%% Project into a camera and plot result
% Camera 4
P4 = P{4};
y = P4*X;
yh = [pflat(y); ones(1,length(y))];

figure(2)
axis equal
im = imread(imfiles{4});
imagesc(im);
hold on
plot3(yh(1,:), yh(2,:), yh(3,:), 'ro', 'Markersize', 2);
visible = isfinite(x{4}(1 ,:));
plot(x{4}(1, visible), x{4}(2, visible),'*');

%% T1 and T2
T1 = [1 0 0 0; 0 4 0 0; 0 0 1 0; 1/10 1/10 0 1];
T2 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1];

% New cameras and 3D points
Xnew1 = T1*X;
Xnew2 = T2*X;
Pnew1 = {};
Pnew2 = {};
for i=1:length(P)
    Pnew1{i} = P{i}/T1;
    Pnew2{i} = P{i}/T2;
end

% Plot new solutions
figure(3)
subplot(1,2,1)
X1 = pflat(Xnew1);
plot3(X1(1,:), X1(2,:), X1(3,:), '.', 'Markersize', 2);
hold on
axis equal
plotcams(Pnew1);

subplot(1,2,2)
X2 = pflat(Xnew2);
plot3(X2(1,:), X2(2,:), X2(3,:), '.', 'Markersize', 2);
hold on
axis equal
plotcams(Pnew2);

%% Plot new 3D points into camera 4
% T1
P4 = Pnew1{4};
y = P4*Xnew1;
yh = [pflat(y); ones(1,length(y))];

figure(4)
axis equal
imagesc(im);
hold on
plot3(yh(1,:), yh(2,:), yh(3,:), 'ro', 'Markersize', 2);

visible = isfinite(x{4}(1 ,:));
plot(x{4}(1, visible), x{4}(2, visible),'b*');

% T2
P4 = Pnew2{4};
y = P4*Xnew2;
yh = [pflat(y); ones(1,length(y))];

figure(5)
axis equal
imagesc(im);
hold on
plot3(yh(1,:), yh(2,:), yh(3,:), 'ro', 'Markersize', 2);
visible = isfinite(x{4}(1 ,:));
plot(x{4}(1, visible), x{4}(2, visible),'b*');

%% Support calcs for normal exercises
P = [1000 -250 250*sqrt(3) 500; 0 500*(sqrt(3)-0.5) 500*(1+(sqrt(3)/2)) 500; 0 -0.5 sqrt(3)/2 1];
Kinv = [0.001 0 -0.5; 0 0.001 -0.5; 0 0 1];
Pnorm = Kinv*P;
Kinv*[500; 500; 1]
