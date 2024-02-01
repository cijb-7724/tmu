#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main() {
    float *a;
    a = malloc(sizeof(float) * 1024*1024*10);
    a[0] = 1.0;
    printf("a[0]=%.5f\n", a[0]);
    free(a);
    return 0;
}