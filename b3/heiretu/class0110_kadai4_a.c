#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

/*
>gcc -o out test.c -fopenmp
*/

int main(int argc, char* argv[]) {
    float x=1.0f, y=2.0f, z=3.0f;
    float **a, **b, **c, **hc;
    double start, end;
    int i, j, m = omp_get_max_threads(), n = 2048;

    if (argc > 1) {
        n = atoi(argv[1]);
        m = atoi(argv[2]);
    }
    fprintf(stdout, "matrix size = %d x %d\n", n, n);
    fprintf(stdout, "num_thread = %d\n", m);    

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
    start = omp_get_wtime();
    // calc
    float cc;
    #pragma omp parallel num_threads(1)
    {
        #pragma omp for private(j)
        for (i=0; i<n; ++i) {
            for (j=0; j<n; j+=2) {
                hc[i][j] = a[i][j] + b[i][j];
                hc[i][j+1] = a[i][j+1] + b[i][j+1];
            }
        }
    }
    end = omp_get_wtime();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10lf [s]\n", (double)(end-start));

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
