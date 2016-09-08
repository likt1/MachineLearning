%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Learning %
% Assignment 1 %
% Team: Buckey James, Li Kendrick, Pradhan Praakrit %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%test it 100 function
%  returns [sentosaList, verisicolorList, verginicaList, sentosaTest,
%  verisicolorTest, verginicaTest]

function [accuracies] = test100()
    rng shuffle
    % Create vector of 0's
    accuracies = zeros(100,3);
    for j = 3:2:9
        for i = 1:100
            accuracies(i,:) = mean(test(j));
        end
        figure();
        subplot(2,2,1)
        hist(accuracies(:,1));
        title(sprintf('k = %d : Sentosa', j));
        subplot(2,2,2)
        hist(accuracies(:,2));
        title(sprintf('k = %d : Versicolor', j));
        subplot(2,2,3)
        hist(accuracies(:,3));
        title(sprintf('k = %d : Verginica', j));
        subplot(2,2,4)
        hist(mean(accuracies(:,:)));
        title(sprintf('k = %d : Total', j));

    end
end