#include <omp.h>
#include <math.h>
#include <time.h>
#include <stdio.h>

#define n 10000000
double a[n];

/*
>gcc -o out test.c -fopenmp
*/

int main(int argc, char* argv[]) {
    int i;
    float pi = 0.0f;
    for (i=0; i<n; ++i) {
        pi += (float)(pow(-1, i) / (float)(2*i+1));
    }
    pi *= 4;
    printf("pi = %f\n", pi);
}
