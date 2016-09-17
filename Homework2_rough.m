%{
Rough Draft 
 pad to run code with.  move code out to functions when finished
%}
clear all; clc;
load fisheriris.mat;
k = 3; % number of bins

% Create iris graph
%------------------------------------
iris = meas.*10;

for x = 1:150
    if(strcmp(species(x), 'setosa'))
        iris(x, 5) = 1.0;
    elseif(strcmp(species(x), 'versicolor'))
        iris(x, 5) = 2.0;
    else
        iris(x, 5) = 3.0;
    end
end

% Total entropy
%------------------------------------

pT = [1/3, 1/3, 1/3]; % add for loop to determine prob for flower types
hT = sum(-pT.*log2(pT))

% Column 1
%------------------------------------
% bin column 1, n1 = number in each bin for column 1, c1 = centers
[n1, c1] = hist(iris(:,1), k);

% prob of each bin for column 1
p = n1/sum(n1);

% entropy of bins

% Column 2
%------------------------------------
% bin column 2, n2 = number in each bin for column 2, c2 = centers
[n2, c2] = hist(iris(:,2), k);

% prob of each bin for column 2
p = [p; n2/sum(n2)];

% Column 3
%------------------------------------
% bin column 3, n3 = number in each bin for column 3, c3 = centers
[n3, c3] = hist(iris(:,3), k);

% prob of each bin for column 3
p = [p; n3/sum(n3)];

% Column 2
%------------------------------------
% bin column 4, n4 = number in each bin for column 4, c4 = centers
[n4, c4] = hist(iris(:,4), k);

% prob of each bin for column 4
p = [p; n4/sum(n4)]

% entropy and gain of all columns
h = sum(-p'.*log2(p'))
g = hT - h


