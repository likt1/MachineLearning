% clean workspace
clear all; clc;

heart = dlmread('heart2.txt');
median = heart(1,:);        % Get the median : the first row of data
heart(1,:) = [];            % Remove the first row of data
hLength = length(heart);    % Calculate length of the data
colNum = length(heart(1,:));% Calculate num of columns

max_passes = 5;             % max # of times to iterate over ?’s without changing
C = 10;                     % define C, see http://stats.stackexchange.com/a/159051
tolerance = 1.0e-12;        % define tolerance, we don't know where this comes from but should be small

% Set the number of tests from the training set
teLength = 50;                  % testing length
if teLength > hLength
    teLength = 2;               % we need some training data
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

% START LEARNING
%------------------------------------------------------

% gen initial values
alpha = zeros(trLength, 1);
vals = zeros(trLength, 1);
b = 0;

correct = zeros(trLength, 1);
%while sum(correct) < trLength
num = 500;                                             % test code
while num > 0 && sum(correct) < trLength              % test code
    num = num - 1;                               % test code
    
    % calculate weight vector
    weightV = ((alpha.*cell2mat(S(:,2)))'*cell2mat(S(:,1)))';
    
    % calculate KKT
    KKTV = ((cell2mat(S(:,1))*weightV + b).*cell2mat(S(:,2)) - 1).*alpha;
    
    % pick x1
    [~, i1] = max(KKTV);
    x1 = S{i1, 1};
    
    % calculate abs(small e) vector
    EV = zeros(trLength, 1);
    for i = 1:trLength
        EV(i) = sum((cell2mat(S(:,1))*S{i,1}').*cell2mat(S(:,2)).*alpha) + b - S{i,2};
    end    
    eV = EV(i1) - EV;
    
    % pick x2
    [~, i2] = max(abs(eV));
    x2 = S{i2, 1};
    
    % calculate k
    k = kernel(x1, x1) + kernel(x2, x2) - 2*kernel(x1, x2);
    
    if k ~= 0
        % update alpha 2
        oldAlpha2 = alpha(i2);
        alpha(i2) = oldAlpha2 - (S{i2, 2}*eV(i2))/k;

        % update alpha 1
        alpha(i1) = alpha(i1) + S{i1, 2}*S{i2, 2}*(oldAlpha2 - alpha(i2));

        % simplify 
        alpha(alpha < tolerance) = 0;
    end
    
    % calculate new b
    alphaGT0 = find(alpha > 0);
    ialphaGT0 = alphaGT0(ceil(rand*length(alphaGT0)));
    b = 1/S{ialphaGT0, 2} - kernel(weightV, S{ialphaGT0, 1});
    %b = (KKTV(ialphaGT0)/alpha(ialphaGT0) + 1)/S{ialphaGT0, 2} - kernel(weightV, S{ialphaGT0, 1});
    
    % test classification
    [prediction SVMValues] = classify(S, S, alpha, b);
    
    correct = prediction == cell2mat(S(:, 2));
end

%{
references:
http://cs229.stanford.edu/materials/smo.pdf <------ USE THIS, MAKES WAY
MORE SENSE

SVM_KernelsOctober11-2016.pdf
SVM_Notes10-03-16.pdf
https://en.wikipedia.org/wiki/Sequential_minimal_optimization
%}
