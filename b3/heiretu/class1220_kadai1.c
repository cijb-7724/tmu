#include <omp.h>
#include <stdio.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/

#define Max 100000000
double start, end;
float a[Max];
float b[Max];
float c[Max];


int main() {
    long long i;
    int num_of_threads = 2;
    printf("num of threads = %d\n", num_of_threads);
    printf("\nCalculation Start\n");
    for (i=0; i<Max; ++i) {
        a[i] = i * 1.e0f;
        b[i] = i * 2.e0f;
    }
    
    #pragma omp parallel num_threads(num_of_threads)
    {
        start = omp_get_wtime();
        #pragma omp for
        for (i=0; i<Max; ++i) {
            c[i] = a[i] + b[i];
        }
        end = omp_get_wtime();
    }
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10f [s]\n", (double)(end-start));
    return 0;
}

