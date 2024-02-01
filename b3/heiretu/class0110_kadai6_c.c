#include <omp.h>
#include <stdio.h>

#define n 10000000
double a[n];

/*
>gcc -o out test.c -fopenmp
*/

int main(int argc, char* argv[]) {
    int i;
    double sum = 0, tsum = 0;
    double start, end;
    for (i=0; i<n; ++i) {
        a[i] = (double)i * 0.01;
    }
    printf("reduction");
    printf("\nCalculation Start\n");
    start = omp_get_wtime();
    //reduction
    #pragma omp parallel num_threads(8)
    {
        #pragma omp for reduction(+:sum)
        for (i=0; i<n; ++i)
        {
            sum += a[i];
            // if (i == 100)
            //     exit(0);
        }
        printf(" thread=%d, sum=%lf.\n", omp_get_thread_num(), sum);
        
    }
    

    end = omp_get_wtime();

    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10lf [s]\n", (double)(end - start));
    
    //result
    printf("sum = %lf\n", sum);
    return 0;
}
