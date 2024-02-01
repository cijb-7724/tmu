#include <omp.h>
#include <stdio.h>
/*
>gcc -o out class1129_kadai1.c -fopenmp
*/
int main() {
    const int n = 32;
    int i;
    double a[32], b[32], c[32];
    #pragma omp parallel num_threads(32)
    {
        #pragma omp for
        for (i=0; i<n; ++i) {
            // a[i] = i * 1.e0f;
            // b[i] = i * 2.e0f;
            a[i] = i * 1;
            b[i] = i * 2;
        }
        #pragma omp for
        for (i=0; i<n; ++i) {
            c[i] = a[i] + b[i];
            printf("c[%2d] is : %5.2lf @ %2d of %2d\n",
            i,
            c[i],
            omp_get_thread_num(),
            omp_get_num_threads()
            );
        }
    }
    return 0;
}

