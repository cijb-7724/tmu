#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/
#define N 10000000
double a[N];

int main() {
    int i;
    double sum=0;
    double start, end;
    for (i=0; i<N; ++i) {
        a[i] = i * 0.01;
    }
    printf("\nCalculation start\n");
    start = omp_get_wtime();
    #pragma omp parallel private(sum) num_threads(8)
    {   
        #pragma omp for
        for (i=0; i<N; ++i) {
            sum += a[i];
        }
    }
    end = omp_get_wtime();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10lf [s]\n", (double)(end-start));
    printf("sum = %lf\n", sum);
    return 0;
}
