%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Learning %
% Assignment 1 %
% Team: Buckey James, Li Kendrick, Pradhan Praakrit %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%test it 100 function
%  returns [sentosaList, verisicolorList, verginicaList, sentosaTest,
%  verisicolorTest, verginicaTest]

function [accuracies] = test100()
    rng('shuffle')
    % Create vector of 0's
    accuracies = zeros(100,3);
    fifteen = zeros(100,3);
    for j = 3:2:9
        for i = 1:100
            accuracies(i,:) = mean(test(j));
        end
        f = figure;
        set(f,'name',sprintf('Accuracies for k = %d',j),'numbertitle','off')
        subplot(2,2,1)
        hist(accuracies(:,1)); 
        title(sprintf('k = %d : Sentosa', j));
        h = findobj(gca,'Type','patch');
        h.FaceColor = [1 0.8 0.2];
        h.EdgeColor = 'w';
        
        subplot(2,2,2)
        hist(accuracies(:,2));
        title(sprintf('k = %d : Versicolor', j));
        h = findobj(gca,'Type','patch');
        h.FaceColor = [0.6 0 1];
        h.EdgeColor = 'w';
        
        subplot(2,2,3)
        hist(accuracies(:,3));
        title(sprintf('k = %d : Verginica', j));
        h = findobj(gca,'Type','patch');
        h.FaceColor = [1 0.1 0.1];
        h.EdgeColor = 'w';
        
        subplot(2,2,4)
        y = mean(accuracies) * 100;
        h = bar(y);
        text([1 2 3],y,{num2str(y(1),'%0.2f %%'),num2str(y(2),'%0.2f %%'),num2str(y(3),'%0.2f %%')},...
    'HorizontalAlignment','center',...
    'VerticalAlignment','top')
        set(h, 'FaceColor', [0.5 0.87 0.7])
        title(sprintf('k = %d : Mean Accuracy %', j));
        flowers={'Sentosa'; 'Versicolor'; 'Virginica' };
        set(gca,'xticklabel',flowers)
    end
end