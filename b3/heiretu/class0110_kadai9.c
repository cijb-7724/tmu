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
    int i, j;
    double pi = 0.0;
    double start, end;
    start = omp_get_wtime();
    #pragma omp parallel private(j) num_threads(8)
    {
        #pragma omp for reduction(+:pi)
        for (i=0; i<n; i += 100) {
            // pi += (double)(pow(-1, i) / (double)(2*i+1));
            // pi += (double)(pow(-1, i+1) / (double)(2*(i+1)+1));
            // pi += (double)(pow(-1, i+2) / (double)(2*(i+2)+1));
            // pi += (double)(pow(-1, i+3) / (double)(2*(i+3)+1));
            // pi += (double)(pow(-1, i+4) / (double)(2*(i+4)+1));
            // pi += (double)(pow(-1, i+5) / (double)(2*(i+5)+1));
            // pi += (double)(pow(-1, i+6) / (double)(2*(i+6)+1));
            // pi += (double)(pow(-1, i+7) / (double)(2*(i+7)+1));
            // pi += (double)(pow(-1, i+8) / (double)(2*(i+8)+1));
            // pi += (double)(pow(-1, i+9) / (double)(2*(i+9)+1));
            for (j=0; j<100; ++j) {
                pi += (double)(pow(-1, i+j) / (double)(2*(i+j)+1));
            }
        }

    }
    end = omp_get_wtime();
    pi *= 4;
    printf("pi = %lf\n", pi);
    printf("\nProcessing Time : %.10lf [s]\n", (double)(end - start));
}
