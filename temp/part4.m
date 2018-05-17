graphics_toolkit('gnuplot')
load('feat.mat');
figure(1);
imshow(multim/255.0);

num_classes = 10;
num_samples_per_class = 16;

means = zeros(2,num_classes);
variances = zeros(2,2,num_classes);
variances_inv = zeros(2,2,num_classes);
for i=1:num_classes
    sample_range_start = (i-1)*num_samples_per_class + 1;
    sample_range_end = sample_range_start + num_samples_per_class - 1;
    means(:,i) = mean(f8(1:2, sample_range_start:sample_range_end), 2);
    variances(:,:,i) = cov(f8(1:2, sample_range_start:sample_range_end)');
    variances_inv(:,:,i) = inv(variances(:,:,i));      
end

test_data = multf8;
cimage = zeros(size(test_data, 1), size(test_data, 2));
height = size(test_data, 1);
width = size(test_data, 2);
prediction_metrics = zeros(height, width, num_classes);

for i=1:height
    for j=1:width
        a1 = test_data(i,j,1);
        a2 = test_data(i,j,2);
        feature_to_classify = [a1; a2];
        minval = -1;
        class = 1;
        for k=1:num_classes
            means(:,k);
            diff = feature_to_classify - means(:,k);
            a = diff'*variances_inv(:,:,k)*diff;
            if minval < 0 || a<minval
                minval = a;
                class = k;
            end
        end
        class;
        minval;
        cimage(i,j) = class;
    end
end
dim = size(multim);
figure(2);
imagesc(cimage);
pause();
