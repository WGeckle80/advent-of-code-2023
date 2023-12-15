## Overview

### Part One

Suppose a line is given in the input file such as one of the example lines:

```
a1b2c3d4e5f
```

The first and last digit must be found within the line.  It may be the case
that the first and last digit are the same, but that doesn't occur for this
example.

Initially check if both the first and last characters are digits.
If not, remove the first character if it's not a digit, and remove the last
character if it's not a digit.  After one step, both the first and last
characters are removed, since neither are digits.

```
1b2c3d4e5
```

Perform this recursively until both the first and last characters are digits.
Coincidentally, the first and last digits are digits after one step.  When
this happens, convert the first and last digits to integers, and return the
calibration value as

```
10*first + last
```

For this line, the calibration value is 15.

Find the calibration value for every line in the input file, and sum them up
to get the answer to this problem.

### Part Two

Suppose a line is given in the input file such as one of the example lines:

```
7pqrstsixteen
```

For this part, the english spellings of digits also count as valid digits.
To limit the amount of manual checking, regex is used to find the first and
last digits.  The regex used to find the first digit is

```
[0-9]|one|two|three|four|five|six|seven|eight|nine
```

After compiling, a forward search on the string with this regex results in the
first digit being found.

To find the second digit, the regex must be mostly reversed, resulting in

```
[0-9]|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno
```

After compiling, a forward search on the reversed string with this regex
results in the last digit being found (6).

Computing the calibration value in the same manner as part one, the value
turns out to be 76.

In the same manner as part one, find the calibration value for every line in
the input file, and sum them up to get the answer to this problem.


## Usage

Check for OCaml's installation with

```
ocaml --version
```

If OCaml is installed, run

```
ocaml str.cma trebuchet.ml <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```


## References

OCaml.  (2023).  OCaml.
<https://ocaml.org/>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

