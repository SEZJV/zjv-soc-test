// See LICENSE for license details.

#include <stdio.h>


char* err = "Printf buffer overflow !\n";

int vprintf(const char* s, va_list vl)
{
    char buf[100];
    char *out;
    int res = vsnprintf(NULL, -1, s, vl);
    if (res >= 99) out = err;
    else out = buf;
    vsnprintf(out, res + 1, s, vl);
    while (*out) putchar(*out++);
    return res;
}
