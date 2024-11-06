// emcc -O2 -s NODERAWFS=1 access.c

#define _GNU_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    printf("Calling an access function\n");
//    int result = access("./result.json", X_OK); // Works OK
//    int result = faccessat(AT_FDCWD, "./result.json", X_OK, AT_EACCESS); // Works OK
    int result = eaccess("./result.json", X_OK); // Also works OK
    printf("Called with result %d\n", result);
    return 0;
}

