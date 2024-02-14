#include <stdio.h>

__global__ void helloThread() {
    printf("hello thread. %d %d\n", blockIdx.x, threadIdx.x);
    printf("%d \n", blockIdx.x * blockDim.x + threadIdx.x);
}
int main() {
    helloThread<<<2, 4>>>();
    cudaDeviceSynchronize();
    return 0;
}