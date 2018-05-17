% PART 4: Sequential Discriminants

%% Initialization
clear all;
close all;
clc;
rng(1); % use a fixed seed
load('lab2_3.mat');

a = a';
b = b';

num_original_samples_a = size(a,2);
num_original_samples_b = size(b,2);

% axis limits for plotting
mesh_step = 1;
x_min = min([a(1,:) b(1,:)]) - 20;
x_max = max([a(1,:) b(1,:)]) + 20;
y_min = min([a(2,:) b(2,:)]) - 20;
y_max = max([a(2,:) b(2,:)]) + 20;
[X_mesh, Y_mesh] = meshgrid(x_min:mesh_step:x_max, y_min:mesh_step:y_max);

%% SUBPART 1

for iteration=1:3
    [G_W, G_W0, G_n_ab, G_n_ba] = generate_desc_classifier(a, b, Inf);

    % Visualize Combined All Discriminants
    figure();
    axis([x_min, x_max, y_min, y_max]);
    hold on;


    classifier_mesh = zeros(size(X_mesh));
    for u=1:size(X_mesh,1)
        for v=1:size(X_mesh,2)
            classifier_mesh(u,v) = desc_classify(X_mesh(u,v), Y_mesh(u,v), G_W, G_W0, G_n_ab, G_n_ba);
        end
    end

    map = [
        1, 0.5, 0.5
        0.5, 0.5, 1];
    colormap(map);

    contourf(X_mesh, Y_mesh, classifier_mesh);

    class_a_sample_plot = plot(a(1,:), a(2,:), 'bo', 'linewidth', 2);
    class_b_sample_plot = plot(b(1,:), b(2,:), 'ro', 'linewidth', 2);

    xlabel('x');
    ylabel('y');

    % test_x = linspace(x_min, x_max, 1000);
    % for i=1:j
    %     test_y = (G_W(1,i).*test_x + G_W0(i)) / (-1*G_W(2,i));  
    %     plot(test_x, test_y, 'k', 'linewidth', 1);
    % end

    legend([class_a_sample_plot, class_b_sample_plot], {'Class A Samples', 'Class B Samples'});
end


%% SUBPART 3
error_rates = zeros(5,20);
for J=1:5
    for iteration = 1:20
        [G_W, G_W0, G_n_ab, G_n_ba] = generate_desc_classifier(a, b, J);
        current_errors = 0;
        for i=1:num_original_samples_a
            class = desc_classify(a(1,i), a(2,i), G_W, G_W0, G_n_ab, G_n_ba);
            if (class == -1)
                current_errors = current_errors + 1;
            end
        end
        for i=1:num_original_samples_b
            class = desc_classify(b(1,i), b(2,i), G_W, G_W0, G_n_ab, G_n_ba);
            if (class == 1)
                current_errors = current_errors + 1;
            end
        end
        error_rates(J, iteration) = current_errors;
    end
end

error_rates = error_rates/(num_original_samples_a + num_original_samples_b);
error_average = zeros(1,5);
error_min = zeros(1,5);
error_max = zeros(1,5);
error_std_dev = zeros(1,5);
for J=1:5
    error_average(J) = mean(error_rates(J,:));
    error_min(J) = min(error_rates(J,:));
    error_max(J) = max(error_rates(J,:));
    error_std_dev(J) = std(error_rates(J,:));
end

figure();
Js = 1:5;

subplot(4,1,1);
plot(Js, error_average, 'bx-');
title('Average Error');
xlabel('J');

subplot(4,1,2);
plot(Js, error_min, 'bx-');
title('Minimum Error');
xlabel('J');

subplot(4,1,3);
plot(Js, error_max, 'bx-');
title('Maximum Error');
xlabel('J');

subplot(4,1,4);
plot(Js, error_std_dev, 'bx-');
title('Std Deviation in Error');
xlabel('J');
