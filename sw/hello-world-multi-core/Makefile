OBJECTS  = bootstrap.o main.o uart.o
CFLAGS   = -march=rv32i -mabi=ilp32
LDFLAGS  = -nostartfiles -Wl,--no-relax -T link.ld

VP       = microrv32-vp
VP_FLAGS = --entry-points="0x80000000,0x80001000,0x80002000,0x80003000,0x80004000"

hex: all
	../elf2bin.py ./main crc.hex 0x4020

include ../Makefile.common
