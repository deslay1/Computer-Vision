%% Computer Exercises 4 and 5
im1 = imread('cube1.JPG');
im2 = imread('cube2.JPG');
load('P1.mat');
load('P2.mat');

%% 4 - SIFT
[f1 d1] = vl_sift( single(rgb2gray(im1)), 'PeakThresh', 1);
[f2 d2] = vl_sift( single(rgb2gray(im2)), 'PeakThresh', 1);

figure
imagesc(im1)
hold on
vl_plotframe(f1);


[matches ,scores] = vl_ubcmatch(d1,d2);

x1 = [f1(1,matches (1 ,:));f1(2,matches (1 ,:))];
x2 = [f2(1,matches (2 ,:));f2(2,matches (2 ,:))];

perm = randperm(size(matches ,2));
figure;
imagesc([im1 im2]);
hold on;
plot([x1(1,perm (1:10));x2(1,perm (1:10))+ size(im1 ,2)], [x1(2,perm (1:10));  x2(2,perm (1:10))] ,'-');
hold  off;

%% 5 - Triangulation
x1h = [x1; ones(1, length(x1))];
x2h = [x2; ones(1, length(x2))];
[dim, points] = size(x1h);

X = zeros(dim+1, points);

% Triangulation point by point, see lecture 5.
for point=1:points
    M = [P1 x1h(:, point) zeros(dim, 1); P2 zeros(dim, 1) x2h(:, point)];
    [U,S,V] = svd(M);
    v = V(:,end);
    X(:, point) = v(1:dim+1);
end

xproj1 = pflat(P1*X);
xproj2 = pflat(P2*X);

figure(1)
imagesc(im1)
hold on
plot(x1(1,:), x1(2,:), 'b.', 'MarkerSize',20, 'DisplayName', 'SIFT points')
plot(xproj1(1,:), xproj1(2,:), 'rx', 'MarkerSize',10, 'DisplayName', 'Triangulated points')
legend()

figure(2)
imagesc(im2)
hold on
plot(x2(1,:), x2(2,:), 'b.', 'MarkerSize',20, 'DisplayName', 'SIFT points')
plot(xproj2(1,:), xproj2(2,:), 'rx', 'MarkerSize',10, 'DisplayName', 'Triangulated points')
legend('SIFT points', 'Triangulated points')

%% With normalization
[K1 Q1] = rq(P1);
K1 = K1./K1(3,3);
[K2 Q2] = rq(P2);
K2 = K2./K2(3,3);

x1norm = K1\x1h;
x2norm = K2\x2h;
xproj1norm = pflat(K1\P1*X);
xproj2norm = pflat(K2\P2*X);

figure(3)
plot(x1norm(1,:), x1norm(2,:), 'b.', 'MarkerSize',20)
hold on
plot(xproj1norm(1,:), xproj1norm(2,:), 'rx', 'MarkerSize',10)
legend('SIFT points', 'Triangulated points')

figure(4)
plot(x2norm(1,:), x2norm(2,:), 'b.', 'MarkerSize',20)
hold on
plot(xproj2norm(1,:), xproj2norm(2,:), 'rx', 'MarkerSize',10)
legend('SIFT points', 'Triangulated points')

%% Compute errors, remove bad points and plot remaining
load('compEx3data.mat');

good_points = (sqrt(sum((x1-xproj1(1:2 , :)).^2)) < 3 & sqrt(sum((x2-xproj2(1:2 , :)).^2)) < 3);

Xgood = pflat(X(:, good_points));
Xgood = [Xgood; ones(1, length(Xgood))];
x1h = x1h(:,good_points);
x2h = x2h(:,good_points);
xproj1 = pflat(P1*Xgood);
xproj2 = pflat(P2*Xgood);

figure(5)
plot3([Xmodel(1,startind);  Xmodel(1,endind)], [Xmodel(2,startind );  Xmodel(2,endind )], [Xmodel(3,startind );  Xmodel(3,endind)],'b-');
hold on
plot3(Xgood(1,:), Xgood(2,:), Xgood(3,:), 'r.')
plotcams({P1, P2})

