#include "riscv_test.h"
#include "test_macros.h"

# riscv64-unknown-elf-objdump -d build/test/rv64uc_cross-page

RVTEST_RV64M
RVTEST_CODE_BEGIN

  .option norvc

  # use add $0, $0, $0 to fill almost 1 page
  # TODO in fact, 925 can be calculated by the difference of 2 labels
  .set n, 0
  .rept 925
    add zero, zero, zero
    .set n, n + 1
  .endr

  # 3rd entry of f_pgt_1 is (s_pgt_1 << 10) | PTE_D | PTE_V | PTE_U | PTE_A
  la a1, f_pgt_1
  la a2, s_pgt_1
  srli a2, a2, 2
  ld t0, 16(a1)
  or t0, t0, a2
  sd t0, 16(a1)

  # 1st entry of s_pgt_1 (t_pgt_1 << 10) | PTE_D | PTE_V | PTE_U | PTE_A
  la a1, s_pgt_1
  la a2, t_pgt_1
  srli a2, a2, 2
  ld t0, 0(a1)
  or t0, t0, a2
  sd t0, 0(a1)
  sfence.vma

  li a1, ((MSTATUS_MPP & ~(MSTATUS_MPP<<1)) * PRV_S) | MSTATUS_MPRV
  csrs mstatus, a1
  la a1, c_inst
  csrw mepc, a1
  mret

c_inst:
  .option rvc
  c.nop

  .option norvc

  # set the first page table's ppn to satp
  # here no need to add sfence.vma
  li a0, (SATP_MODE & ~(SATP_MODE<<1)) * SATP_MODE_SV39
  la a1, f_pgt_1
  srl a1, a1, RISCV_PGSHIFT
  or tp, a1, a0
  csrw satp, tp

  # the cross-page inst will cause 2 different inst page faults
  addi gp, zero, 1

  TEST_PASSFAIL

  .align 2
  .global mtvec_handler
mtvec_handler:
  # only deal with inst pf of 2 different cases, otherwise just loop
  # no need to save regs, cause, scratch, epc and other context
  # just for fun
  add t0, zero, zero
  add t0, zero, zero
  add t0, zero, zero
  add t0, zero, zero
  add t0, zero, zero
  csrw satp, zero
  csrr t0, mcause
  add t0, t0, -CAUSE_FETCH_PAGE_FAULT
dead_loop:  
  bnez t0, dead_loop
  csrr t0, mtval
  # no need to walk, just see 8000,0000 or 8000,1000
  srli t0, t0, 12
  la a1, t_pgt_1
  li t1, 0x80000
  bne t0, t1, map_second
map_first:
  ld t0, 0(a1)
  ori t0, t0, PTE_V
  sd t0, 0(a1)
  j after_map
map_second:
  ld t0, 8(a1)
  ori t0, t0, PTE_V
  sd t0, 8(a1)
after_map:
  csrw satp, tp
  mret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  # page table 1 80000000->80000000
  # the first inst pf is caused by the lower 16 bits, the second pf is caused by the upper
  .align 12

  # 0x4000,0000 bytes per entry
  f_pgt_1:
    # for device poweroff
    .quad (0x00000 << 10) | PTE_D | PTE_V | PTE_A | PTE_R | PTE_W
    .quad 0
    # 0x8000,0000->0x8000,0000 for 0x4000,0000 bytes
    # (s_pgt_1 << 10) | PTE_D | PTE_V | PTE_U | PTE_A
    .quad PTE_D | PTE_V | PTE_A
    .zero 509 * 8

  # 0x20,0000 bytes per entry
  s_pgt_1:
    # (t_pgt_1 << 10) | PTE_D | PTE_V | PTE_U | PTE_A
    .quad PTE_D | PTE_V | PTE_A
    .zero 511 * 8

  # 0x1000 bytes per entry
  # not valid at the start, handled in trap handler
  t_pgt_1:
    # for 0x8000,0000
    .quad (0x80000 << 10) | PTE_D | PTE_R | PTE_W | PTE_X | PTE_A
    # for 0x8000,1000
    .quad (0x80001 << 10) | PTE_D | PTE_R | PTE_W | PTE_X | PTE_A
    .zero 510 * 8

RVTEST_DATA_END