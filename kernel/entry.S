        # qemu -kernel loads the kernel at 0x80000000
        # and causes each hart (i.e. CPU) to jump there.
        # kernel.ld causes the following code to
        # be placed at 0x80000000.
.section .text
.global _entry
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + (hartid * 4096)
        la sp, stack0
        li a0, 1024*4 //load 4KB stack in a0
        csrr a1, mhartid //reading hartid - hrdware thread ID it's basically a core -  from a1 register
        addi a1, a1, 1 //Adding 1 to the hartid to increase the stack size for each core
        mul a0, a0, a1 //multiplying the stack size with the hartid
        add sp, sp, a0 //adding the stack size to the stack pointer
        # jump to start() in start.c
        call start
        # should never get here
spin:
        j spin
