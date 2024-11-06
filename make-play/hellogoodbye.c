// emcc -O2 -s NODERAWFS=1 hellogoodbye.c [-D GOODBYE]
#include <stdio.h>

int main() {
#ifndef GOODBYE
    printf("Hello world\n");
#else
    printf("Goodbye world\n");
#endif

    return 0;
}
