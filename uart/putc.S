# See LICENSE for license details.

#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "encoding.h"
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_BARE_CODE_BEGIN

	li  s0, UART_BASE

	addi t0, zero, 'H'
	sw   t0, 4(s0)
	addi t0, zero, 'e'
	sw   t0, 4(s0)
	addi t0, zero, 'l'
	sw   t0, 4(s0)
	addi t0, zero, 'l'
	sw   t0, 4(s0)
	addi t0, zero, 'o'
	sw   t0, 4(s0)
	addi t0, zero, ','
	sw   t0, 4(s0)
	addi t0, zero, ' '
	sw   t0, 4(s0)
	addi t0, zero, 'Z'
	sw   t0, 4(s0)
	addi t0, zero, 'J'
	sw   t0, 4(s0)
	addi t0, zero, 'V'
	sw   t0, 4(s0)
	addi t0, zero, '!'
	sw   t0, 4(s0)	
	addi t0, zero, '\r'
	sw   t0, 4(s0)
	addi t0, zero, '\n'
	sw   t0, 4(s0)

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
