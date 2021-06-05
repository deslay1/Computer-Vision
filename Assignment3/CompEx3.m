%% Computer Exercise 3
load compEx3data
load compEx1data
%%
% Normalize image points with K^-1
x1n = K\x{1};
x2n = K\x{2};

%% Eight point algorithm
[dim, rows] = size(x1n);

M=[];
for row=1:rows
    xx = x2n(:, row)*x1n(:, row)';
    M(row,:) = xx(:)';
end

% SVD
[U,S,V] = svd(M);
v = V(:,end);

eigenvalues = diag(S.'*S);
min(eigenvalues)
norm(M*v)

% Essential matrix
Ehat = reshape(v, [3 3]);
[U,S,V] = svd(Ehat);
% Solution depended on determinant
if det(U*V')>0
    E = U*diag ([1 1 0])*V';
else
    V = -V;E = U*diag ([1 1 0])*V';
end

%% Check epipolar constraints
figure(1)
plot(diag(x2n'*E*x1n))

%% Fundamental matrix for un-normalized points
% E = K' * F * K. F has 8 degrees of freedom while E has 5 due to the
% incorporating the intrinsic parameters of the camera.
E = E./E(3,3);
F = K.'\E/K;

%% Epipolar lines, as in Computer Exercise 1
l = F*x{1};
l = l./sqrt(repmat(l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));

%% Plot 20 random points in image 2 with epipolar lines
ind = randperm(length(x{2}),20);
points = x{2}(:, ind);
lines = l(:, ind);
im2 = imread('kronan2.JPG');

figure(2)
imagesc(im2)
hold on
plot(points(1, :), points(2, :),'b.', 'Markersize', 20)
rital(lines,'r-')

%% Calculate mean distance and plot histogram
dists = abs(sum(l.*x{2}));
figure(3)
histogram(dists ,100);
mu = mean(dists);

%% Save E for Computer Exercise 4
save('E.mat', 'E');