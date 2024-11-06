// emcc -O2 -s NODERAWFS=1 hello.c

#define _GNU_SOURCE

#include <stdio.h>
#include <spawn.h>

int main() {
    printf("Hello world\n");

    return 0;
}
