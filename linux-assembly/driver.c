#include "cdecl.h"
#include <sys/io.h>
#include <stdio.h>

int PRE_CDECL asm_main( void ) POST_CDECL;

int main()
{
    int ret_status;
    if (iopl(3) < 0) {
        printf("raise privilege failed!\n");
        return 1;
    }
    ret_status = asm_main();
    return ret_status;
}
