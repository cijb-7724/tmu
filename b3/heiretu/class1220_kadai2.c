#include <omp.h>
#include <stdio.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/

#define Max 10000
double start, end;
float a[Max][Max];
float b[Max][Max];
float c[Max][Max];


int main() {
    int i, j;
    printf("\nCalculation Start\n");
    #pragma omp parallel num_threads(4)
    {
        #pragma omp for private(j)
        for (i=0; i<Max; ++i) {
            for(j=0; j<Max; ++j) {
                a[i][j] = i*j*1.e0f;
                b[i][j] = i*j*2.e0f;
            }
        }
        start = omp_get_wtime();
        #pragma omp for private(j)
        for (i=0; i<Max; ++i) {
            for(j=0; j<Max; ++j) {
                c[i][j] = a[i][j] + b[i][j];
            }
        }
        end = omp_get_wtime();
    }
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10f [s]\n", (double)(end-start));
    printf("c[100][100] = %lf\n", c[100][100]);

    return 0;
}

