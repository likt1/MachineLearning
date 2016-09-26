% runID3(k)
% Runs the ID3 algorithm on the iris data set
% Splits the set into 1/2 training and 1/2 test
function answer = runID3(k)
    load fisheriris.mat;

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
        [~, c] = hist(iris(:,a), k);

        % get which elements are in which bins
        for x = 1:150
            [~, cbin(x, a)] = min(abs(c - iris(x,a)));
        end
    end

    % Generate cell lists of what bins exist for which flowers
    %------------------------------------
    % cbin binning array
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
    virginicaList = {4};

    % Creating the cell array that holds the bins that exist for 
    % each flower
    for i = 1:4
        sentosaList{i} = unique(sentosaTrain(:, i)');
        verisicolorList{i} = unique(verisicolorTrain(:, i)');
        virginicaList{i} = unique(virginicaTrain(:, i)');
    end

    % Rebuild training array
    cbin = [sentosaTrain; verisicolorTrain; virginicaTrain];
    testArray = [sentosaTest; verisicolorTest; virginicaTest];

    % Total entropy of training
    %------------------------------------
    pT = [1/3, 1/3, 1/3]; % add for loop to determine prob for flower types
    hT = sum(-pT.*log2(pT));

    % Calculate entropy for everything
    %------------------------------------
    % split using hist
    split = hist(cbin(:,1:4),unique(cbin(:,1:4)));

    p = zeros(k, 4);
    totals = sum(split);
    for n = 1:4
        % prob of each bin per column
        p(:,n) = split(:,n)./totals(n);
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
    % probability of each flower per bin for each column X
    pC1 = zeros(3,5);
    pC2 = zeros(3,5);
    pC3 = zeros(3,5);
    pC4 = zeros(3,5);
    for x = 1:k
        pC1(:,x) = binC1(:,x)/sum(binC1(:,x));
        pC2(:,x) = binC2(:,x)/sum(binC2(:,x));
        pC3(:,x) = binC3(:,x)/sum(binC3(:,x));
        pC4(:,x) = binC4(:,x)/sum(binC4(:,x));
    end

    G = zeros(1,4); % Gain
    H = zeros(1,4); % Entropy

    % calculates the entropy for the probabilities calculated previously
    Hc1 = -pC1.*log2(pC1);
    % removes NaN from entropy lists
    Hc1(isnan(Hc1)) = 0;
    % sum entropy values to get entropy per bin, then multiply
    % with probablity of bin per column to get weighted entropies,
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

    % Generate column test order
    %------------------------------------
    tempG = G;
    testOrder = zeros(1,4);
    for n = 1:4
        [~, pos] = max(tempG);
        testOrder(n) = pos;
        tempG(pos) = -1;
    end

    % Do Tests
    %------------------------------------
    answer = [];
    for e = 1:75
        element = testArray(e,:);

        exists = [1, 2, 3];
        % If the bin number does not exist for that flower, set flower to 0
        for a = 1:4
            if length(exists(exists > 0)) > 1
                number = element(testOrder(a));
                if length(find(sentosaList{testOrder(a)} == number)) < 1
                    exists(exists == 1) = 0;
                end
            end
            if length(exists(exists > 0)) > 1
                if length(find(verisicolorList{testOrder(a)} == number)) < 1
                    exists(exists == 2) = 0;
                end
            end
            if length(exists(exists > 0)) > 1
                if length(find(virginicaList{testOrder(a)} == number)) < 1
                    exists(exists == 3) = 0;
                end
            end
        end

        % If there is one answer, use it
        if length(exists(exists > 0)) == 1
            answer(e) = exists(exists > 0);
        else % otherwise uncomfirmed
            answer(e) = 0;
        end
    end
    
    answer = [answer' testArray(:,5)];
end