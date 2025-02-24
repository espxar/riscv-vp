#include <stdint.h>
#include <stdio.h>
#include "platform.h"
#include "uart.h"
#include "util.h"

int main(int argc, char **argv) {
	sendString("Hello, RISC-V VP!\n", 19);
	return 0;
}
