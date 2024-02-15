#include <stdio.h>
#include <omp.h>
/*
>gcc -o out test.c -fopenmp
*/
int main() {
    long long sum = 0;
    int exp = 13;
    double start, end;
    long long L = (long long)1<<exp;
    printf("L = 2^%d = %lld\n", exp, L);

    // 開始時間を記録
    printf("\nCalculation Start\n");
    start = omp_get_wtime();
   
    long long i, j;
    #pragma omp parallel private(sum) num_threads(16)
    {   
        #pragma omp for
        for (i=0; i<L; ++i) {
            for (j=0; j<L; ++j) {
                sum += (i-j)*(i-j);
            }
        }
    }
    // 終了時間を記録
    end = omp_get_wtime();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10lf [sec]\n", (double)(end - start));
    printf("sum = %lld\n", sum);
}




