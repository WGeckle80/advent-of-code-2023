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

If the original surrounded number is considered a schematic, then the length
of the schematic is the number of characters before the first newline, as a
schematic is always rectangular.

### Part Two



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

