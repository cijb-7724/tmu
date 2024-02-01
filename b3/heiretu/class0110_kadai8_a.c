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
    double pi = 0.0;
    double start, end;
    start = omp_get_wtime();
    for (i=0; i<n; ++i) {
        pi += (double)(pow(-1, i) / (double)(2*i+1));
    }
    end = omp_get_wtime();
    pi *= 4;
    printf("pi = %lf\n", pi);
    printf("\nProcessing Time : %.10lf [s]\n", (double)(end - start));
}
