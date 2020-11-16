#include "encoding.h"
	.section .text
	.globl _start
	.align 4
_start:
	lui	a5,0x41000
	li	a4,-125
	sb	a4,15(a5)
	li	a4,27
	sb	a4,0(a5)
	sb	zero,5(a5)
	li	a4,3
	sb	a4,15(a5)

    addi t0, zero, 'S';   
	sb   t0, 0(a5);  
    addi t0, zero, 'T';   
	sb   t0, 0(a5);  
    addi t0, zero, 'A';   
	sb   t0, 0(a5);  
    addi t0, zero, 'R';   
	sb   t0, 0(a5);  
    addi t0, zero, 'T';   
	sb   t0, 0(a5);  
    addi t0, zero, '\n';   
	sb   t0, 0(a5);  

	li a0, DRAM_BASE
	la a1, _image_start
	la a2, _image_end
cpFlash2Ram:	
	beq a1, a2, gotoRam
	lw s0, 0(a1)
	sw s0, 0(a0)
	addi a1, a1, 4
	addi a0, a0, 4
	bne a1, a2, cpFlash2Ram

gotoRam:
	li  s0, UART_BASE;
    addi t0, zero, 'C';   
	sb   t0, 0(s0);     
    addi t0, zero, 'P';   
	sb   t0, 0(s0);     
    addi t0, zero, 'O';   
	sb   t0, 0(s0);     
    addi t0, zero, 'K';   
	sb   t0, 0(s0);
    addi t0, zero, '\n';   
	sb   t0, 0(s0);
	fence.i  
	li t0, DRAM_BASE
	jr t0




	.section .payload, "wa"
	.globl _image_start
	.globl _image_end
	.align 4
_image_start:
	.incbin IMG
_image_end:
