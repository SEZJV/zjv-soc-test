#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#define UART16550A_DR (volatile unsigned char *)0x10000000

#include <stdarg.h>
#include <stddef.h>

int getchar(void);
int printf(const char *, ...);
int putchar(int);
int puts(const char *);
int snprintf(char *, size_t, const char *, ...);
int vprintf(const char *, va_list);
int vsnprintf(char *, size_t, const char *, va_list);
int printk(const char *, ...);
#ifdef __cplusplus
}
#endif
