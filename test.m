%% test function
%  k = number of bins
%  returns [sentosaList, verisicolorList, verginicaList, sentosaTest,
%  verisicolorTest, verginicaTest]
function [results] = test(k)
    [sentosaList, verisicolorList, virginicaList, sentosaTest, verisicolorTest, virginicaTest] = train(k);
    
    results = zeros(24, 3);
    % sentosa testing
    for t = 1:24 % length of test list
        for a = 1:4  % number of attributes
            results(t,1) = any(sentosaTest(t,a) == sentosaList{a});
        end
    end
    
    % verisicolor testing
    for t = 1:25 % length of test list
        for a = 1:4  % number of attributes
            results(t,2) = any(verisicolorTest(t,a) == verisicolorList{a});
        end
    end
    
    % virginica testing
    for t = 1:25 % length of test list
        for a = 1:4  % number of attributes
            results(t,3) = any(virginicaTest(t,a) == virginicaList{a});
        end
    end
end