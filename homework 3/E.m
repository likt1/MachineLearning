%% E(i, dataset, alpha, b)
% WE DONT USE THIS CURRENTLY
% Calculates the E for datapoint 'i' in cell array 'dataset'
% in relation to alpha array 'alpha' and bias 'b'
%   where for point x 
%       dataset(x, 1) contains the array of data values
%   and 
%       dataset(x, 2) is the corresponding binary classification (y)
%%
function out = E(i, dataset, alpha, b)
    sum = 0;
    for j = 1:length(dataset)
        calc = alpha(j)*dataset{j, 2}*kernel(dataset{i}, dataset{j}) + b;
        sum = sum + calc;
    end
    out = sum - dataset{i, 2};
end