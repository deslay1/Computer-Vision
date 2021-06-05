%% Computer Exercise 1
load compEx1data.mat

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

%% Eight point algorithm
[dim, rows] = size(x1norm);

M=[];
for row=1:rows
    xx = x2norm(:, row)*x1norm(:, row)';
    M(row,:) = xx(:)';
end

% SVD
[U,S,V] = svd(M);
Fcol = V(:,end);

eigenvalues = diag(S.'*S);
min(eigenvalues)
norm(M*Fcol)

Fn = reshape(Fcol, [3  3]);
det(Fn) % == 9.31e-05 

% Verification
% x2norm(:,1).' * Fn * x1norm(:,1) % == 0.1309 
% x2norm(:,2).' * Fn * x1norm(:,2) % == 0.4627
% x2norm(:,3).' * Fn * x1norm(:,3) % == 0.2370

% Verification by plot
plot(diag(x2norm.' * Fn * x1norm));

%% Minimize det(Fn)
[U,S,V] = svd(Fn);
S(end,end) = 0;
Fnmin = U*S*V.';
plot(diag(x2norm.' * Fnmin * x1norm));
det(Fnmin) % == 1.13e-18

%% Un-normalized F
F = N2.' * Fnmin * N1;
F = F./F(end,end);

% epipolar lines
l = F*x1;
l = l./sqrt(repmat(l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));

%% Plot 20 random points in image 2 with epipolar lines
ind = randperm(length(x2),20);
points = x2(:, ind);
lines = l(:, ind);
im2 = imread('kronan2.JPG');
imagesc(im2)
hold on
plot(points(1, :), points(2, :),'b.', 'Markersize', 20)
rital(lines,'r-')

%% Calculate mean distance and plot histogram
dists = abs(sum(l.*x2));
histogram(dists ,100);
mu = mean(dists);

%% Save F for Computer Exercise 2 and 3
save('F.mat', 'F');

