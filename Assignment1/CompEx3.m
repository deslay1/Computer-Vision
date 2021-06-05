%% Computer Exercise 3
grid = load('CompEx3.mat');
sps = grid.startpoints;
eps = grid.endpoints;

% Transformation matrices
H1 = [sqrt(3) -1 1; 1 sqrt(3) 1; 0 0 2];
H2 = [1 -1 1; 1 1 0; 0 0 1];
H3 = [1 1 0; 0 2 0; 0 0 1];
H4 = [sqrt(3) -1 1; 1 sqrt(3) 1; 1/4 1/2 2];

% plot([sps(1,:);eps(1,:)] ,[sps(2,:);eps(2,:)], '-b')

% Convert to homogeneous coordinates for transformation
sps = [sps; ones(1,length(sps))];
eps = [eps; ones(1,length(eps))];

figure(1)
axis equal
subplot(2,2,1)
sps1 = pflat(H1*sps);
eps1 = pflat(H1*eps);
plot([sps1(1,:);eps1(1,:)] ,[sps1(2,:);eps1(2,:)], '-b')
title('Similarity transformation')

% figure(2)
% axis equal
subplot(2,2,2)
sps2 = pflat(H2*sps);
eps2 = pflat(H2*eps);
plot([sps2(1,:);eps2(1,:)] ,[sps2(2,:);eps2(2,:)], '-b')
title('Euclidean transformation')

% figure(3)
% axis equal
subplot(2,2,3)
sps3 = pflat(H3*sps);
eps3 = pflat(H3*eps);
plot([sps3(1,:);eps3(1,:)] ,[sps3(2,:);eps3(2,:)], '-b')
title('Affine transformation')


% figure(4)
% axis equal
subplot(2,2,4)
sps4 = pflat(H4*sps);
eps4 = pflat(H4*eps);
plot([sps4(1,:);eps4(1,:)] ,[sps4(2,:);eps4(2,:)], '-b')
title('Projective transformation')
