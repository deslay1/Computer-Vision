%% Computer Exercise 1 - RANSAC
close all
a = imread('a.jpg');
b = imread('b.jpg');
figure(1)
montage({a, b})

%% Find matching features
% Match features between images
[fA dA] = vl_sift( single(rgb2gray(a)) );
[fB dB] = vl_sift( single(rgb2gray(b)) );

matches = vl_ubcmatch(dA,dB);

xA = fA(1:2, matches (1 ,:));
xB = fB(1:2, matches (2 ,:));


%% RANSAC and DLT to estimate homography
xAh = [xA; ones(1, length(xA))];
xBh = [xB; ones(1, length(xB))];

maxDistance = 5;
numPoints = 4;
bestH = [];
bestIdx = [];
for k=1:200
    idx = randsample(length(xAh), numPoints);
    
    xAmin = xAh(:, idx);
    xBmin = xBh(:, idx);
    M = [];
    for point=1:length(idx)
        new = [xAmin(:, point).' 0 0 0 -xBmin(1, point)*xAmin(1, point) -xBmin(1, point)*xAmin(2, point) -xBmin(1, point); ...
              0 0 0 xAmin(:, point).' -xBmin(2, point)*xAmin(1, point) -xBmin(2, point)*xAmin(2, point) -xBmin(2, point)];
        M = [M; new];
    end
    %Extract solution using SVD
    [U,S,V] = svd(M);
    h = V(:,end);
    H = reshape(h,3,3).';
    H = H./H(3,3);
    % Test solution
    xBhat = pflat(H*xAh);
    dists = zeros(1, length(xAh));
    inliers = [];
    for i=1:length(xBh)
        dists(i) = norm(xBh(:,i) - xBhat(:,i));
        if dists(i) <= maxDistance
            inliers(end+1) = i;
        end
    end
    
    if length(inliers) > length(bestIdx)
        bestH = H;
        bestIdx = inliers;
    end
end

%% Transform and plot using estimated homography
figure(2)
Htform = projective2d(bestH.');
Rout = imref2d(size(a), [-200 800] , [ -400  600]);
[Atransf] = imwarp(a, Htform , 'OutputView', Rout);
Idtform = projective2d(eye(3));
[Btransf] = imwarp(b, Idtform , 'OutputView', Rout);
AB = Btransf;
AB(Btransf < Atransf) = Atransf(Btransf < Atransf );
imagesc(Rout.XWorldLimits , Rout.YWorldLimits , AB);