%% classify
%%
function [classification, SVMvalues] = classify(dataset, test, alpha, b)
    classifier = cell2mat(dataset(:, 2));
    data = cell2mat(dataset(:, 1));
    testData = cell2mat(test(:, 1));
    numData = length(testData);
    
    SVMvalues = zeros(numData, 1);
    classification = zeros(numData, 1);
    
    for i = 1:numData
        SVMvalues(i) = sum((data*testData(i,:)').*classifier.*alpha) + b;
    end
    
    classification(SVMvalues >= 0) = 1;
    classification(SVMvalues < 0) = -1;
end