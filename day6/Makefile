AS = mips-linux-gnu-as
CC = mips-linux-gnu-gcc
ASFLAGS = -g
LDFLAGS = -nostdlib -static

.PHONY: clean

race: race.o print.o read.o string.o helpers.o
	$(CC) $(LDFLAGS) -o race race.o print.o read.o string.o helpers.o

race.o: src/race.S
	$(AS) $(ASFLAGS) -o race.o src/race.S

print.o: src/print.S
	$(AS) $(ASFLAGS) -o print.o src/print.S

read.o: src/read.S
	$(AS) $(ASFLAGS) -o read.o src/read.S

string.o: src/string.S
	$(AS) $(ASFLAGS) -o string.o src/string.S

helpers.o: src/helpers.S
	$(AS) $(ASFLAGS) -o helpers.o src/helpers.S

clean:
	rm -f race *.o

