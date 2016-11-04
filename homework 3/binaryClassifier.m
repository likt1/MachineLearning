%% binaryClassifier(array, median)
% Calculates the binary classifier for an input array datapoint 'array'
% using the median as the center
% where the classifier is either +1 or -1
% This is y in the assignment
%%
function y = binaryClassifier(a, m)
    y = -1;
    numGreater = sum(a >= m);
    numLess = sum(a < m);
    if numGreater - numLess >= 0
        y = 1;
    end
end