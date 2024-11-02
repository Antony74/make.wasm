
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    char sz[100];
    getcwd(sz, 100);
    printf("Current working directory is %s\n", sz);
    return EXIT_SUCCESS;
}
