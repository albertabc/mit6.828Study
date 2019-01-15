# Lab 1: Solutions and Tips
---
## Exercise 3

### 1. At what point does the processor start executing 32-bit code? What exactly causes the switch from 16- to 32-bit mode?

The first 32-bit code is:
`movw $PROT_MODE_DSEG, %ax`
The following operations cause the switch from 16-bit to 32-bit mode.
```
	movl    %cr0, %eax
	orl     $CR0_PE_ON, %eax
	movl    %eax, %cr0
	ljmp    $PROT_MODE_CSEG, $protcseg
```
---

### 2.	What is the last instruction of the boot loader executed, and what is the first instruction of the kernel it just loaded?

The last instruction of the boot loader executed is:
`((void (*)(void)) (ELFHDR->e_entry))();`
This instruction will call the kernel to run

The first instruction of the kernel is:
`movw    $0x1234,0x472`
---

### 3. Where is the first instruction of the kernel?

There is no doubt it is 0x100000

Since now the page has not been enabled yet.
---

### 4. How does the boot loader decide how many sectors it must read in order to fetch the entire kernel from disk? Where does it find this information?

In fact, at the start of loading kernel, the boot loader does not know how many sectors should be loaded. It does this in seperate steps:

> * Load a whole page (4K size) to find the ELF Header
> * Find Program Header position and counts according to the ELF Header
> * Load the whole program parts into memory

There is no doubt boot loader finds the information in kernel ELF image.
---

## Exercise 4 (pointers.c output)

In fact, only 5 line results need a little interpretation. The key instruction is:
`c = (int *) ((char *) c + 1);`

> * First, "c" is forced to a char pointer, and "+1" means move only 1 byte.
> * Second, the new position is forced an integar pointer, so the "c" will represent the following 4 bytes.
---

## Exercise 5

I try to do some modification, and the machine cannot be booted.
---

## Exercise 6

### Examine the 8 words of memory at 0x00100000 at the point the BIOS enters the boot loader, and then again at the point the boot loader enters the kernel. Why are they different? What is there at the second breakpoint?

> * There is nothing first.
> * It is the kernel instructions machine code second.

They are different because there are 2 parts in boot loader. The 2nd part is to load kernel image into memory and give the control to the kernel. So at the 1st point, the kernel is not loaded yet, and 0x100000 is the location of the 1st instruction of kernel image.
---

## Exercise 7

### What is the first instruction after the new mapping is established that would fail to work properly if the mapping weren't in place? Comment out the movl %eax, %cr0 in kern/entry.S, trace into it, and see if you were right. 

`movl	$0x0,%ebp`
In fact, the above instruction will be __**faild**__.

But why?

In fact, $relcated is an address represents the beginning of building kernel stack. It is just like "0xf010002f". But if there is no new mapping, there is nothing at the location. So this is just like a null pointer. The whole kernel will crash.

But why the low address can work at first?

Because we hard code the RELOC to map the linear address to physical address.
---

## Exercise 8

### 1. Explain the interface between printf.c and console.c. Specifically, what function does console.c export? How is this function used by printf.c?

console.c is used to display something to the VGA. printf.c uses "cputchar()" offered by console.c.

### 2. Explain the following from console.c: 

```
1      if (crt_pos >= CRT_SIZE) {
2              int i;
3              memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
4              for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
5                      crt_buf[i] = 0x0700 | ' ';
6              crt_pos -= CRT_COLS;
7      }
```

The main target of this piece of code is to make an empty line at the last line of display monitor when the screen is full.

### 3. For the following questions you might wish to consult the notes for Lecture 2. These notes cover GCC's calling convention on the x86.

### Trace the execution of the following code step-by-step:
```
int x = 1, y = 3, z = 4;
cprintf("x %d, y %x, z %d\n", x, y, z);
```
### In the call to cprintf(), to what does fmt point? To what does ap point?
### List (in order of execution) each call to cons_putc, va_arg, and vcprintf. 
### For cons_putc, list its argument as well. For va_arg, list what ap points to before and after the call. For vcprintf list the values of its two arguments.

> * "fmt" means the formatted string : "x %d, y %x, z %d\n"
> * "ap" means variant parameters list: "x, y, z"
> * cons_putc: serial_putc, lpt_putc, cga_putc, its argument is "int c"
> * va_arg(ap, type), before ap = ap, after ap = ap - 1.


### 4. Run the following code.
```
    unsigned int i = 0x00646c72;
	cprintf("H%x Wo%s", 57616, &i);
```
### What is the output? Explain how this output is arrived at?

> * It is "He110, World"
> * 57616 its hex is e110. So the first is "He110"
> * As little endian, the i memory layout is 0x72 0x6c 0x64 0x00 = r l d .

### 5. In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?
```
    cprintf("x=%d y=%d", 3);
```

> * y = ? is not a specific value. It depends on the content above "3" in the stack.

### 6. Let's say that GCC changed its calling convention so that it pushed arguments on the stack in declaration order, so that the last argument is pushed last. How would you have to change cprintf or its interface so that it would still be possible to pass it a variable number of arguments? 


### 7. Challenge

> * Add color
> * But I cannot add pictures. (It will require a lot of extra time)
----

## Exercise 9

### Determine where the kernel initializes its stack, and exactly where in memory its stack is located. How does the kernel reserve space for its stack? And at which "end" of this reserved area is the stack pointer initialized to point to? 

```
movl    $0x0,%ebp
movl    $(bootstacktop),%esp
```

> * The above code initializes its stack.
> * The stack locates in .data section. And its top is "bootstacktop", which is "0xf0110000"
> * The stack size is 8 * 4KB = 32KB
> * The esp points to 0xf011000 first. And it aligns the direction of the stack grow up.
> * The end of the stack is 0xf008000.
---

## Exercise 10, 11, 12

They are included in the 0001-lab-lab1-answers.patch.

How to jusitfy the end of the backtrace?

The clue is in the kern/entry.S.
```
movl $0x0, %ebp
```
So when the read_ebp() returns 0, it means the end.
