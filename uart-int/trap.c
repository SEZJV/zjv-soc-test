#include "stdio.h"
#include "encoding.h"

#define PLIC_CONTEXT_BASE    0x0C200000
#define PLIC_UART_IRQ 1

typedef unsigned int uint32_t;
typedef unsigned long int reg_t;

void trap_handler(reg_t cause, reg_t epc) {
	reg_t is_interrupt = cause & (1UL << (64 - 1));
	cause &= ~(1UL << (64 - 1));
	if (is_interrupt) {
		switch(cause) {
			case IRQ_M_EXT:
			  printf("External Interrupt\n");
			  uint32_t* irq = (uint32_t *)(PLIC_CONTEXT_BASE+4);
			  if (*irq == PLIC_UART_IRQ) {
				char c = getchar();
				printf("[%c]\n", c);
				*irq = PLIC_UART_IRQ;
			  }
			  else 
			  	printf("Unknown irq % d\n", irq);
			  break;
			default:
			  printf("Other Interrupt % d\n", cause);
	      }
	}
	else {
		printf("Exception\n");
    }
}
