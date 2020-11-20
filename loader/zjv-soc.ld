OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY {
  flash (xa!ri)  : ORIGIN = 0x40000000, LENGTH = 16M
  ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 64M
}

SECTIONS {
  . = ORIGIN(flash);
  _start = .;
  . = ALIGN(0x1000);
  
  .text : {
  	*(.text .text.*)
	} 

  . = ALIGN(0x1000);
	.payload : { 
  	*(.payload)
	} 

  _end = .;
}

