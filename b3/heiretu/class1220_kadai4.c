#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/

#define Max 10000
double start, end;
int main(int argc, char *argv[]) {
    float **a, **b, **c, **hc;
    double start, end;
    int i, j, n = 1024;
    if (argc > 1) n = atoi(argv[1]);

    fprintf(stdout, "matrix size = %d x %d\n", n, n);

    a = (float **) malloc(sizeof(float *) * n);
    b = (float **) malloc(sizeof(float *) * n);
    hc = (float **) malloc(sizeof(float *) * n);
    for (i=0; i<n; ++i) {
        a[i] = (float *)malloc(sizeof(float) * n);
        b[i] = (float *)malloc(sizeof(float) * n);
        hc[i] = (float *)malloc(sizeof(float) * n);
    }

    for (i=0; i<n; ++i) for (j=0; j<n; ++j) {
        a[i][j] = (float)(rand() / 4096);
        b[i][j] = (float)(rand() / 4096); 
    }
    //
    #pragma omp parallel num_threads(4)
    {   
        start = omp_get_wtime();
        #pragma omp for private(i)
        for (j=0; j<n; ++j) {
            for (i=0; i<n; ++i) {
                hc[i][j] = a[i][j] + b[i][j];
            }
        }
        end = omp_get_wtime();
    }
    
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.5lf [s]\n", (double)(end-start));
    
    for (i=0; i<n; ++i) {
        free(a[i]);
        free(b[i]);
        free(hc[i]);
    }
    free(a);
    free(b);
    free(hc);
    return 0;
}
