#include <omp.h>
#include <stdio.h>

void HelloWorld() {
    int i;
    #pragma omp parallel num_threads(4)
    {
        #pragma omp for
        for (i = 0; i < 32; ++i) {
            // printf("Hello %d\n", i);
            // printf("omp get thread num : %d\n", omp_get_thread_num());
            // printf("omp get num threads: %d\n", omp_get_num_threads());
            printf("Hello %d @ %d of %d\n", i,
            omp_get_thread_num(),
            omp_get_num_threads()
            );
        }
    }
}

int main() {
    HelloWorld();
    return 0;
}