#include <stdio.h>
#include <stdlib.h>

int main() {
    // Open the file "AUTHORS" in read mode
    FILE *file = fopen("AUTHORS", "r");

    // Check if the file was successfully opened
    if (file == NULL) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    // Read and print each character from the file until end-of-file is reached
    char ch;
    while ((ch = fgetc(file)) != EOF) {
        putchar(ch);
    }

    // Close the file after reading
    fclose(file);

    return EXIT_SUCCESS;
}
