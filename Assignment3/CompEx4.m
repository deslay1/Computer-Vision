%% Computer Exercise 4
load E
load compEx3data
load compEx1data
%% Camera solutions
P1 = [eye(3) zeros(3,1)];

[U, S, V] = svd(E);
W = [0 -1 0; 1 0 0; 0 0 1];
P2_1 =[U*W*V.' U(:,3)];
P2_2 =[U*W*V.' -U(:,3)];
P2_3 =[U*W.'*V.' U(:,3)];
P2_4 =[U*W.'*V.' -U(:,3)];

% Normalize image points with K^-1
x1n = K\x{1};
x2n = K\x{2};

%% Triangulation using DLT
[X1, ~, ~] = DLT(P1, P2_1, x1n, x2n);
[X2, ~, ~] = DLT(P1, P2_2, x1n, x2n);
[X3, ~, ~] = DLT(P1, P2_3, x1n, x2n);
[X4, ~, ~] = DLT(P1, P2_4, x1n, x2n);

% Find best solution (most points in front of camera) for P2
P2 = {P2_1, P2_2, P2_3, P2_4};
X = {X1, X2, X3, X4};
bestSolutionIndex = 0;
maxFrontPoints = 0;
for i=1:4
    xproj = P1*X{i};
    length(find(xproj(end,:) > 0))
    if length(find(xproj(end,:) > 0)) > maxFrontPoints
        maxFrontPoints = length(find(xproj(end,:) > 0));
        bestSolutionIndex = i;
    end
end
Xbest = X{bestSolutionIndex};
P2best = P2{bestSolutionIndex};

%% Un-normalized cameras
P1Un = K*P1;
xproj1 = pflat(P1Un * Xbest);

P2bestUn = K*P2best;
xproj2 = pflat(P2bestUn * Xbest);

%% Plot image, image points and projected 3D points
figure(1)
im2 = imread('kronan2.JPG');
imagesc(im2)
hold on
plot(x{2}(1,:), x{2}(2,:), 'b.', 'Markersize', 20)
plot(xproj2(1,:), xproj2(2,:), 'r*', 'Markersize', 5)
legend('original image points', 'projected points')

%% 3D plots
center1 = pflat(null(P1Un));
center2 = pflat(null(P2bestUn));

figure(2)
Xbesth = pflat(Xbest);
plot3(Xbesth(1,:), Xbesth(2,:), Xbesth(3,:), 'b.')
hold on
% Viewing directions
plotcams({P1Un, P2bestUn})
% Camera centers
plot3(center1(1,1), center1(2,1), center1(3,1), 'r*', 'MarkerSize', 20)
plot3(center2(1,1), center2(2,1), center2(3,1), 'g*', 'MarkerSize', 20)

