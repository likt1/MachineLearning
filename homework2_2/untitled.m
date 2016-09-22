%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework assignment 2
% Team:
% James Buckey, Kendrick Li & Praakrit Pradhan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;
load fisheriris.mat;
k = 10; % number of bins
% Create iris graph
%-----------------------------------%
iris = meas.*10;
index = 0;
for k = 5:5:20
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
    
    att_probBin;
    
    % stuff = att1_probBin(1,:).*att2_probBin(2,:);
    % Prob_Flower_Att1 = Prob_bin_flower
    
    phi = ones(75,3);
    % count = 0;
    for sampleRow = 1:75
        for flower = 1:3
            for attributes = 1:4
                %         sampleRow
                %         attributes
                %          count = count + 1;
                %         if (mod(count-1,25) == 0)
                %             count = 1;
                %         end
                binnum = flowerTest(sampleRow,attributes);
                phi(sampleRow,flower) = phi(sampleRow,flower) * att_probBin(binnum,flower,attributes);
                %         pause(1)
            end
        end
    end
    
    % Optimized training set:there are equal amounts of each flower
    probvnb(:,1:3) = probSentosa * phi(:,1:3);
    % probvnb(:,2) = probVersicolor * phi(:,2);
    % probvnb(:,3) = probVirginica * phi(:,3);
    
    % Returns the max in each row.
    % Compares the three flowers VNB and picks the largest
    % I gives us the column number at which its max
    [M I] = max(probvnb,[],2);
    
    index = index + 1;
    % Comparing I with the actual flower values will give us accuracies
    accurate(index) = sum(flowerTest(:,5) == I)
end


%%%%% Do we need to check for each flowers accuracy and stufF? 
%%%%% Might need to re do a little code to get all data we need












