clc;
clear all;
close all;

m = 200;
D = zeros(m, 3);
U = zeros(m * 0.7, 3);
T = zeros(m * 0.3, 3);

eps_mean = 0;
eps_sd = 0.2;

for i = 1:m
    eps = eps_sd.*randn(1,1) + eps_mean;
    x1 = rand() * pi;
    x2 = rand() * pi;
    y = (cos(x1 * x2) * cos(2 * x1)) + eps;
    
    D(i, :) = [x1, x2, y];
    
    if i <= m * 0.7
        U(i, :) = [x1, x2, y];
    else
        T(i, :) = [x1, x2, y];
    end
    
end

% scatter3(D(:,1), D(:,2), D(:, 3), '.');
% [X1, X2] = meshgrid(0:pi/20:pi);
% figure;
% surf(X1, X2, cos(X1 .* X2) .* cos(2 * X1));

MAEtrain = zeros(1, 10);
MAEtest = zeros(1, 10);

for K = 10:10:100
    [V, W] = MLP(U, K, 1000000, 0.1);
    MAEtrain(1, K/10) = MLPError(V, W, U);
    MAEtest(1, K/10) = MLPError(V, W, T);
end

X = MAEtrain;
Y = MAEtest;

x_axis_X = 1:length(X);
y_axis_Y = 1:length(Y);

figure;
plot(x_axis_X, X,'o-', y_axis_Y, Y, 'x-');

