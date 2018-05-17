%% initialization
clear all;
close all;
clc;

% set fixed rng seed
rng(1);

% num of samples
num_samples_A = 200;
num_samples_B = 200;
num_samples_C = 100;
num_samples_D = 200;
num_samples_E = 150;

prior_A = num_samples_A/(num_samples_A + num_samples_B);
prior_B = num_samples_B/(num_samples_A + num_samples_B);
prior_C = num_samples_C/(num_samples_C + num_samples_D + num_samples_E);
prior_D = num_samples_D/(num_samples_C + num_samples_D + num_samples_E);
prior_E = num_samples_E/(num_samples_C + num_samples_D + num_samples_E);


% sample means
mu_A = [5 10]';
mu_B = [10 15]';
mu_C = [5 10]';
mu_D = [15 10]';
mu_E = [10 5]';

% sample covariance matrices
sigma_A = [8 0; 0 4];
sigma_B = [8 0; 0 4];
sigma_C = [8 4; 4 40];
sigma_D = [8 0; 0 8];
sigma_E = [10 -5; -5 20];

% eigen values and vectors
[eig_vecs_A, eig_vals_A] = eig(sigma_A);
[eig_vecs_B, eig_vals_B] = eig(sigma_B);
[eig_vecs_C, eig_vals_C] = eig(sigma_C);
[eig_vecs_D, eig_vals_D] = eig(sigma_D);
[eig_vecs_E, eig_vals_E] = eig(sigma_E);


% generate distributions
A_dist = mvnrnd(mu_A, sigma_A, num_samples_A);
B_dist = mvnrnd(mu_B, sigma_B, num_samples_B);
C_dist = mvnrnd(mu_C, sigma_C, num_samples_C);
D_dist = mvnrnd(mu_D, sigma_D, num_samples_D);
E_dist = mvnrnd(mu_E, sigma_E, num_samples_E);


% generate meshgrids for plotting contours
mesh_step_size = 0.1;
c1_x = min([A_dist(:,1);B_dist(:,1)])-1:mesh_step_size:max([A_dist(:,1);B_dist(:,1)])+1;
c1_y = min([A_dist(:,2);B_dist(:,2)])-1:mesh_step_size:max([A_dist(:,2);B_dist(:,2)])+1;
[mesh1_X, mesh1_Y] = meshgrid(c1_x, c1_y);

c2_x = min([C_dist(:,1);D_dist(:,1);E_dist(:,1)])-1:mesh_step_size:max([C_dist(:,1);D_dist(:,1);E_dist(:,1)])+1;
c2_y = min([C_dist(:,2);D_dist(:,2);E_dist(:,2)])-1:mesh_step_size:max([C_dist(:,2);D_dist(:,2);E_dist(:,2)])+1;
[mesh2_X, mesh2_Y] = meshgrid(c2_x, c2_y);

%% Part 2

% visualization
figure(1);
hold on;
plot(A_dist(:,1), A_dist(:,2), 'bx');
plot(B_dist(:,1), B_dist(:,2), 'rx');
plot_unit_variance_contour(mu_A, sigma_A, 'b');
plot_unit_variance_contour(mu_B, sigma_B, 'r');
legend('Class A', 'Class B');

figure(2);
hold on;
plot(C_dist(:,1), C_dist(:,2), 'bx');
plot(D_dist(:,1), D_dist(:,2), 'rx');
plot(E_dist(:,1), E_dist(:,2), 'kx');
plot_unit_variance_contour(mu_C, sigma_C, 'b');
plot_unit_variance_contour(mu_D, sigma_D, 'r');
plot_unit_variance_contour(mu_E, sigma_E, 'k');
legend('Class C', 'Class D', 'Class E');


%% Part 3

MED_COLOR = [0, 210, 211]/255;
GED_COLOR = [95, 39, 205]/255;
MAP_COLOR = [255, 159, 67]/255;
NN1_COLOR = [200, 50, 0]/255;
NN5_COLOR = [50, 100, 150]/255;

% MED
figure(3);
hold on;
plot(A_dist(:,1), A_dist(:,2), 'bx');
plot(B_dist(:,1), B_dist(:,2), 'rx');

MED1 = generate_MED_decision_boundary(mu_A, mu_B, mesh1_X, mesh1_Y);
GED1 = generate_GED_decision_boundary(mu_A, mu_B, sigma_A, sigma_B, mesh1_X, mesh1_Y);
MAP1 = generate_MAP_decision_boundary(mu_A, mu_B, sigma_A, sigma_B, 0.7, 0.3, mesh1_X, mesh1_Y);

contour(mesh1_X ,mesh1_Y, MED1, [0, 0], 'Color', MED_COLOR, 'LineWidth', 2);
contour(mesh1_X ,mesh1_Y, GED1, [0, 0], 'Color', GED_COLOR, 'LineWidth', 2);
contour(mesh1_X ,mesh1_Y, MAP1, [0, 0], 'Color', MAP_COLOR, 'LineWidth', 2);

plot_unit_variance_contour(mu_A, sigma_A, 'b');
plot_unit_variance_contour(mu_B, sigma_B, 'r');

legend('Class A', 'Class B', 'MED Boundary', 'GED Bondary', 'MAP Boundary');


figure(4);
hold on;
plot(C_dist(:,1), C_dist(:,2), 'bx');
plot(D_dist(:,1), D_dist(:,2), 'rx');
plot(E_dist(:,1), E_dist(:,2), 'kx');

