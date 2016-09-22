%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework assignment 2
% Team:
% James Buckey, Kendrick Li & Praakrit Pradhan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;
load fisheriris.mat;
k = 5; % number of bins
% Create iris graph
%-----------------------------------%
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

% All Train\Test data
flowerTrain = [sentosaTrain; verisicolorTrain; virginicaTrain];
flowerTest = [sentosaTest; verisicolorTest; virginicaTest];

% Probability of each flower in Training data
probSentosa = sum(flowerTrain(:,5) == 1)/75;
probVersicolor = sum(flowerTrain(:,5) == 2)/75;
probVirginica = sum(flowerTrain(:,5) == 3)/75;

% Probability of each bin
att_probBin = [];
for binnum = 1:k
    for flower = 1:3
        flowerr = flowerTrain(find(flowerTrain(:,5) == flower),:);
        att_probBin(binnum,flower,1) = sum(flowerr(:,1) == binnum)/25;
        att_probBin(binnum,flower,2) = sum(flowerr(:,2) == binnum)/25;
        att_probBin(binnum,flower,3) = sum(flowerr(:,3) == binnum)/25;
        att_probBin(binnum,flower,4) = sum(flowerr(:,4) == binnum)/25;
    end
end

att_probBin

% att1_probBin
% att2_probBin
% att3_probBin
% att4_probBin

% stuff = att1_probBin(1,:).*att2_probBin(2,:);
% Prob_Flower_Att1 = Prob_bin_flower

probVNM1 = [];

flower1 = flowerTest(find(flowerTest(:,5) == 1),:);
phi = ones(1,3);
z = 1;
% flowerTest
for rows = 1:75
    for column = 1:4
        binnum = flowerTest(rows,column);
        phi(z) = phi(z) * att_probBin(binnum,flowerTest(rows,5),column)
        pause(1)
        if rows > 25
            z = z+1
        end
            
    end
end

phi



















