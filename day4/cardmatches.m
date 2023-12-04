% Wyatt Geckle
%
% Advent of Code 2023 Day 4


function matches = cardmatches(card)
    splitCard = regexp(card, ": +| +\\| +", 'split');

    winning = strsplit(splitCard{2});
    heldNums = strsplit(splitCard{3});

    winningNums = containers.Map(winning, zeros(1, length(winning)));

    matches = 0;

    for num = heldNums
        if isKey(winningNums, num)
            matches = matches + 1;
        end
    end
end

