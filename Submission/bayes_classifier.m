%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework assignment 2
% Team:
% James Buckey, Kendrick Li & Praakrit Pradhan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;
load fisheriris.mat;
rng('shuffle');
k = 10; % number of bins
% Create iris graph
%-----------------------------------%
iris = meas.*10;
index = 0;
for runs = 1:10
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
        
        phi = ones(75,3);
        % count = 0;
        for sampleRow = 1:75
            for flower = 1:3
                for attributes = 1:4
                    binnum = flowerTest(sampleRow,attributes);
                    phi(sampleRow,flower) = phi(sampleRow,flower) * att_probBin(binnum,flower,attributes);
                    %         pause(1)
                end
            end
        end
        
        % Optimized training set:there are equal amounts of each flower
        probvnb(:,1:3) = 0.3333 * phi(:,1:3);
        
        % Returns the max in each row.
        % Compares the three flowers VNB and picks the largest
        % I gives us the column number at which its max
        [M I] = max(probvnb,[],2);
        
        index = index + 1;
        % Comparing I with the actual flower values will give us accuracies
        accurate_flower1(runs,index) = sum(flowerTest(1:25,5) == I(1:25));
        accurate_flower2(runs,index) = sum(flowerTest(1:25,5) == I(26:50));
        accurate_flower3(runs,index) = sum(flowerTest(1:25,5) == I(51:75));
        
    end
    index = 0;
end

max_flower = [max(accurate_flower1); max(accurate_flower2); max(accurate_flower3)];
max_flower = (max_flower/25)*100;
min_flower = [min(accurate_flower1); min(accurate_flower2); min(accurate_flower3)];
min_flower = (min_flower/25)*100;
mean_flower = [mean(accurate_flower1); mean(accurate_flower2); mean(accurate_flower3)];
mean_flower = (mean_flower/25)*100;

% bar graph X axis is Sentorsa, Versicolor , and Virginica
% Each flower graphs are set as MAX MIN and then MEAN (average)
face = [[1 0.8 0.2];[0.6 0 1];[1 0.1 0.1]];
for bins = 1:4
    flower = [];
    for flow = 1:3
        flower =  [flower; max_flower(flow,bins),min_flower(flow,bins),mean_flower(flow,bins)];
    end
    figure()
    bar(flower)
    text = sprintf('Bin k = %d',bins*5);
    title(text);
    flowers={'Sentosa'; 'Versicolor'; 'Virginica' };
        set(gca,'xticklabel',flowers)
end








