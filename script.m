clear all; clc; load fisheriris.mat;

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

k = 3;

irisWork(:,1) = irisWork(:,1) - min(iris(:,1)) + 1;
irisWork(:,2) = irisWork(:,2) - min(iris(:,2)) + 1;
irisWork(:,3) = irisWork(:,3) - min(iris(:,3)) + 1;
irisWork(:,4) = irisWork(:,4) - min(iris(:,4)) + 1;

plRange = max(irisWork(:,1)) + 1;
pwRange = max(irisWork(:,2)) + 1;
slRange = max(irisWork(:,3)) + 1;
swRange = max(irisWork(:,4)) + 1;

descSet = irisWork;

descSet(:,1) = descSet(:,1)./(plRange/k);
descSet(:,2) = descSet(:,2)./(pwRange/k);
descSet(:,3) = descSet(:,3)./(slRange/k);
descSet(:,4) = descSet(:,4)./(swRange/k);

descSet = ceil(descSet);

sentosa = descSet(1:50,:);
verisicolor = descSet(51:100,:);
virginica = descSet(101:150,:);

data = 1:50;
data = data(randperm(50));
sentosa = sentosa(data, :);
data = data(randperm(50));
verisicolor = verisicolor(data, :);
data = data(randperm(50));
virginica = virginica(data, :);

sentosaTrain = sentosa(1:25, :);
sentosaTest = sentosa(26:50, :);
verisicolorTrain = verisicolor(1:25, :);
verisicolorTest = verisicolor(26:50, :);
virginicaTrain = virginica(1:25, :);
virginicaTest = virginica(26:50, :);