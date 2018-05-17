function [confusion_matrix, error_rate] = micd_confusion_analysis( training_data, test_data )
    num_classes = 10;
    num_samples_to_clssify = size(test_data,2);    
    predictions = micd_classifier(training_data, test_data);
    error_count = 0;
    
    confusion_matrix = zeros(num_classes, num_classes);
    
    for i=1:num_samples_to_clssify
        truth = test_data(3,i);
        classified = predictions(i);
        confusion_matrix(truth, classified) = confusion_matrix(truth, classified) + 1;
        if truth ~= classified
            error_count = error_count + 1;
        end
    end
    
    error_rate = error_count/num_samples_to_clssify;
end

