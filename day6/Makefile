AS = mips-linux-gnu-as
CC = mips-linux-gnu-gcc
ASFLAGS = -g
LDFLAGS = -nostdlib -static

.PHONY: clean

race: race.o print.o read.o string.o
	$(CC) $(LDFLAGS) -o race race.o print.o read.o string.o

race.o: race.S
	$(AS) $(ASFLAGS) -o race.o race.S

print.o: print.S
	$(AS) $(ASFLAGS) -o print.o print.S

read.o: read.S
	$(AS) $(ASFLAGS) -o read.o read.S

string.o: string.S
	$(AS) $(ASFLAGS) -o string.o string.S

clean:
	rm -f race *.o

