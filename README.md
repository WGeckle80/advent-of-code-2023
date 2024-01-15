## Overview

The goal of this repository is to contain a solution to each day of
[Advent of Code 2023](https://adventofcode.com/2023) in a different programming
language.  Originally, all implementations were going to be in OCaml, as that
was also the original plan of a good friend of mine.  However, I soon got the
idea to write the solution for each day in a different language, as doing so
would force me to learn many languages I had limited or no experience in.
Some of the languages used were inspired by
[this challenge](https://github.com/elizabethqiu/aoc-2023/blob/main/CHALLENGE.md),
though the language order was more or less what I felt like based on the
problems of each day.  Due to various factors, the challenge was not completed
in any particular order.

Below are basic overviews of my experiences and/or views of each day's
language.

### Day 1

OCaml is the first functional programming language I've seriously used thanks
to [CMSC330 at UMD](https://bakalian.cs.umd.edu/fall23/330/), and to this day
it's my favorite.  UTop is a great REPL for testing out small snippets of code,
and pattern matching made the solution, particularly part two, much easier to
understand while writing it.  Admittedly, I didn't have the greatest experience
with regex in OCaml, but otherwise it was one of my favorite languages
throughout the challenge.

### Day 2

This was my first time using any dialect of Lisp, and my second functional
programming language.  Although I had a difficult time adjusting to Racket,
the documentation was fairly decent in getting me acquainted with it, and in
hindsight I could have read the documentation better for my solution.  I wasn't
the most fond of the language while writing the solution for day 2, but I'll
likely have grown on it by the next time I use it.

### Day 3

The last time I used Go before day 3 was a few years ago, when my ego told me
I was a much better programmer than I actually was.  Now that I have gotten
fairly comfortable in C, writing Go was a breeze.

### Day 4

MATLAB has one of my least favorite languages I've used.  It's not my least
productive language, as that would probably go to assembly when considering
languages with some sort of practical application.  However, over the two
years since I was originally exposed to the language, my perception of it has
only gotten worse with each new quirk of the language I encounter.  Some
relevant to this discussion are member access, strings vs. char arrays,
and functions.

Member access is clunky not only because array indexing is done with
parentheses as opposed to square brackets as in most languages, but cell
array access is done with curly braces.  It's not the worst thing in the world,
but when the likes of `strsplit` returns a cell array instead of an array or
list as it would in most other languages, the annoyance of differentiating
array and cell array access syntax with different bracket types gets
irritating.

In MATLAB, strings are denoted with double quotes, while char vectors are
denoted with single quotes.  While they're treated as the same in many
instances, there are select instances such as regex where their differences
become a hindrance.  For example, as seen in
[MATLAB's `regexp` documentation](https://www.mathworks.com/help/matlab/ref/regexp.html),
the type of return value of many output modes changes depending on multiple
factors, with many factors noting a dependence of whether the input `str` is a
string or char vector.  This makes it more difficult to predict the accurate
behavior of a function based on intuition, which is in contrast to many other
languages which simply operate on strings, and maybe a regex type for the
expression.

MATLAB function modules are imported solely based on which files are on the
MATLAB PATH when running a script.  They are not included by imports.
They are not included by running multiple files at the same time.  There aren't
even well documented namespaces to limit naming collisions.  This should speak
for itself.

More reasons why MATLAB has a terrible programming language are documented at
<https://www.rath.org/matlab-is-a-terrible-programming-language.html>.  It
sucks, because for as much as I dislike the MATLAB ecosystem as a whole, it is
good at what it's often used for: numerical computations and simulations.
So then why is the language itself so terrible?  Why are students consistently
forced to use it as a programming language akin to Python when it is terrible
at mimicking Python?

On top of all that, in spite of being free, GNU Octave makes several of
MATLAB's issues even worse.  It's an admirable project, but one that's simply
not ready to be any sort of a MATLAB replacement.  Not only are there several
functions not implemented at this time, but several of the ones that are
implemented are done so differently than MATLAB.  For example, while
`regexp('123  456', ": +| +\\| +", 'split')` returns `{'123'} {'456'}` in
MATLAB, the same function call returns `{'123  456'}` in Octave.  Additionally,
functions have different definition rules, as while in MATLAB they must be
declared at the bottom of a script file, doing so in Octave will yield
undefined name errors.  It's unfortunate, as I'd love to use it over MATLAB
for use in classes, but I can't because too much of the project is not ready.

### Day 5

In progress.

### Day 6

MIPS assembly was painful, but I learned a whole lot from doing it.  Up to
this point, I had done AVR and MIPS (in SPIM) assembly for classes, where AVR
was often supplemented with helper functions and libraries for terminal I/O,
and SPIM had high level system calls such as `print_int`, `print_str`,
and `read_int` for the only available I/O interface (the built-in console).
Up until completing this day's solution, I had not yet written a proper
application in assembly.  That changed with this day's solution, as the
environment used was Linux on an emulated MIPS III architecture.
Implementation details are in the day 6 README, but in short, the lack of
convenience system calls and the C standard library forced me to reimplement
functions which I had taken for granted in SPIM and high level languages.
They're not perfect solutions, and the read functions are especially flawed
considering that only one character is read per system call, but implementing
them myself has made me much more competent with both assembly and system call
programming.

### Day 7

I made a mistake in Rust which nearly doubled my code: I used enums as values
instead of enums with associated values.  Otherwise, the manner in which I
wrote the solution was some sort of combination of C and OCaml for the most
part.  However, this seems to be one of those cases where there is so much to
Rust beneath the surface that my opinions on it are mostly inaccurate at this
point in time.

### Day 8

In progress.

### Day 9

Swift was a surprisingly nice language to write with mostly great
documentation.  However, it's evident that the language was does not have
a userbase of many command-line program developers, as finding information
on file I/O was more difficult than it needed to be, and I found the
easiest way to print to standard error was through a libc function.

### Day 10

In progress.

### Day 11

If Clojure were my first Lisp dialect, I don't think I would have had a good
experience with the language.  Racket has substantially better new user
guides with the [Quick Introduction](https://docs.racket-lang.org/quick/) and
[The Racket Reference](https://docs.racket-lang.org/reference/) easily
accessible from the [Racket front page](https://racket-lang.org/).  Meanwhile,
Clojure only has the
["Learn Clojure guide"](https://clojure.org/guides/learn/clojure), which I
found inadequate in learning the language.  There is a
[community driven documentation](https://clojure-doc.org/articles/about/)
which I found to be very useful, but it's only listed under
["Other learning resources"](https://clojure.org/community/resources#_tutorials_and_learning_materials)
in ["Getting Started"](https://clojure.org/guides/getting_started).

Java, being the primary language of the JVM, is a language I don't enjoy using
much.  It is object-oriented to its core, and over time its (and the
industry standard) approach to object-oriented programming has grown less
favorable in my eyes over time.  The access to several useful data structures
from the standard library is extremely helpful, but I find several other things
like file I/O, basic structure definitions, and even the main method to be
overcomplicated due to Java's fundamental design.  Additionally, its
implementation of features such as generics and functional programming seem to
be handicapped by the language's history, as the former has weird edge cases
such as generic array instantiations needing to be casted, while the latter has
rules such as requiring functional interfaces for lambda instantiation.
I found Scala to be a more enjoyable language, as for example, the language
cleans up lambdas and adds tuples to make functional programming easier.
However, it's still heavily based on Java at the end of the day, which is
evident through its implementation of structures and the main method.

With all that said, I liked Clojure quite a bit.  The language is fundamentally
a Lisp rather than a Java-like, and with it being my second Lisp dialect, it
clicked with me much more than my first attempt with Racket.  Java interop is
a big part of the language, but Java doesn't heavily influence the fundamentals
of Clojure like it does for the likes of Scala.

### Day 12

In progress.

### Day 13

Hy is an interesting language to reflect on.  It seems to take many cues from
Clojure, but it's much more tightly integrated with Python than Clojure is
with Java, with Hy source code being directly compiled to Python ast objects.
It has some additional features, such as `with` expressions evaluating to
values, but its workflow is essentially the same as Python's in the form of a
Lisp.  I liked it, but until the language (and hopefully the REPL) develops
further, I think I'll stick with Python for anything I'd need Python for.
After all, Hy was only version 0.27 at the time of writing the solution for
day 13.

### Day 14

For better or worse, Lua is a fairly simple scripting language.  I wasn't
in love with the language, nor did I hate it to my core because table indexing
starts at 1.  I was pleasantly surprised how easy it is to implement and use
higher-order functions, and while I only used tables to implement arrays,
they seem much more powerful beyond the surface.

### Day 15

In progress.

### Day 16

In progress.

### Day 17

In progress.

### Day 18

In progress.

### Day 19

In progress.

### Day 20

In progress.

### Day 21

In progress.

### Day 22

In progress.

### Day 23

In progress.

### Day 24

In progress.

### Day 25

In progress.


## Usage

Disclaimer: all of the code in this repository was solely tested on
Kubuntu 22.04.  Some of the code will not work in Windows, and your mileage may
vary with other environments such as WSL, macOS, and BSD.  The code should at
least be architecture independent, except for day 6's MIPS assembly and
day 15's Arduino "server" code.

Clone the repository with

```
git clone https://github.com/WGeckle80/advent-of-code-2023.git
```

To run a particular day's solution, download the puzzle input file, and change
into the respective day's directory.  Install the required software for the
solution under the "Usage" section of the day's README.  Installation
instructions are not provided for most days because of potential user
preferences to install from a package manager, install in a sandboxed
environment such as Flatpak or Snap, run installation instructions from a
website, or compile from source.  After installation of a solution's required
software, run the remaining instructions under "Usage."

