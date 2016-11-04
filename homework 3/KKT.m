%% KKT(index, alphaV, datasetCell, bias, weight)
%
%%
function out = KKT(i, alpha, dataset, b, w)
    col = 1;            % figure out if need to do all columns and sum
    yi = dataset(i, 2);
    xi = dataset{i, 1}(col);
    out = alpha(i)*((yi*(w*xi + b)) - 1);
end