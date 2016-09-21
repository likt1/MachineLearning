%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% pT = [1/3, 1/3, 1/3]; % add for loop to determine prob for flower types
% hT = sum(-pT.*log2(pT))

% Calculate attribute entropy
%------------------------------------
cbin = zeros(150,4);
p = [];
for a = 1:4
    % bin column and get n = number in each bin, c = centers of bins
    [n, c] = hist(iris(:,a), k);
    
    % prob of each bin
    p = [p; n/sum(n)]
    
    % get which elements are in which bins
    for x = 1:150
        [y cbin(x, a)] = min(abs(c - iris(x,a)));
    end
end











