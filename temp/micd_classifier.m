function [ predicted_classes ] = micd_classifier( training_data, test_data )
    num_classes = 10;
    num_samples_per_class = 16;
    num_samples_to_clssify = size(test_data,2);
    predicted_classes = zeros(1, num_samples_to_clssify);
    
    training_means = zeros(2,num_classes);
    training_variances = zeros(2,2,num_classes);
    training_variances_inv = zeros(2,2,num_classes);
    
    for i=1:num_classes
        sample_range_start = (i-1)*num_samples_per_class + 1;
        sample_range_end = sample_range_start + num_samples_per_class - 1;
        training_means(:,i) = mean(training_data(1:2, sample_range_start:sample_range_end), 2);
        training_variances(:,:,i) = cov(training_data(1:2, sample_range_start:sample_range_end)');
        training_variances_inv(:,:,i) = inv(training_variances(:,:,i));      
    end
    
    prediction_metrics = zeros(num_classes, num_samples_to_clssify);
    for j=1:num_samples_to_clssify
        for i=1:num_classes
            feature_to_classify = test_data(1:2,j);
            prediction_metrics(i,j) = (feature_to_classify - training_means(:,i))'*training_variances_inv(:,:,i)*(feature_to_classify - training_means(:,i));
        end
    end
    
    [minval, predicted_classes] = min(prediction_metrics);
end

