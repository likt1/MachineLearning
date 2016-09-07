%% training function
%  k = number of bins
%  returns [sentosaList, verisicolorList, verginicaList, sentosaTest,
%  verisicolorTest, verginicaTest]
function [sentosaList, verisicolorList, verginicaList, sentosaTest, ...
    verisicolorTest, virginicaTest] = train(k)
    load fisheriris.mat; rng shuffle;
    iris = meas.*10;
    irisWork = iris;

    for x = 1:150
        if(strcmp(species(x), 'setosa'))
            iris(x, 5) = 1.0;
        elseif(strcmp(species(x), 'versicolor'))
            iris(x, 5) = 2.0;
        else
            iris(x, 5) = 3.0;
        end
    end

    %%

    % Normalizing data set
    irisWork(:,1) = irisWork(:,1) - min(iris(:,1)) + 1;
    irisWork(:,2) = irisWork(:,2) - min(iris(:,2)) + 1;
    irisWork(:,3) = irisWork(:,3) - min(iris(:,3)) + 1;
    irisWork(:,4) = irisWork(:,4) - min(iris(:,4)) + 1;

    % Finding range for each attribute
    plRange = max(irisWork(:,1)) + 1;
    pwRange = max(irisWork(:,2)) + 1;
    slRange = max(irisWork(:,3)) + 1;
    swRange = max(irisWork(:,4)) + 1;

    % Descritized set allocation
    descSet = irisWork;

    % descritizing the data
    descSet(:,1) = descSet(:,1)./(plRange/k);
    descSet(:,2) = descSet(:,2)./(pwRange/k);
    descSet(:,3) = descSet(:,3)./(slRange/k);
    descSet(:,4) = descSet(:,4)./(swRange/k);

    descSet = ceil(descSet);

    % assigning the descritized set into flowers 
    sentosa = descSet(1:50,:);
    verisicolor = descSet(51:100,:);
    virginica = descSet(101:150,:);

    data = 1:50;
    data = data(randperm(50));
    sentosa = sentosa(data, :);
    verisicolor = verisicolor(data, :);
    virginica = virginica(data, :);

    sentosaTrain = sentosa(1:25, :);
    sentosaTest = sentosa(26:50, :);

    verisicolorTrain = verisicolor(1:25, :);
    verisicolorTest = verisicolor(26:50, :);

    virginicaTrain = virginica(1:25, :);
    virginicaTest = virginica(26:50, :);

    sentosaList = {4};
    verisicolorList = {4};
    verginicaList = {4};

    for i = 1:4
        sentosaList{i} = unique(sentosaTrain(:, i)');
        verisicolorList{i} = unique(verisicolorTrain(:, i)');
        verginicaList{i} = unique(virginicaTrain(:, i)');
    end
end