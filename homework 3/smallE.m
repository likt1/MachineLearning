%% smallE(i, dataset, alpha, i1)
% Calculates the e for datapoint 'i' in cell array 'dataset'
% where i1 is the index of x1
% in relation to alpha array 'alpha'
%   where for point x 
%       dataset(x, 1) contains the array of data values
%   and 
%       dataset(x, 2) is the corresponding binary classification (y)
%%
function out = smallE(i, dataset, alpha, i1)
    out = 0;
    for j = 1:length(dataset)
        kernelCalc = kernel(dataset{j}, dataset{i1}) - kernel(dataset{j}, dataset{i});
        productCalc = alpha(j)*dataset{j, 2}*kernelCalc;
        out = out + productCalc + dataset{i, 2} - dataset{i1, 2}*kernel(dataset{i}, dataset{j});
    end
end