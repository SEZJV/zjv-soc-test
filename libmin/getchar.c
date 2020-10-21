// See LICENSE for license details.

#include <stdio.h>

int getchar()
{
    return *UART16550A_DR;
}
