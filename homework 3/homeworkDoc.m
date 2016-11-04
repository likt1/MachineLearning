% test doc

% clean workspace
clear all; clc;

heart = dlmread('heart.txt');
median = heart(1,:);        % Get the median : the first row of data
heart(1,:) = [];            % Remove the first row of data
hLength = length(heart);    % Calculate length of the data
colNum = length(heart(1,:));% Calculate num of columns
b = 0;                      %

% first generate binary classifier from data
S = cell(hLength, 2);
for n = 1:hLength
    S(n, 1) = {heart(n, :)};
    S(n, 2) = {binaryClassifier(heart(n, :), median)}; % TODO
end

% then init alpha randomly (Really dumb implementation)
% with the constraint that the dot product of the binary classifiers y with
% alpha = 0
% from the assignment sum( i = 1:length , yi*ai) = 0
alpha = ones(hLength, 1);
alphaSum = sum(cell2mat(S(:,2)));
%alphaSum = dot(alpha, cell2mat(S(:,2)));
n = abs(alphaSum);
while n ~= 0
    randIdx = ceil(rand * hLength);
    idxClass = S{randIdx, 2};
    if (alphaSum > 0 && idxClass < 0) || (alphaSum < 0 && idxClass > 0)
        alpha(randIdx) = alpha(randIdx) + 1;
        n = n - 1;
    % comment this bottom section out to remove negative alpha numbers
    elseif (alphaSum > 0 && idxClass > 0) || (alphaSum < 0 && idxClass > 0)
        if alpha(randIdx) == 1 && n > 1
            alpha(randIdx) = alpha(randIdx) - 2;
            n = n - 2;
        else
            alpha(randIdx) = alpha(randIdx) - 1;
            n = n - 1;
        end
    % end block
    end
end
% check
dot(alpha, cell2mat(S(:,2)))

% calculate weight vector TODO
weightV = zeros(colNum, 1);
for n = 1:colNum
    for idx = 1:hLength
        weightV(n) = weightV(n) + alpha(idx)*S{idx,2}*S{idx,1}(n);
    end
end

w = sum(weightV)

%calculate KKT conditions TODO
pickX1X2;

% This was as far as I got

%{
directly from assignment
4. Pick x1, x2:
(a) Let i1 = argmaxi=1,...,lKKT(i).
(b) Pick x1 = xi1 .
(c) Calculate e(i) = E(1) ? E(i) = Pl
j=1 ?jyj(Kj1 ? Kji) + yi ? y1Kij
(d) Let i2 = argmaxi|e(i)|.
(e) Pick x2 = xi2 .
(f) Calculate k = K11 + K22 ? 2 ? K12
5. Update ?2:
?new
2 = ?old
2 +
y2E(2)
k
6. Update ?1:
?new
1 = ?old
1 + y1y2(?old
2 ? ?new
2 )
7. For i = 1, . . . , l, if ?i < ?, ?i ? 0;
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
