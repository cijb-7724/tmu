#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/

int main(int argc, char* argv[]) {
    float **a, **b, **c, **hc;
    clock_t start, end;
    int i, j, k, n = 256;

    if (argc > 1) {
        n = atoi(argv[1]);
    }
    fprintf(stdout, "matrix size = %d x %d\n", n, n);

    a = (float **) malloc(sizeof(float *) * n);
    b = (float **) malloc(sizeof(float *) * n);
    hc = (float **) malloc(sizeof(float *) * n);
    for (i=0; i<n; ++i) { 
        a[i] = (float *) malloc(sizeof(float *) * n);
        b[i] = (float *) malloc(sizeof(float *) * n);
        hc[i] = (float *) malloc(sizeof(float *) * n);
    }

    for (i=0; i<n; ++i) {
        for (j=0; j<n; ++j) {
            a[i][j] = (float)(rand() / 4096);
            b[i][j] = (float)(rand() / 4096);
            
        }
    }
    start = clock();
    // calc
    float cc;
    #pragma omp parallel private(cc) num_threads(32)
    {
        #pragma omp for private(j, k)
        for (i=0; i<n; ++i) {
            for (j=0; j<n; ++j) {
                cc = 0.0f;
                for (k=0; k<n; ++k) {
                    cc += a[i][k] * b[k][j];
                }
                hc[i][j] = cc;
            }
        }
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.5f [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

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
