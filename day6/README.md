## Overview

### Part One



### Part Two




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
qemu-mips test <puzzle-input-file>
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

