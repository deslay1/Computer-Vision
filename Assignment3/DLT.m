function [X, xproj1, xproj2] = DLT(P1, P2, x1h, x2h)
[dim, points] = size(x1h);

X = zeros(dim+1, points);

% Triangulation point by point, see lecture 5.
for point=1:points
    M = [P1 x1h(:, point) zeros(dim, 1); P2 zeros(dim, 1) x2h(:, point)];
    [U,S,V] = svd(M);
    v = V(:,end);
    X(:, point) = v(1:dim+1);
end

xproj1 = [pflat(P1*X); ones(1, size(x1h,2))];
xproj2 = [pflat(P2*X); ones(1, size(x1h,2))];
end

