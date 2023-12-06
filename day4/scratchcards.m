% Wyatt Geckle
%
% Advent of Code 2023 Day 4


args = argv();

if length(args) == 0
    display('Please provide the puzzle input file.');
else
    cards = strsplit(fileread(args{1}), '\n')(1:end-1);

    totalCards = length(cards);

    totalPoints = 0;
    for i = 1:totalCards
        matches = cardmatches(cards{i});

        totalPoints = totalPoints + bitshift(1, matches - 1);
    end

    cardTotals = ones(1, totalCards);
    for i = 1:length(cards);
        matches = cardmatches(cards{i});

        totalCards = totalCards + cardTotals(i)*matches;

        for j = 1:matches
            cardTotals(i + j) = cardTotals(i + j) + cardTotals(i);
        end
    end

    fprintf("Part One: %d\n", totalPoints);
    fprintf("Part Two: %d\n", totalCards);
end

