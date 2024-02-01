#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*
>gcc -o out test.c -fopenmp
*/

int main() {
    #pragma omp parallel num_threads(16)
    {
        #pragma omp sections
        {
            //
            #pragma omp section
            // #pragma omp parallel num_threads(4)
            {
                printf("section0 @ %d of %d\n",
                omp_get_thread_num(),
                omp_get_num_threads()
                );
            }
            #pragma omp section
            // #pragma omp parallel num_threads(8)
            {
                printf("section1 @ %d of %d\n",
                omp_get_thread_num(),
                omp_get_num_threads()
                );
            }
            #pragma omp section
            // #pragma omp parallel num_threads(16)
            {
                printf("section2 @ %d of %d\n",
                omp_get_thread_num(),
                omp_get_num_threads()
                );
            }
        }
    }
}
