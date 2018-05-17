% Lab 2 Part 3

%% Set Up

clear all;
close all;
clc;
rng(1); % use a fixed seed
load('lab2_2.mat');

% axis limits for plotting
mesh_step = 1;
% al(:,1)
a = al';
b = bl';
c = cl';

num_original_samples_a = size(a,2);
num_original_samples_b = size(b,2);
num_original_samples_c = size(c,2);

x_min = min([a(1,:) b(1,:) c(1,:)]) - 20;
x_max = max([a(1,:) b(1,:) c(1,:)]) + 20;
y_min = min([a(2,:) b(2,:) c(2,:)]) - 20;
y_max = max([a(2,:) b(2,:) c(2,:)]) + 20;
[X_mesh, Y_mesh] = meshgrid(x_min:mesh_step:x_max, y_min:mesh_step:y_max);

%% Parametric Estimation

figure();
axis([x_min, x_max, y_min, y_max]);
hold on;

% create mesh to map to different regions
classifier_mesh = zeros(size(X_mesh));

% calculate unknown parameters using sample
% assume gaussian distribution
[mu_A, cov_A] = calc_parameters(a);
[mu_B, cov_B] = calc_parameters(b);
[mu_C, cov_C] = calc_parameters(c);

% iterate through classifier_mesh
for u=1:size(X_mesh,1)
    for v=1:size(X_mesh,2)
        
        % current point
        pt = [X_mesh(u,v); Y_mesh(u,v)];
        
        % calculate probabilities
        prob_A = (pt-mu_A)'*inv(cov_A)*(pt-mu_A);
        prob_B = (pt-mu_B)'*inv(cov_B)*(pt-mu_B);
        prob_C = (pt-mu_C)'*inv(cov_C)*(pt-mu_C);
        
        % determine appropriate value for classifier_mesh
        if prob_A < prob_B && prob_A < prob_C
            classifier_mesh(u,v) = 1;
        elseif prob_B < prob_A && prob_B < prob_C
            classifier_mesh(u,v) = 2;
        elseif prob_C < prob_A && prob_C < prob_B
            classifier_mesh(u,v) = 3;
        else
            classifier_mesh(u,v) = 0;
        end
    end
end

% create colormap
map = [
    0.5, 1, 0.5
    0.5, 0.5, 1
    1, 0.5, 0.5];
colormap(map);

% draw regions
contourf(X_mesh, Y_mesh, classifier_mesh);

% plot samples
class_A = plot(a(1,:),a(2,:), 'ro', 'linewidth', 2);
class_B = plot(b(1,:),b(2,:), 'bo', 'linewidth', 2);
class_C = plot(c(1,:),c(2,:), 'go', 'linewidth', 2);

%% Non-Parametric Estimation

figure();
axis([x_min, x_max, y_min, y_max]);
hold on;

% set resolution
res = [1 x_min y_min x_max y_max];

% create gaussian window
n = 234;
xwin = [-n:1:n];
ywin = [-n:1:n];
xwin = normpdf(xwin,0,20);
ywin = normpdf(ywin,0,20);
win = xwin'*ywin;

% calculate parzen probabilities for each class
[p_A,x_A,y_A] = parzen( a, res, win );
[p_B,x_B,y_B] = parzen( b, res, win );
[p_C,x_C,y_C] = parzen( c, res, win );

% iterate through classifier_mesh
for u=1:size(X_mesh,1)
    for v=1:size(X_mesh,2)
        
        % determine appropriate value for classifier_mesh
        if p_A(u,v) > p_B(u,v) && p_A(u,v) > p_C(u,v)
            classifier_mesh(u,v) = 1;
        elseif p_B(u,v) > p_A(u,v) && p_B(u,v) > p_C(u,v)
            classifier_mesh(u,v) = 2;
        elseif p_C(u,v) > p_A(u,v) && p_C(u,v) > p_B(u,v)
            classifier_mesh(u,v) = 3;
        else
            classifier_mesh(u,v) = 0;
        end
    end
end

% create colormap
map = [
    0.5, 1, 0.5
    0.5, 0.5, 1
    1, 0.5, 0.5];
colormap(map);

% draw regions
contourf(X_mesh, Y_mesh, classifier_mesh);

% plot samples
class_A = plot(a(1,:),a(2,:), 'ro', 'linewidth', 2);
class_B = plot(b(1,:),b(2,:), 'bo', 'linewidth', 2);
class_C = plot(c(1,:),c(2,:), 'go', 'linewidth', 2);