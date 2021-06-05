%% Computer Exercise 2
clearvars
close all
load compEx2data

%% Essential matrix using RANSAC
x1h = [x{1}; ones(1, length(x{1}))];
x2h = [x{2}; ones(1, length(x{2}))];

maxDistance = 5;
numPoints = 5;
bestE = [];
bestIdx = [];
bestErrors = [];
for k=1:1000
    idx = randsample(length(x1h), numPoints);
    
    x1min = K\x1h(:, idx);
    x2min = K\x2h(:, idx);
    E = fivepoint_solver(x1min, x2min);
    % Test solutions in E
    for e=1:length(E)
        Enorm = inv(K).'*E{e}*inv(K);
        inliers = [];
        errors = [];
        for i=1:length(x1h)
            line = Enorm*x1h(:,i);
            line = line/norm(line(1:2));
            error = abs(x2h(:,i).' * line);
            % Check if point is an inlier
            if error <= maxDistance
                inliers(end+1) = i;
                errors(end+1) = error;
            end
        end
        % Test against best solution found so far.
        if length(inliers) > length(bestIdx)
            bestE = E{e};
            bestIdx = inliers;
            bestErrors = errors;
        end
    end
end

%% Extract camera matrix and triangulate 3D points
P1 = [eye(3) zeros(3,1)];

[U, S, V] = svd(bestE);
% CHECK THAT det(U*V') = 1, see lecture notes 9 sec 1.1
check = det(U*V.');
if check ~= 1
    V = -1*V;
end
W = [0 -1 0; 1 0 0; 0 0 1];

% Note, best solution changes with every run
P2_1 =[U*W*V.' U(:,3)];
P2_2 =[U*W*V.' -U(:,3)];
P2_3 =[U*W.'*V.' U(:,3)];
P2_4 =[U*W.'*V.' -U(:,3)];

% Normalize image points with K^-1
x1n = K\x1h;
x2n = K\x2h;

% Triangulation using DLT
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
    xproj = P2{i}*X{i};
    if length(find(xproj(end,:) > 0)) > maxFrontPoints
        maxFrontPoints = length(find(xproj(end,:) > 0));
        bestSolutionIndex = i;
    end
end

Xbest = X{bestSolutionIndex};
P2best = P2{bestSolutionIndex};
%% Un-normalized cameras P1 and P2 using K
P2bestUn = K*P2best;
P1Un = K*P1;
xproj1 = pflat(P1Un * Xbest);
xproj2 = pflat(P2bestUn * Xbest);

%% Plot image, image points and projected 3D points
im1 = imread("im1.jpg");
im2 = imread("im2.jpg");

figure(1)
imagesc(im1)
hold on
plot(x{1}(1,bestIdx), x{1}(2,bestIdx), 'b.', 'Markersize', 20)
plot(xproj1(1,bestIdx), xproj1(2,bestIdx), 'r*', 'Markersize', 5)
title('Image 1 re-projection')
legend('Original image inlier points', 're-projected inliers', 'Location', 'SouthEast')

figure(2)
imagesc(im2)
hold on
plot(x{2}(1,bestIdx), x{2}(2,bestIdx), 'b.', 'Markersize', 20)
plot(xproj2(1,bestIdx), xproj2(2,bestIdx), 'r*', 'Markersize', 5)
title('Image 2 re-projection')
legend('Original image inlier points', 're-projected inliers', 'Location', 'SouthEast')

%% 3D reconstruction plot
figure(3)
Xbesth = pflat(Xbest);
plot3(Xbesth(1,bestIdx), Xbesth(2,bestIdx), Xbesth(3,bestIdx), 'b.')
title('3D reconstruction of best points')

%% Histograms and RMS
P = {P1Un, P2bestUn};
U = Xbesth(:, bestIdx);
xUn = {x1h(:, bestIdx), x2h(:, bestIdx)}; % Not used. <- Wrong, should be used!
u = xUn;
[err, res] = ComputeReprojectionError(P,U,u);
RMS = sqrt(sum(res.^2)/length(res));

figure(4)
histogram(res);
title('Re-projection errors in both image 1 and 2')

%% Save for computer exercises 3 and 4
save('preloadCompEx3&4', 'P', 'U', 'u', 'K')