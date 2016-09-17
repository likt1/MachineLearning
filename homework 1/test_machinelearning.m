%%% Machine Learning %%%
%%% Assignment 1 : Iris data set %%%

%%% Praakrit Pradhan %%% 

%%
load fisheriris.mat;
iris = meas * 10;

%% 
% petalLegth , petalWidth , sepalLength , sepalWidth

for x = 1:150
    if strcmp(species(x),'setosa')
        iris(x,5) = 1;
    elseif strcmp(species(x),'versicolor')
        iris(x,5) = 2;
    else
        iris(x,5) = 3; 
    end
end

%% 
[iris(1:5,:);iris(51:55,:);iris(101:105,:)]

%%
% raynge = range(iris(:,1:4));

k = input('Please enter a k value: ');
% miyan = min(iris)
% for x = 1:4
% temp(:,x) = ceil(iris(:,x)/((raynge(x))/(k-1)));
% end
% [temp(1:5,:);temp(51:55,:);temp(101:105,:)]

%%

% Binning data approprietly. ? ? maybe
M = iris(:,1);

%# compute bins
nbins = 3;
binEdges = linspace(min(M),max(M),nbins+1);
%# bins lower edge
aj = binEdges(1:end-1);     
%# bins upper edge
bj = binEdges(2:end);       
%# bins center
cj = ( aj + bj ) ./ 2;      

%# assign values to bins
[~,binIdx] = histc(M, [binEdges(1:end-1) Inf]);

%# count number of values in each bin
nj = accumarray(binIdx, 1, [nbins 1], @sum);

%# plot histogram
bar(cj,nj,'hist')
set(gca, 'XTick',binEdges, 'XLim',[binEdges(1) binEdges(end)])
xlabel('Bins'), ylabel('Counts'), title('histogram of measured bacterial')

%%
figure(2)
hist(iris(:,1),3)

%%





