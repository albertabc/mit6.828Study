# Appendix B
---

## Exercises
---

### 1. Due to sector granularity, the call to readseg in the text is equivalent to readset((uchar*)0x100000, 0xb500, 0x1000). In practice, this sloppy behavior turns out not to be a problem. Why doesn't the sloppy readsect cause problems?

I do not know the solution of this issue.(?)
---

### 2. Suppose you wanted bootmain() to load the kernel at 0x200000 instead of 0x100000, and you did so by modifying bootmain() to add 0x100000 to the va of each ELF section. Something would go wrong. What?

I modify the following code:
`readseg(pa, ph->filesz, ph->off);`
to
`readseg(pa + 0x100000, ph->filesz, ph->off);`

And machine cannot boot up. This mainly because the program will still find the instruction at 0x100000, but there is nothing there.

But if I only modify the kernel.ld, 0x100000 -> 0x200000 and 0x80100000 -> 0x80200000. It works.

This indicates that the selection of loading address 0x100000 is arbitrary.
---

### 3. It seems potentially dangerous for the boot loader to copy the ELF header to memory at the arbitrary location 0x100000. Why doesn't it call malloc to obtain the memory it needs?

I am not sure I can answer this issue or not.

> * 0x100000 seems dangerous but in fact, it is not. It depends on the programer to arrange the memory to make sure there is no memory overlap.
> * kernel has not been loaded. Though the malloc is implemented yet, it still requires to consider how to arrange the memory layout.
