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

% Binning step with hist
%------------------------------------
cbin = zeros(150,4);
for a = 1:4
    % bin column and get n = number in each bin, c = centers of bins
    [n, c] = hist(iris(:,a), k);
    
    % get which elements are in which bins
    for x = 1:150
        [y cbin(x, a)] = min(abs(c - iris(x,a)));
    end
end

% Generate cell lists of what bins exist for which flowers
%------------------------------------
% cbin discretized array
cbin(:, 5) = iris(:, 5);

% Assigning the descritized set into flowers 
sentosa = cbin(1:50,:);
verisicolor = cbin(51:100,:);
virginica = cbin(101:150,:);

% Randomizing
data = 1:50;
data = data(randperm(50));
sentosa = sentosa(data, :);
verisicolor = verisicolor(data, :);
virginica = virginica(data, :);

% Splitting into training and test data
sentosaTrain = sentosa(1:25, :);
sentosaTest = sentosa(26:50, :);
verisicolorTrain = verisicolor(1:25, :);
verisicolorTest = verisicolor(26:50, :);
virginicaTrain = virginica(1:25, :);
virginicaTest = virginica(26:50, :);

sentosaList = {4};
verisicolorList = {4};
verginicaList = {4};

% Creating the cell array that holds the bins that exist for each flower
for i = 1:4
    sentosaList{i} = unique(sentosaTrain(:, i)');
    verisicolorList{i} = unique(verisicolorTrain(:, i)');
    verginicaList{i} = unique(virginicaTrain(:, i)');
end

% Rebuild training array
cbin = [sentosaTrain; verisicolorTrain; virginicaTrain];
testArray = [sentosaTest; verisicolorTest; virginicaTest];

% Total entropy of training
%------------------------------------
pT = [1/3, 1/3, 1/3]; % add for loop to determine prob for flower types
hT = sum(-pT.*log2(pT))

% Calculate entropy for everything
%------------------------------------
% split using hist
[a,b] = hist(cbin(:,1:4),unique(cbin(:,1:4)))

p = [];
totals = sum(a);
for n = 1:4
    % prob of each bin per column
    p = [p a(:,n)./totals(n)];
end

binC1 = zeros(3, k);
binC2 = zeros(3, k);
binC3 = zeros(3, k);
binC4 = zeros(3, k);

for x = 1:75
    row = cbin(x,:);
    
    binC1(row(5), row(1)) = binC1(row(5), row(1)) + 1;
    binC2(row(5), row(2)) = binC2(row(5), row(2)) + 1;
    binC3(row(5), row(3)) = binC3(row(5), row(3)) + 1;
    binC4(row(5), row(4)) = binC4(row(5), row(4)) + 1;
end

% Calculate entropy for everything
%------------------------------------
% please check
% probability of Column X
pC1 = [binC1(:,1)/a(1,1), binC1(:,2)/a(2,1), binC1(:,3)/a(3,1)];
pC2 = [binC2(:,1)/a(1,2), binC2(:,2)/a(2,2), binC2(:,3)/a(3,2)];
pC3 = [binC3(:,1)/a(1,3), binC3(:,2)/a(2,3), binC3(:,3)/a(3,3)];
pC4 = [binC4(:,1)/a(1,4), binC4(:,2)/a(2,4), binC4(:,3)/a(3,4)];

G = zeros(1,4); % Gain
H = zeros(1,4); % Entropy

% calculates the entropy for each flower per bin
Hc1 = -pC1.*log2(pC1);
% removes NaN
Hc1(isnan(Hc1)) = 0;
% sum entropy values to get entropy per bin, then multiply
% with probablity of bin in column to get weighted entropies,
% then sum entropies to get total column entropy
H(1) = sum(sum(Hc1, 1).*p(:,1)');
% take total entropy and subtract column entropy to get column gain
G(1) = hT - H(1);

Hc2 = -pC2.*log2(pC2);
Hc2(isnan(Hc2)) = 0;
H(2) = sum(sum(Hc2, 1).*p(:,2)');
G(2) = hT - H(2);

Hc3 = -pC3.*log2(pC3);
Hc3(isnan(Hc3)) = 0;
H(3) = sum(sum(Hc3, 1).*p(:,3)');
G(3) = hT - H(3);

Hc4 = -pC4.*log2(pC4);
Hc4(isnan(Hc4)) = 0;
H(4) = sum(sum(Hc4, 1).*p(:,4)');
G(4) = hT - H(4);

H % print
G % gain

tempG = G;
testOrder = [];
for n = 1:4
    [v p] = max(tempG);
    testOrder = [testOrder p];
    tempG(p) = -1;
end

testOrder

for e = 1:75
    element = testArray(e,:);
    
    cont = true;
    for a = 1:4
        if cont
            number = element(testOrder(a));
        end
    end
end