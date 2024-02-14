#include <stdio.h>

#define grid 1e4
#define block 1e3

__global__ void vecAdd(double *Ad, double *Bd, double *Cd) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    Cd[i] = Ad[i] + Bd[i];
}


int main() {
    cudaSetDevice(0);
    double *A, *Ad, *B, *Bd, *C, *Cd;;
    int i, N = Grid*block, size = grid*block*sizeof(double):
}