#include <stdint.h>
#include <stdio.h>
#include "platform.h"
#include "uart.h"
#include "util.h"

volatile uint32_t step = 0;

void wait_for_step(uint32_t expected_step) {
    while (step != expected_step);
}

void advance_step(void) {
    step++;
}

// Place each core entry function in a dedicated section

int core0_main_entry(void) __attribute__((section(".text.core0")));
int core1_main_entry(void) __attribute__((section(".text.core1")));
int core2_main_entry(void) __attribute__((section(".text.core2")));
int core3_main_entry(void) __attribute__((section(".text.core3")));
int core4_main_entry(void) __attribute__((section(".text.core4")));

int core0_main_entry(void)
{
	wait_for_step(0);
	sendString("Hello, RISC-V VP, by core[0]!\n", 31);
	advance_step();
    while (1);
    return 0;
}

int core1_main_entry(void)
{
	wait_for_step(1);
	sendString("Hello, RISC-V VP, by core[1]!\n", 31);
	advance_step();
    while (1);
    return 0;
}

int core2_main_entry(void)
{
	wait_for_step(2);
	sendString("Hello, RISC-V VP, by core[2]!\n", 31);
	advance_step();
    while (1);
    return 0;
}

int core3_main_entry(void)
{
	wait_for_step(3);
	sendString("Hello, RISC-V VP, by core[3]!\n", 31);
	advance_step();
    while (1);
    return 0;
}

int core4_main_entry(void)
{
	wait_for_step(4);
	sendString("Hello, RISC-V VP, by core[4]!\n", 31);
	advance_step();
	// while(1);
    return 0;
}

int main(int argc, char **argv) {
	return 0;
}
