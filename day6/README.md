## Overview

### Setup

Unlike most languages, this environment requires a significant amount of setup
to be useful.  The C standard libary is disabled both due to errors when
attempting to link it, and the additional challenge provided by the lack of
premade I/O functions.  Thus, any I/O with any file, stdin, stdout, or stderr
must be done using Linux syscalls.

Generally useful functions for debugging and printing the final outputs are
ones to print a single character, print a string, and print an integer.
Printing a single character is simple, as the only thing required is to
load the character to memory and perform the `write` syscall with a count of 1.
Printing a string is similarly simple, as since the assumption is that a
string is null-terminated, the length is found by reimplementing the
`strlen`, then the `write` syscall is performed using the string buffer with
the number of bytes written as the length of the string.

To print an unsigned 32-bit integer to standard output in decimal, make a stack
allocation of at least 10 bytes, as the string is at most 10 digits. Assuming
that the top of the stack allocation is at a larger memory address than the
bottom, assemble the allocation such that the least signficant digit of the
decimal integer is at the top.  For an number 12345, the stack appears as

|  Digits  |
|:--------:|
|    5     |
|    4     |
|    3     |
|    2     |
|    1     |
|   ...    |

Add `'0'` to each of the digits to convert them to their ASCII representations.
Assuming a pointer to the bottom of the stack digits is present, and the string
length of the number is obtained, perform the `write` syscall with the buffer
as the pointer, and the number of bytes written as the length.

Printing a signed 32-bit integer is similar, but two extra cases must be
handled regarding negative numbers.  If the number is the minimum unsigned
integer $-2^{31}$, the number must be handled on its own.  If it's any other
negative number, a minus sign is printed, and the number is negated so it's
compatible with the unsigned 32-bit integer print algorithm.

The used implementation of reading unsigned integers is generally simple, as
characters are read one at a time through the `read` syscall.  Reading an
unsigned integer is done by reading characters until a digit is found, then
reading until a non-digit is found.  Reading an unsigned integer across a line
is done by reading the line, updating the read integer every time a digit is
found.  Reading one character at a time through syscalls is not ideal for
speed, but this example is small enough for the speed increase to be
negligible.

Since functions like these are not provided when not using the C standard
library, developing I/O functions up-front saves a significant amount of time
in debugging and program development compared to flailing about with bare
system calls across the program.

### Part One

The file describes a list of times with their corresponding best distances.
Read the times and distances into their respective arrays.  For a given
time, such as 7 as used in the problem description, there are 8 possible
final distances: [0, 6, 10, 12, 12, 10, 6, 0].  Of those, there are
4 distances which beat the current best: [10, 12, 12, 10].

To efficiently solve this problem, it is observed that the list of possible
final distances is symetrical about its midpoint, whether that be between the
two middle elements in the case of even length lists, or the middle element
in the case of odd length lists.  Additionally, the first and last elements
of the list are irrelevant, as they're guaranteed to be 0.

With this information, the starting index set to 1, and the list is iterated
through until a time is found which is less than the current best distance,
which happens at index 2.  When this is found, 2 times the current index
numbers are removed from the list.  More precisely, if the race time is
$r_{time}$, the index of the first distance greater than the given best
distance is $i$, and the number of ways to beat the given best distance is
$n_{ways}$, the relationship between them is

$$n_{ways} = r_{time} - 2i + 1$$

Perform this calculation for each time-distance pair and compute the product
for the answer to this problem.

Note that the list doesn't need to be created, as it's just a means to
visualize the problem.

### Part Two

The same calculation as part one is performed, except the numbers separated
by spaces are combined into single numbers.

While the emulated architecture used is 32-bit, the given distance could not be
represented in 32 bits, necessitating slight changes in some functions.  Since
some register conventions change slightly when 64-bit quantities are used, and
there are no flags for this architecture, GCC compiler output was referenced
for register usage and 64-bit arithmetic.


## Usage

On Ubuntu 22.04, the required packages can be installed with

```
sudo apt install qemu binutils-mips-linux-gnu gcc-mips-linux-gnu
```

Assuming the installation is successful, the following commands should
have non-error output:

```
qemu-mips --version
mips-linux-gnu-as --version
mips-linux-gnu-gcc --version
```

If the commands return no errors, assemble and link the program with

```
make
```

If successful, `race` should appear in the current directory.  Run the program
with

```
qemu-mips race <puzzle-input-file>
```

If the correct puzzle input file is provided, the output should appear as

```
Part One: {part-one-answer}
Part Two: {part-two-answer}
```

To reset the directory to its default state, run

```
make clean
```


## References

cppreference.com.  (2022).  fgets.
<https://en.cppreference.com/w/c/io/fgets>

Free Software Foundation, Inc.  (2020).  GCC, the GNU Compiler Collection.
<https://gcc.gnu.org/>

Kerrisk, Michael.  (2023).  Linux man pages online.
<https://www.man7.org/linux/man-pages/index.html>

Low Level Learning.  (2021).  You Can Learn MIPS Assembly in 15 Minutes
| Getting Started Programming Assembly in 2021.
<https://youtu.be/5AN4Fo0GiBI?feature=shared>

QEMU.  (2023).  QEMU.
<https://www.qemu.org/>

W3Challs.  (2023).  Linux Mips o32 syscalls.
<https://syscalls.w3challs.com/?arch=mips_o32>

Wastl, Eric.  (2023).  Advent of Code.
<https://adventofcode.com/>

