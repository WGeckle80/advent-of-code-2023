## Overview

### Part One

Consider a number surrounded by dots:

```
....
.64.
....
```

If any of the dots were to be replaced by a non-dot and non-digit character,
the number is then considered to be a part number.  Otherwise, the number is
ignored.

Suppose the same surrounded number is flattened as a string of text.

```
....\n.64.\n....
```

Like in the two-dimensional case, if any of the dots are replaced with a
non-dot and non-digit character, the number is considered a part number.
Thus, since the index of `6` is 6, the characters at indices 5 and 8, as
well as every character in indices ranges [0, 4) and [10, 14) must be checked
for non-dot and non-digit characters.

To express things more generally, the length of the schematic must be
considered.  If the original surrounded number is considered a schematic, then
the length of the schematic is the number of characters before the first
newline, as a schematic is always rectangular.  In this case, the length is 4.

Expressions of the differences between the start index and indices range
endpoints are found in terms of the start index $$i_{start}$$, number length
$$l_{num}$$, and schematic length $$l_{schem}$$.  In general, the characters at
indices $$i_{start} - 1$$, $$i_{start} + l_{schem}$$, and every index in
the ranges $$[i_{start} - l_{schem} - 2, i_{start} - l_{schem} + l_{num})$$ and
$$[i_{start} + l_{line}, i_{start} + l_{schem} + l_{num} + 1]$$ must be checked
for non-dot and non-digit characters.

Iterate over the puzzle input file contents as a linear data structure.  If any
digit is found, find the length of the number it starts, then add it to a sum
accumulator if it's a part number.  Advance to the next non-digit character.
Repeat this process until the end of the file is reached.  Return the sum as
the answer to this problem.

### Part Two

A gear is an asterisk adjacent two exactly two numbers.  The following
schematic contains a gear.

```
.......
.64....
...*...
....46.
.......
```

The similar schematic below does not contain a gear, as the asterisk is only
adjacent to 46.

```
.......
.64....
....*..
....46.
.......
```

To check if an asterisk is a gear, first check if the characters to its left
and right are part of numbers.  Then, check if the character to its top left
is a digit.  If it is, get its corresponding number's start and end indices.
Otherwise, check if the top middle character is a digit, and get the start
and end indices of its corresponding number if applicable.  In either case,
if the top middle character is not a digit, check if the top right character
is a digit, and get the start and end indices of its corresponding number
if applicable.  Repeat these checks for the three characters below the
asterisk.  If exactly two numbers are found, the asterisk represents a gear.

Iterate over the puzzle input file contents as a linear data structure.  If
an asterisk is found, check if it's a gear, multiply the two numbers adjacent
to it if applicable, and add the product to a sum accumulator.  Repeat this
process until the end of the file is reached.  Return the sum as the answer
to this problem.

## Usage

Check for Go's installation with

```
go version
```

If Go is installed, run

```
go run schematic.go <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```


## References

Go.  (2023).  The Go Programming Language.
<https://go.dev/>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

