OUTPUT_ARCH( "riscv" )
ENTRY(_start)

/* MEMORY {
  flash (rxa)  : ORIGIN = 0x40000000, LENGTH = 16M
  ram   (rwxa) : ORIGIN = 0x80000000, LENGTH = 64M
} */

SECTIONS {
  . = 0x80000000;
  _start = .;

  . = ALIGN(0x1000);
  .text : { *(.text .text.*) }

  . = ALIGN(0x1000);
  .rodata : { *(.rodata .rodata.*) }
  
  . = ALIGN(0x1000);
  .data : { *(.data .data.*) }

  . = ALIGN(0x1000);
  .bss : { *(.bss .bbs.*) }

  _end = .;
}

