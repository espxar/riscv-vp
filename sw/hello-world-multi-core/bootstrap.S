.globl main

.equ SYSCALL_ADDR, 0x02010000

.macro INIT_HW_PLATFORM
    and x1,x0,x0
    and x2,x0,x0
    and x3,x0,x0
    and x4,x0,x0
    and x5,x0,x0
    and x6,x0,x0
    and x7,x0,x0
    and x8,x0,x0
    and x9,x0,x0
    and x10,x0,x0
    and x11,x0,x0
    and x12,x0,x0
    and x13,x0,x0
    and x14,x0,x0
    and x15,x0,x0
    and x16,x0,x0
    and x17,x0,x0
    and x18,x0,x0
    and x19,x0,x0
    and x20,x0,x0
    and x21,x0,x0
    and x22,x0,x0
    and x23,x0,x0
    and x24,x0,x0
    and x25,x0,x0
    and x26,x0,x0
    and x27,x0,x0
    and x28,x0,x0
    and x29,x0,x0
    and x30,x0,x0
    and x31,x0,x0
.endm

.macro SYS_EXIT
    li   a7, 93
    li   t0, SYSCALL_ADDR
    csrr a6, mhartid
    sw   a6, 0(t0)
.endm


/* Core0 Entry Point */
.section .text.core0
.globl _start_core0
_start_core0:
    /* Initialize hardware for core0 */
    INIT_HW_PLATFORM
    la sp, stack_end_core0  /* Set stack pointer for core0 */
    /* Jump to main function for core0 */
    la a0, core0_main_entry
    jalr a0

    /* Exit core0 after it completes */
    SYS_EXIT

/* Core1 Entry Point */
.section .text.core1
.globl _start_core1
_start_core1:
    /* Initialize hardware for core1 */
    INIT_HW_PLATFORM
    la sp, stack_end_core1  /* Set stack pointer for core1 */
    /* Jump to main function for core1 */
    la a0, core1_main_entry
    jalr a0

    /* Exit core1 after it completes */
    SYS_EXIT

/* Core2 Entry Point */
.section .text.core2
.globl _start_core2
_start_core2:
    /* Initialize hardware for core2 */
    INIT_HW_PLATFORM
    la sp, stack_end_core2  /* Set stack pointer for core2 */
    /* Jump to main function for core2 */
    la a0, core2_main_entry
    jalr a0

    /* Exit core2 after it completes */
    SYS_EXIT

/* Core3 Entry Point */
.section .text.core3
.globl _start_core3
_start_core3:
    /* Initialize hardware for core3 */
    INIT_HW_PLATFORM
    la sp, stack_end_core3  /* Set stack pointer for core3 */
    /* Jump to main function for core3 */
    la a0, core3_main_entry
    jalr a0

    /* Exit core3 after it completes */
    SYS_EXIT

/* Core4 Entry Point */
.section .text.core4
.globl _start_core4
_start_core4:
    /* Initialize hardware for core4 */
    INIT_HW_PLATFORM
    la sp, stack_end_core4  /* Set stack pointer for core4 */
    /* Jump to main function for core4 */
    la a0, core4_main_entry
    jalr a0

    /* Exit core4 after it completes */
    SYS_EXIT

/* Stack space for each core */
stack_begin:
    .zero 1024            /* General stack for all cores (could be moved to per-core sections) */
stack_end_core0:
    .zero 1024            /* Stack for core0 */
stack_end_core1:
    .zero 1024            /* Stack for core1 */
stack_end_core2:
    .zero 1024            /* Stack for core2 */
stack_end_core3:
    .zero 1024            /* Stack for core3 */
stack_end_core4:
    .zero 1024            /* Stack for core4 */



