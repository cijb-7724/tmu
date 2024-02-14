#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <cuda.h>
#include <cuda_runtime.h>

#define grid 64
#define block 32

#define Nx block*grid
#define Ny block*grid


#define Db_x block
#define Db_y 1
#define Db_z 1

#define Dg_x (Nx / Db_x)
#define Dg_y (Ny / Db_y)
#define Dg_z 1

dim3 Db(Db_x, Db_y, Db_z);
dim3 Dg(Dg_x, Dg_y, Dg_z);

cudaEvent_t start, end;
float timer;

// __global__ void adder(int *vecd) {
//     int i = blockIdx.x * blockDim.x + threadIdx.x;
// 	int j = blockIdx.y * blockDim.y + threadIdx.y;
//     vecd[i*grid*block+j] = (i-j)*(i-j);
// }
__global__ void mult_matrix(int *a, int *b, int *c) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;
    for (int k=0; k<grid*block; ++k) {
        c[i*grid*block + j] += a[grid*block*i+k]*b[grid*block*k+j];
        // c[0] += 1;
    }
}


int main(int argc, char **argv) {
    cudaSetDevice(0);

    // int *vec, *vecd;
    int *a, *b, *c;
    int *ad, *bd, *cd;
    int n = grid * block;  // データの数
    int size = n * n * sizeof(int); // データのサイズ

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    printf("matrix multi\n");
    printf("\nCalculation Start\n");

    // vec = (int *)malloc(size);  // ホストメモリの確保
    a = (int *) malloc(size);
    b = (int *) malloc(size);
    c = (int *) malloc(size);

    for (int i=0; i<n*n; ++i) {
        a[i] = b[i] = 1;
        c[i] = 0;
    }
    

    // cudaMalloc(&vecd, size);  // デバイスメモリの確保
	// cudaMemcpy(vecd, vec, size, cudaMemcpyHostToDevice);
    // cudaEventRecord(start, 0);

    cudaMalloc(&ad, size);
    cudaMalloc(&bd, size);
    cudaMalloc(&cd, size);
    cudaMemcpy(ad, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(bd, b, size, cudaMemcpyHostToDevice);
    cudaMemcpy(cd, c, size, cudaMemcpyHostToDevice);

    cudaEventRecord(start, 0);
    

    mult_matrix<<<Dg, Db>>>(ad, bd, cd);

    // cudaMemcpy(vec, vecd, size, cudaMemcpyDeviceToHost);  // 結果のデバイスからホストへのコピー
    cudaMemcpy(a, ad, size, cudaMemcpyDeviceToHost);
    cudaMemcpy(b, bd, size, cudaMemcpyDeviceToHost);
    cudaMemcpy(c, cd, size, cudaMemcpyDeviceToHost);

    // long long sum = 0;
    // for (int i = 0; i < n*n; ++i) {
    //     sum += vec[i];  // 結果の計算
    // }
    // printf("sum = %lld\n", sum);
    printf("c[%d][%d] = %d\n", 0, 0, c[0]);
    printf("c[%d][%d] = %d\n", n-1, n-1, c[n*n-1]);
    

    

    cudaEventRecord(end, 0);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer);

    cudaEventDestroy(start);
    cudaEventDestroy(end);

    // free(vec);
    // cudaFree(vecd);

    free(a);
    free(b);
    free(c);
    cudaFree(ad);
    cudaFree(bd);
    cudaFree(cd);
    

    return 0;
}
