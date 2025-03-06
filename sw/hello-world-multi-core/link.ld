OUTPUT_ARCH("riscv")
/* Define the entry point for core0 */
ENTRY(_start_core0)

SECTIONS
{
  /* Core 0 entry at 0x80000000 */
  . = 0x80000000;
  .text.core0 : {
    KEEP(*(.text.core0))
  }

  /* Core 1 entry at 0x80001000 */
  . = 0x80001000;
  .text.core1 : {
    KEEP(*(.text.core1))
  }

  /* Core 2 entry at 0x80002000 */
  . = 0x80002000;
  .text.core2 : {
    KEEP(*(.text.core2))
  }

  /* Core 3 entry at 0x80003000 */
  . = 0x80003000;
  .text.core3 : {
    KEEP(*(.text.core3))
  }

  /* Core 4 entry at 0x80004000 */
  . = 0x80004000;
  .text.core4 : {
    KEEP(*(.text.core4))
  }

  /* Common text section, e.g., shared startup code */
  . = ALIGN(0x1000);
  .text.common : { *(.text.common) }

  /* Original sections from your single core linker script */
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  
  . = ALIGN(0x1000);
  .text : { *(.text) }  /* other text sections not explicitly placed */
  
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .bss : { *(.bss) }
  
  _end = .;
}
