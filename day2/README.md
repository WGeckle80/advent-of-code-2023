## Overview

### Part One

Suppose a game is represented as one of the example lines:

```
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
```

Subsets of the game are separated by semicolons.  Within each subset,
only one count of red, green, and blue cubes can be present, and any
color can be omitted.  For a valid game, no more than 12 reds, 13
greens, or 14 blues can be present in each subset.

Initially split the game line by colons and semicolons, and remove the
first element of the split.  The subsets should now be represented in
Racket as

```
'("8 green, 6 blue, 20 red" "5 blue, 4 red, 13 green" "5 green, 1 red")
```

For each subset, split the subset by commas, and split the colored cube
counts by spaces.  If there are more than 12 reds, 13 greens, or 14 blues
for any colored cube count, the game is invalid.  In this case, since
the third cube count of the first subset has 20 reds, the game is voided.

Filter out the invalid games in the input file, map the valid game lines
to their respective IDs as given before the colon, and sum the IDs to
get the answer to this problem.

### Part Two

Using the same game line from part one as a reference, the goal here is to
find the minimum number of each color required to play the game.

Initially split the game line by colons, semicolons, and commas, and
remove the first element of the split.  The colored cube counts should now
be represented in Racket as

```
'("8 green" "6 blue" "20 red" "5 blue "4 red" "13 green" "5 green" "1 red")
```

Split the colored cube counts by spaces.  If for the given color, the number
exceeds the current count, replace the current color count.  Perform this
for all colored cube counts in a game, and assume that the initial count
of reds, greens, and blues is 0.  Overall, the final count should be
20 reds, 8 greens, and 6 blues.

The power of the game is the product of the required number of reds, greens,
and blues.  For this game, the power is returned as 960.

Find the power for each game and sum them up to get the answer to this
problem.


## Usage

Check for Racket's installation with

```
racket --version
```

If Racket is installed, run

```
racket cubes.rkt <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```

