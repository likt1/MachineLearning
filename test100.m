%% test it 100 function
%  returns [sentosaList, verisicolorList, verginicaList, sentosaTest,
%  verisicolorTest, verginicaTest]
function [accuracies] = test100()
    accuracies = zeros(100,1);
    
    for j = 3:2:9
        for i = 1:100
            rng shuffle;
            accuracies(i) = mean(mean(test(j)));
        end

        figure();
        hist(accuracies);
        title(sprintf('k = %d', j));

    end
end