## Overview

### Part One

Suppose the platform as seen in the prompt is given:

```
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
```

Isolate one of the columns, which in this example is the third-to-last.

```
.
.
.
.
O
#
.
O
#
.
```

Set an initial swap index to row 1.  Loop through the column.  Whenever an `O`
is encountered, swap it with the character at the swap index and increment
the swap index.  Whenever a `#` is encountered, set the swap index to the
current row incremented once.  After looping through the column, it appears as

```
O
.
.
.
.
#
O
.
#
.
```

Perform this transformation for each column in the platform matrix, which
according to the prompt, yields

```
OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
```

Assuming one-indexing, if a row's index is denoted by $i$, the number of
rows is denoted by $n_{rows}$, and the number of `O` in a row is denoted by
$O_i$, then a row's contribution is calcuated as

$$(n_{rows} - i + 1)O_i$$

Sum the contributions for the answer to this problem.

### Part Two

To tilt the platform south, east, or west, apply the principles of tilting it
north, using appropriate indexing and use of rows or columns.  For each spin
cycle, tilt the platform north, west, south, then east.

When performing many spin cycles, the first few cycles yield unique platform
configurations.  For example, in the given example, the layout is unique after
the first and second cycles.  However, the platform after the third cycle is
repeated after the tenth cycle.  This also reveals that, starting after the
third cycle, the platform's configuration repeats every seven cycles.  Given
that, it is deduced that the platform's layout after the third cycle is the
same as it is after the $999999997^\text{th}$, and equivalently, the layout
after the sixth cycle is the same as it is after the $1000000000^\text{th}$
cycle.

First, find the cycle after which the cycle enters its repeating sequence by
tilting the platform until the current layout matches any one of the previous
ones.  If the current cycle is $c_{current}$, and the previous cycle of
its matching layout is $c_{start}$, then the remaining tilt cycles on the
platform is calculated as

$$(1000000000 - c_{start}) \bmod (c_{current} - c_{start})$$

Perform that many more spin cycles on the platform.  As in part one, calculate
and sum the rows' contributions for the answer to this problem.


## Usage

Check for Lua's installation with

```
lua -v
```

If Lua is installed, run

```
lua reflector.lua <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```


## References

Ierusalimschy, Roberto.  (2003).  Programming in Lua (first edition).
<https://www.lua.org/pil/contents.html>

Latiyan, Mukul.  (2021).  How to iterate individual characters in a Lua string?
<https://www.tutorialspoint.com/how-to-iterate-individual-characters-in-a-lua-string>

Lua.org, PUC-Rio.  (2023).  The Programming Language Lua.
<https://www.lua.org/>

Kenlon, Seth.  (2022).  How to iterate over tables in Lua.
<https://opensource.com/article/22/11/iterate-over-tables-lua>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

Wikibooks contributors.  (2014).  Lua Programming/command line parameter.
<https://en.wikibooks.org/w/index.php?title=Lua_Programming/command_line_parameter&oldid=2664314>

