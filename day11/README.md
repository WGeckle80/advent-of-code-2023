## Overview

### Part One

Consider a small universe

```
#.......
.....#..
.#......
........
.......#
...#....
```

As empty space is denoted by `.`, and a galaxy is denoted by `#`, doubling the
size of any rows and columns which don't have any galaxies yields

```
#.........
.......#..
.#........
..........
..........
.........#
....#.....
```

Then, assuming indexing from 0, the coordinates of the galaxies are $(0, 0)$,
$(1, 7)$, $(2, 1)$, $(5, 9)$, and $(6, 4)$.  The distance between two galaxies
is the sum of the absolute differences of their x and y coordinates.
For example, the distance between the points at $(1, 7)$ and $(2, 1)$ is
$|1 - 2| + |7 - 1|$.  For each point, find the distances between the target
point and the other points.  Sum all of the distances, and divide the sum by 2
for the answer to this problem.

### Part Two

Using the original universe, instead of doubling the size of rows and columns
without galaxies, replace the row/column with a line of characters which
aren't either `.` or `#`.  For this purpose, `%` denotes a row/column without
a galaxy.

```
#.%.%...
..%.%#..
.#%.%...
%%%%%%%%
..%.%..#
..%#%...
```

When looping through the matrix, if a row is all `%`, increment the universe
row index by a million.  For this example, the universe row indexing looks like

```
0      #.%.%...
1      ..%.%#..
2      .#%.%...
3      %%%%%%%%
1e6+3  ..%.%..#
1e6+4  ..%#%...
```

If a row is not all `%`, iterate over the row, and increment the universe
column index by a million if `%` is encountered.  Record the new galaxy
coordinates, which for this example are $(0, 0)$, $(1, 2 \cdot 10^6 + 3)$,
$(2, 1)$, $(10^6 + 3, 2 \cdot 10^6 + 5)$, and $(10^6 + 4, 10^6 + 2)$.
As with part one, find the distances between the target point and the other
points for each point, sum all of the distances, and divide the sum by 2 for
the answer to this problem.


## Usage

Check for Clojure's installation with

```
clojure --version
```

If Clojure is installed, run

```
clojure -M universe.clj <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```


## References

Cromartie, John.  (2014).  Reading and Writing Clojure Data.
<https://github.com/clojure-cookbook/clojure-cookbook/blob/master/04_local-io/4-14_read-write-clojure-data-structures.asciidoc>

Hagan, Ross.  (2021).  Weekend with Doom Emacs as a Clojure IDE.
<https://ross-hagan.com/blog/weekend-with-doom-emacs-clojure>

Hickey, Rich.  (2022).  Clojure.
<https://clojure.org/>

Kim, Z. and ClojureDocs contributors.  (n.d.).  ClojureDocs.
<https://clojuredocs.org/>

Multiple Authors.  (2023).  Clojure Documentation.
<https://clojure-doc.org/>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

