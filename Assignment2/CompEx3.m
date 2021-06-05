%% Computer Exercise 3
load compEx3data.mat 

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
% Normalization (unnormalized) for OPTIONAL part
% N1 = eye(3);
% N2 = eye(3);

x1norm = N1*x1;
x2norm = N2*x2;

%% Plot normalized image points
figure(1)
subplot(1,2,1)
plot(x1norm(1,:), x1norm(2,:), '.')
title('Normalized points in image 1')
subplot(1,2,2)
plot(x2norm(1,:), x2norm(2,:), '.')
title('Normalized points in image 2')
%% Homogeneous M
Xmodel=[Xmodel; ones(1, length(Xmodel))];

%% Preparing the M matrices for SVD
cols = size(Xmodel,2);
rows = size(Xmodel,1);
dim = size(x1norm,1);
M1=[];
M2=[];
for col=1:cols
    for row=1:dim
        new = zeros(1, rows*dim + cols); % Add a new row to M
        
        % Place X vectors. "Hardcoded" indices.
        if row == 1
            new(1, 1:rows) = Xmodel(:,col).';
        elseif row == 2
            new(1, 1+4:4+rows) = Xmodel(:,col).';
        else
            new(1, 1+8:8+rows) = Xmodel(:,col).';
        end
        
        % Place image points and attach new row to M
        new(1, (dim*rows)+col) = -x1norm(row, col);
        M1 = [M1; new];
        
        new(1, (dim*rows)+col) = -x2norm(row, col);
        M2 = [M2; new];
    end
end

%% Plot original image and image points
figure(2)
h = subplot(1,2,1);
im1 = imread('cube1.JPG');
imagesc(im1)
hold on
plot(x1(1,:), x1(2,:), 'b.', 'MarkerSize',20)
set(h,'Tag','left');
title('Points in image 1')

h = subplot(1,2,2);
im2 = imread('cube2.JPG');
imagesc(im2)
hold on
plot(x2(1,:), x2(2,:), 'b.', 'MarkerSize',20)
set(h,'Tag','right');
title('Points in image 2')

%% Camera 1
[U,S,V] = svd(M1);
eigenvalues = diag(S.'*S);
% Solution is the eigenvector that result sin lowest eigenvalue in S^T * S
% Therefore it correponds to last column in V
min(eigenvalues) % == 2.270e-04
v = V(:,end);
norm(M1*v) % == min(eigenvalues) from above 
P1 = [v(1:4,1).'; v(5:8,1).'; v(9:12,1).']; % All zeros?
P1 = -1 * P1; % PX has to be positive
P1 = N1\P1;

x1new = pflat(P1*Xmodel); % New image points

h = findobj('Tag','left');
set(h,'NextPlot','add')
plot(h, x1new(1,:), x1new(2,:), 'r*', 'MarkerSize',20)

%% Camera 2
[U,S,V] = svd(M2);
eigenvalues = diag(S.'*S);
min(eigenvalues) % == 1.476e-04 
v = V(:,end);
norm(M2*v) % == 0.0121 = 1.21e-02
P2 = [v(1:4,1).'; v(5:8,1).'; v(9:12,1).'];
P2 = -1 * P2;
P2 = N2\P2;

x2new = pflat(P2*Xmodel);

h = findobj('Tag','right');
set(h,'NextPlot','add')
plot(h, x2new(1,:), x2new(2,:), 'r*', 'MarkerSize',20)

%% Model Points + camera centers + viewing directions
center1 = pflat(null(P1)); % camera 1 center
center2 = pflat(null(P2)); % camera 2 center

figure(3)
plot3(Xmodel(1,:),Xmodel(2,:),Xmodel(3,:),'r.','MarkerSize', 20)
hold on
plot3([ Xmodel(1,startind );  Xmodel(1,endind )], [Xmodel(2,startind );  Xmodel(2,endind )], [Xmodel(3,startind );  Xmodel(3,endind)],'b-');

% Viewing directions
plotcams({P1,P2})

% Camera centers
plot3(center1(1,1), center1(2,1), center1(3,1), 'g*', 'MarkerSize', 20)
plot3(center2(1,1), center2(2,1), center2(3,1), 'c*', 'MarkerSize', 20)

%% Inner parameters of Camera 1
[K Q] = rq(P1);
K = K./K(3,3)

%% OPTIONAL part
%RMS error all points
[dim, points] = size(x1norm);
x1meas = pflat(x1); % pflat to remove third coordinate
x1proj = x1new;
x2meas = pflat(x2);
x2proj = x2new;
rms1 = sqrt((1/points) * (norm(x1meas-x1proj, 'fro').^2))
rms2 = sqrt((1/points) * (norm(x2meas-x2proj, 'fro').^2))

% Rms error for a given subset of points
subset = [1 4 13 16 25 28 31];
rms1 = sqrt((1/length(subset)) * (norm(x1meas(:, subset)-x1proj(:, subset), 'fro').^2))
rms2 = sqrt((1/length(subset)) * (norm(x2meas(:, subset)-x2proj(:, subset), 'fro').^2))

close all
%% For triangulation exercise
%save('P1.mat','P1');
%save('P2.mat','P2');