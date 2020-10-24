#include "stdio.h"

#define PLIC_PRIO_BASE    0x0C000000
#define PLIC_IE_BASE      0x0C002000
#define PLIC_UART_IRQ 10


int start_kernel() {
	const char *msg = "ZJU OS LAB 2             GROUP-XX\n\n";


	*(int *)(PLIC_PRIO_BASE+4*PLIC_UART_IRQ) = 1;
	*(int *)(PLIC_IE_BASE) = 1 << PLIC_UART_IRQ;

    printf(msg);
	while(1) ;

	return 0;
}
