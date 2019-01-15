# Homework  1: Boot xv6

---
## Exercise

### 1. Begin by restarting qemu and gdb, and set a break-point at 0x7c00, the start of the boot block (bootasm.S). Single step through the instructions (type si at the gdb prompt). Where in bootasm.S is the stack pointer initialized? (Single step until you see an instruction that moves a value into %esp, the register for the stack pointer.)

In bootasm.S

`movl $start, %esp`

The above piece of code is to build boot loader its own stack of the 2nd part, which is c part.

### 2. Single step through the call to bootmain; what is on the stack now?

Some environments (eip, saved ebp) before bootmain call. And some bootmain local variables.

### 3. What do the first assembly instructions of bootmain do to the stack? Look for bootmain in bootblock.asm.

```
7d3b:   55                      push   %ebp
7d3c:   89 e5                   mov    %esp,%ebp
7d3e:   57                      push   %edi
7d3f:   56                      push   %esi
7d40:   53                      push   %ebx
7d41:   83 ec 0c                sub    $0xc,%esp
```

The above is the piece of code when it enters bootmain.

### 4. Continue tracing via gdb (using breakpoints if necessary -- see hint below) and look for the call that changes eip to 0x10000c. What does that call do to the stack? (Hint: Think about what this call is trying to accomplish in the boot sequence and try to identify this point in bootmain.c, and the corresponding instruction in the bootmain code in bootblock.asm. This might help you set suitable breakpoints to speed things up.)

In fact, I confused this issue a little. I cannot decide what the real of the issue is.

I answer it as the function of "call xxx" directive

call xxx <=>
```
pushl %eip
movl $xxx, %eip
```
