% clean workspace
clear all; clc;

heart = dlmread('heart.txt');
median = heart(1,:);        % Get the median : the first row of data
heart(1,:) = [];            % Remove the first row of data
hLength = length(heart);    % Calculate length of the data
colNum = length(heart(1,:));% Calculate num of columns

C = 100;                     % define C, see http://stats.stackexchange.com/a/159051
tol = 1.0e-12;              % define tolerance, we don't know where this comes from but should be small

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
alpha = ones(trLength, 1);
b = 0;

convergence = 0;
%while ~convergence
num = 1000;                           % test code
while num > 0                         % test code
    num = num - 1;                               % test code
    convergence = 1;
    
    % calculate EV for each datapoint
    SVMOutput = zeros(trLength, 1);
    for i = 1:trLength
        SVMOutput(i) = sum((cell2mat(S(:,1))*S{i,1}').*cell2mat(S(:,2)).*alpha) + b;
    end
    
    EV = SVMOutput - cell2mat(S(:,2));
    
    %{
    simplified alg
    for i = 1:trLength
        if (S{i,2}*EV(i) < -tol && alpha(i) < C) || (S{i,2}*EV(i) > tol && alpha(i) > 0)
            j = ceil(rand*trLength);
            while j == i
                j = ceil(rand*trLength);
            end
            oldAlpha1 = alpha(i);
            oldAlpha2 = alpha(j);
            
            if S{i,2} ~= S{j,2}
                L = max(0, alpha(j) - alpha(i));
                H = min(C, C + alpha(j) - alpha(i));
            else
                L = max(0, alpha(i) + alpha(j) - C);
                H = min(C, alpha(i) + alpha(j));
            end
            
            if 1
            end
        end
    end
    %}
    
    % calculate weight vector
    weightV = ((alpha.*cell2mat(S(:,2)))'*cell2mat(S(:,1)))';
    
    % calculate KKT
    KKTV = ((cell2mat(S(:,1))*weightV + b).*cell2mat(S(:,2)) - 1).*alpha;
    
    % pick x1
    [~, i1] = max(KKTV);
    x1 = S{i1, 1};
    
    eV = EV(i1) - EV;
    
    % pick x2
    [~, i2] = max(abs(eV));
    x2 = S{i2, 1};
    
    % what if we just picked to random numbers not equal to each other
    i1 = ceil(rand*trLength);
    i2 = ceil(rand*trLength);
    while i2 == i1
        i2 = ceil(rand*trLength);
    end
    
    % calculate k
    k = kernel(x1, x1) + kernel(x2, x2) - 2*kernel(x1, x2);
    
    if k ~= 0
        % calculate L and H
        oldAlpha1 = alpha(i1);
        oldAlpha2 = alpha(i2);

        if S{i1,2} ~= S{i2,2}
            L = max(0, alpha(i2) - alpha(i1));
            H = min(C, C + alpha(i2) - alpha(i1));
        else
            L = max(0, alpha(i1) + alpha(i2) - C);
            H = min(C, alpha(i1) + alpha(i2));
        end
        
        % update alpha 2
        alpha(i2) = oldAlpha2 - (S{i2, 2}*eV(i2))/k;
        
        if alpha(i2) > H
            alpha(i2) = H;
        elseif alpha(i2) < L
            alpha(i2) = L;
        end

        % update alpha 1
        alpha(i1) = alpha(i1) + S{i1, 2}*S{i2, 2}*(oldAlpha2 - alpha(i2));

        % simplify 
        alpha(alpha < tol) = 0;
    end
    
    % calculate new b
    b1 = b - EV(i1) - S{i1,2}*(alpha(i1) - oldAlpha1)*kernel(x1, x1) - S{i2,2}*(alpha(i2) - oldAlpha2)*kernel(x1, x2);
    b2 = b - EV(i2) - S{i1,2}*(alpha(i1) - oldAlpha1)*kernel(x1, x2) - S{i2,2}*(alpha(i2) - oldAlpha2)*kernel(x2, x2);
    
    if alpha(i1) > 0 && alpha(i1) < C
        b = b1;
    elseif alpha(i2) > 0 && alpha(i2) < C
        b = b2;
    else
        b = (b1 + b2)/2;
    end
    
    % test classification
    [prediction SVMValues] = classify(S, S, alpha, b);
    
    %correct = prediction == cell2mat(S(:, 2));
end

%{
references:
http://cs229.stanford.edu/materials/smo.pdf <------ USE THIS, MAKES WAY
MORE SENSE

SVM_KernelsOctober11-2016.pdf
SVM_Notes10-03-16.pdf
https://en.wikipedia.org/wiki/Sequential_minimal_optimization
%}
