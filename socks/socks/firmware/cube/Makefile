CC=sparc-rtems-gcc
CFLAGS=-O2 -g
LDFLAGS=-g -N -nostdlib  -T ./linkleon -e _hardreset locore1.o 
LIBS=-L/opt/rtems/sparc-rtems/lib -lgcc -lm

all: tests
tests: locore1.o leon_test.exe simfiles

simfiles: ram.dat rom.dat
ram.dat: leon_test.exe
	sparc-rtems-objcopy --remove-section=.comment leon_test.exe
	sparc-rtems-objdump -s leon_test.exe > ram.dat
	sparc-rtems-objdump -d leon_test.exe > ram.s
	sparc-rtems-size leon_test.exe

rom.dat: boot.exe
	sparc-rtems-objdump -s boot.exe > rom.dat
	sparc-rtems-objdump -d boot.exe > rom.s
	sparc-rtems-size boot.exe

boot.exe: boot.o
	sparc-rtems-gcc -N -nostdlib -nostdinclude -T linkboot -e _hardreset boot.o -o boot.exe

leon_test.exe : leon_test.o misc.o 
	$(CC) $(LDFLAGS)    leon_test.o  misc.o $(LIBS) -o leon_test.exe
	cp leon_test.exe lt
	sparc-rtems-strip leon_test.exe

clean:
	-rm lt *.exe *.o *.s

# DO NOT DELETE

leon_test.o: leon.h test.h locore1.o
misc.o: leon.h
