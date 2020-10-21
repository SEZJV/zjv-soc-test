// See LICENSE for license details.

#include <stdio.h>

int putchar(int ch)
{
    return *UART16550A_DR = ch;
}
