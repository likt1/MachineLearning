% analyzeID3(k)
% Runs the ID3 algorithm 10 times and calculates the min/max/average
% accuracy then graphs the results for k = 5,10,15,20
function result = analyzeID3
    result = zeros(3,4);
    for x = 5:5:20
        analysis = zeros(4,10);
        for y = 1:10 % 1 run per column
            answer = runID3(x);
            % acc sentosa 1st row
            analysis(1, y) = sum(answer(1:25,1) == answer(1:25,2))/25;
            % acc verisicolor 2nd row
            analysis(2, y) = sum(answer(26:50,1) == answer(26:50,2))/25;
            % acc virginica 3rd row
            analysis(3, y) = sum(answer(51:75,1) == answer(51:75,2))/25;
            
            % total acc 4th row
            analysis(4, y) = sum(answer(:,1) == answer(:,2))/75; 
        end
        
        % result should look like this: one line per k
        % k sentosaMin sentosaMax sentosaMean verisicolorMin verisicolorMax
        % verisicolorMean virginicaMin virginicaMax virginicaaMean totalMin
        % totalMax totalMean
        
        result(x/5,1) = x;
        place = 1;
        for y = 1:4
            place = place + 1;
            result(x/5,place) = min(analysis(y,:));
            place = place + 1;
            result(x/5,place) = max(analysis(y,:));
            place = place + 1;
            result(x/5,place) = mean(analysis(y,:));
        end
    end
    
    % Graph Results
    % TODO
end