MED2 = combine_regions( ...
    generate_MED_decision_boundary(mu_C, mu_D, mesh2_X, mesh2_Y), ...
    generate_MED_decision_boundary(mu_D, mu_E, mesh2_X, mesh2_Y), ...
    generate_MED_decision_boundary(mu_E, mu_C, mesh2_X, mesh2_Y) ...
);

GED2 = combine_regions( ...
    generate_GED_decision_boundary(mu_C, mu_D, sigma_C, sigma_D, mesh2_X, mesh2_Y), ...
    generate_GED_decision_boundary(mu_D, mu_E, sigma_D, sigma_E, mesh2_X, mesh2_Y), ...
    generate_GED_decision_boundary(mu_E, mu_C, sigma_E, sigma_C, mesh2_X, mesh2_Y) ...
);

MAP2 = combine_regions( ...
    generate_MAP_decision_boundary(mu_C, mu_D, sigma_C, sigma_D, prior_C, prior_D, mesh2_X, mesh2_Y), ...
    generate_MAP_decision_boundary(mu_D, mu_E, sigma_D, sigma_E, prior_D, prior_E, mesh2_X, mesh2_Y), ...
    generate_MAP_decision_boundary(mu_E, mu_C, sigma_E, sigma_C, prior_E, prior_C, mesh2_X, mesh2_Y) ...
);

contour(mesh2_X ,mesh2_Y, MED2, 'Color', MED_COLOR, 'LineWidth', 2);
contour(mesh2_X ,mesh2_Y, GED2, 'Color', GED_COLOR, 'LineWidth', 2);
contour(mesh2_X ,mesh2_Y, MAP2, 'Color', MAP_COLOR, 'LineWidth', 2);

plot_unit_variance_contour(mu_C, sigma_C, 'b');
plot_unit_variance_contour(mu_D, sigma_D, 'r');
plot_unit_variance_contour(mu_E, sigma_E, 'k');

legend('Class C', 'Class D', 'Class E', 'MED Boundaries', 'GED Bondaries', 'MAP Boundaries');

% NN

figure(5);
hold on;
plot(A_dist(:,1), A_dist(:,2), 'bx');
plot(B_dist(:,1), B_dist(:,2), 'rx');

NN1_1 = generate_kNN_decision_boundary2(1, A_dist, B_dist, mesh1_X, mesh1_Y);

contour(mesh1_X ,mesh1_Y, NN1_1, [0, 0], 'Color', NN1_COLOR, 'LineWidth', 2);

plot_unit_variance_contour(mu_A, sigma_A, 'b');
plot_unit_variance_contour(mu_B, sigma_B, 'r');

legend('Class A', 'Class B', 'NN1 Boundary');

figure(6);
hold on;
plot(C_dist(:,1), C_dist(:,2), 'bx');
plot(D_dist(:,1), D_dist(:,2), 'rx');
plot(E_dist(:,1), E_dist(:,2), 'kx');

NN1_2 = combine_regions( ...
    generate_kNN_decision_boundary2(1, C_dist, D_dist, mesh2_X, mesh2_Y), ...
    generate_kNN_decision_boundary2(1, D_dist, E_dist, mesh2_X, mesh2_Y), ...
    generate_kNN_decision_boundary2(1, E_dist, C_dist, mesh2_X, mesh2_Y) ...
);

contour(mesh2_X ,mesh2_Y, NN1_2, 'Color', NN1_COLOR, 'LineWidth', 1);

plot_unit_variance_contour(mu_C, sigma_C, 'b');
plot_unit_variance_contour(mu_D, sigma_D, 'r');
plot_unit_variance_contour(mu_E, sigma_E, 'k');

legend('Class C', 'Class D', 'Class E', 'NN1 Boundary');

% kNN

figure(7);
hold on;
plot(A_dist(:,1), A_dist(:,2), 'bx');
plot(B_dist(:,1), B_dist(:,2), 'rx');

NN5_1 = generate_kNN_decision_boundary2(5, A_dist, B_dist, mesh1_X, mesh1_Y);

contour(mesh1_X ,mesh1_Y, NN5_1, [0, 0], 'Color', NN5_COLOR, 'LineWidth', 2);

plot_unit_variance_contour(mu_A, sigma_A, 'b');
plot_unit_variance_contour(mu_B, sigma_B, 'r');

legend('Class A', 'Class B', 'NN5 Boundary');

figure(8);
hold on;
plot(C_dist(:,1), C_dist(:,2), 'bx');
plot(D_dist(:,1), D_dist(:,2), 'rx');
plot(E_dist(:,1), E_dist(:,2), 'kx');

NN5_2 = combine_regions( ...
    generate_kNN_decision_boundary2(5, C_dist, D_dist, mesh2_X, mesh2_Y), ...
    generate_kNN_decision_boundary2(5, D_dist, E_dist, mesh2_X, mesh2_Y), ...
    generate_kNN_decision_boundary2(5, E_dist, C_dist, mesh2_X, mesh2_Y) ...
);

contour(mesh2_X ,mesh2_Y, NN5_2, 'Color', NN5_COLOR, 'LineWidth', 1);

plot_unit_variance_contour(mu_C, sigma_C, 'b');
plot_unit_variance_contour(mu_D, sigma_D, 'r');
plot_unit_variance_contour(mu_E, sigma_E, 'k');

legend('Class C', 'Class D', 'Class E', 'NN5 Boundary');