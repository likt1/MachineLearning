% test doc

% clean workspace
clear all; clc;

heart = dlmread('heart.txt');
median = heart(1,:);        % Get the median : the first row of data
heart(1,:) = [];            % Remove the first row of data
hLength = length(heart);    % Calculate length of the data
colNum = length(heart(1,:));% Calculate num of columns
b = 0;                      % bias is initially 0
epsilon = 1.0e-12;          % define epsilon, we don't know where this comes from

% Set the number of tests from the training set
teLength = 50;                  % testing length
if teLength > hLength
    teLength = 50;
end
trLength = hLength - teLength;  % training length

% generate training and testing cell arrays of datapoints and binary classifiers
S = cell(trLength, 2);
Stest = cell(teLength, 2);
for n = 1:hLength
    if n <= trLength
        S(n, 1) = {heart(n, :)};
        S(n, 2) = {binaryClassifier(heart(n, :), median)};
    else
        Stest(n - trLength, 1) = {heart(n, :)};
        Stest(n - trLength, 2) = {binaryClassifier(heart(n, :), median)};
    end
end

% gen initial alpha and vals array
%alpha = zeros(trLength, 1);
alpha = ones(trLength, 1); % test alpha
vals = zeros(trLength, 1);

correct = zeros(trLength, 1);
%while sum(correct) < trLength
num = 1;                    % test code so that this only runs once
while num == 1              % test code so that this only runs once
    num = num - 1;          % test code so that this only runs once
    
    % calculate weight vector
    weightV = (alpha.*cell2mat(S(:,2)))'*cell2mat(S(:,1));
    weightV = weightV';
    
    % calculate KKT    
    KKTV = ((cell2mat(S(:,1))*weightV + b).*cell2mat(S(:,2)) - 1).*alpha;
    
    % pick x1
    [~, i1] = max(KKTV);
    x1 = S{i1, 1};
    
    %{
    % calculate abs(small e) vector WE DONT USE THIS
    eV = zeros(trLength, 1);
    for i = 1:trLength
        eV(i) = abs(E(1, S, alpha, b) - E(i, S, alpha, b));
    end
    
    % pick x1
    [~, i2] = max(eV);
    x2 = S{i2, 1};
    %}
    
    % calculate abs(small e) vector
    %eV = zeros(trLength, 1);
    EV = zeros(trLength, 1);
    for i = 1:trLength
        %eV(i) = smallE(i, S, alpha, i1);
        %eV(i) = E(i1, S, alpha, b) - E(i, S, alpha, b);
        EV(i) = sum((cell2mat(S(:,1))*S{i,1}').*cell2mat(S(:,2)).*alpha) + b - S{i,2};
    end
    
    eV = EV(i1) - EV;
    
    % pick x2
    [~, i2] = max(abs(eV));
    x2 = S{i2, 1};
    
    % calculate k
    k = kernel(x1, x1) + kernel(x2, x2) - 2*kernel(x1, x2);
    
    % update alpha 2
    oldAlpha2 = alpha(i2);
    alpha(i2) = oldAlpha2 + (S{i2, 2}*eV(i2))/k;
    
    % update alpha 1
    alpha(i1) = alpha(i1) + S{i1, 2}*S{i2, 2}*(oldAlpha2 - alpha(i2));
    
    % simplify 
    alpha(alpha < epsilon) = 0;
    
    % calculate new b
    alphaGT0 = find(alpha > 0);
    ialphaGT0 = alphaGT0(ceil(rand*length(alphaGT0)));
    b = 1/S{ialphaGT0, 2} - dot(weightV, S{ialphaGT0, 1});
    
    % test classification
    SVMValues = zeros(trLength, 1);
    prediction = zeros(trLength, 1);
    for i = 1:trLength
        SVMValues(i) = E(i, S, alpha, b);
    end
    
    prediction(SVMValues < 0) = -1;
    prediction(SVMValues >= 0) = 1;
    
    correct = prediction == cell2mat(S(:,2));
end

%{
directly from assignment
8. Select ?i > 0, calculate b (from KKT conditions)
9. Test for classification;
10. Repeat from Step 2. until classified.
%}

%{
references:
SVM_KernelsOctober11-2016.pdf
SVM_Notes10-03-16.pdf
https://en.wikipedia.org/wiki/Sequential_minimal_optimization
%}
