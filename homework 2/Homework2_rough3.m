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

% Calculate attribute entropy
%------------------------------------
cbin = zeros(150,4);
p = [];
for a = 1:4
    % bin column and get n = number in each bin, c = centers of bins
    [n, c] = hist(iris(:,a), k);
    
    % prob of each bin
    p = [p; n/sum(n)];
    
    % get which elements are in which bins
    for x = 1:150
        [y cbin(x, a)] = min(abs(c - iris(x,a)));
    end
end

cbin(:, 5) = iris(:, 5);

[a,b] = hist(cbin,unique(cbin))

binC1 = zeros(3, k);
binC2 = zeros(3, k);
binC3 = zeros(3, k);
binC4 = zeros(3, k);

for x = 1:150
    row = cbin(x,:);
    
    binC1(row(5), row(1)) = binC1(row(5), row(1)) + 1;
    binC2(row(5), row(2)) = binC2(row(5), row(2)) + 1;
    binC3(row(5), row(3)) = binC3(row(5), row(3)) + 1;
    binC4(row(5), row(4)) = binC4(row(5), row(4)) + 1;
end

% please check
pC1 = [binC1(:,1)/a(1,1), binC1(:,2)/a(2,1), binC1(:,3)/a(3,1)];
pC2 = [binC2(:,1)/a(1,2), binC2(:,2)/a(2,2), binC2(:,3)/a(3,2)];
pC3 = [binC3(:,1)/a(1,3), binC3(:,2)/a(2,3), binC3(:,3)/a(3,3)];
pC4 = [binC4(:,1)/a(1,4), binC4(:,2)/a(2,4), binC4(:,3)/a(3,4)];

G = zeros(1,4);
H = zeros(1,4);

Hc1 = -pC1.*log2(pC1);
Hc1(find(isnan(Hc1))) = 0;
H(1) = sum(sum(Hc1, 1).*p(1,:));
G(1) = hT - H(1);

Hc2 = -pC2.*log2(pC2);
Hc2(find(isnan(Hc2))) = 0;
H(2) = sum(sum(Hc2, 1).*p(2,:));
G(2) = hT - H(2);

Hc3 = -pC3.*log2(pC3);
Hc3(find(isnan(Hc3))) = 0;
H(3) = sum(sum(Hc3, 1).*p(3,:));
G(3) = hT - H(3);

Hc4 = -pC4.*log2(pC4);
Hc4(find(isnan(Hc4))) = 0;
H(4) = sum(sum(Hc4, 1).*p(4,:));
G(4) = hT - H(4);

H
G
