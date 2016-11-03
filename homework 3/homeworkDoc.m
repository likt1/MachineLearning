% test doc

% clean workspace
clear all; clc;

heart = dlmread('heart.txt');
median = heart(1,:);        % Get the median : the first row of data
heart(1,:) = [];            % Remove the first row of data
hLength = length(heart);    % Calculate length of the data

% first generate binary classifier from data
S = cell(hLength, 2);
for n = 1:hLength
    S(n, 1) = {heart(n, :)};
    S(n, 2) = {binaryClassifier(heart(n, :))}; % TODO
end

% then init alpha randomly TODO
% with the constraint that the dot product of the binary classifiers y with
% alpha = 0
% from the assignment sum( i = 1:length , yi*ai) = 0
alpha = zeros(hLength, 1);

% calculate weight vector TODO
w = 0;
for n = i:hLength
%     w = w + alpha(n)*S(n, 2)*S(n, 1);   % this makes no sense because xi is an
                                        % array?
end

%calculate KKT conditions TODO
% IDK what that equation is anymore

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
