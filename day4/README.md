## Overview

### Part One

Suppose you're given a card

```
Card 1: 11 22 33 44 55 | 78  3 22 99 11 26 33 84
```

The card contains two sets.  Let $`A = \{11, 22, 33, 44, 55\}`$ represent the
first set, and $`B = \{78, 3, 22, 99, 11, 26, 33, 84\}`$ represent the second
set.  The earnings of the card is found with the formula

$$\lfloor 2^{|A \cap B| - 1} \rfloor$$

Since $`A \cap B = \{11, 22, 33\}`$, and thus $|A \cap B| = 3$, the earnings for
this card are calculated as $\lfloor 2^{3 - 1} \rfloor = 4$
Perform this calculation for all cards and sum the results to get the total
points earned.

### Part Two

Loop through the cards from the input file.  Keep track of the known quantity
of each card, with it being known that at least one of each card is present
initially.  Additionally, set the total number of cards to the number of cards
in the input file.  For each card, assuming $A$ represents its first set, $B$
represents its second set, and $n_{cards}$ represents its quantity, add
$|A \cap B|n_{cards}$ to the card total, and add $n_{cards}$ to the next
$|A \cap B|$ cards.  The final card total is the answer to this problem.


## Usage

Check for Octave's installation with

```
octave --version
```

If Octave is installed, run

```
octave scratchcards.m <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```


## References

Eaton, John.  (2023).  GNU Octave.
<https://octave.org/>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

