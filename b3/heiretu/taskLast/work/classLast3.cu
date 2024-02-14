#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <cuda.h>
#include <cuda_runtime.h>

#define grid 128
#define block 64

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

__global__ void adder(long *vecd) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;
    vecd[i*grid*block+j] = (i-j)*(i-j);
}

int main(int argc, char **argv) {
    cudaSetDevice(0);

    long *vec, *vecd;
    int n = grid * block;  // データの数
    int size = n * n * sizeof(long); // データのサイズ

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    printf("\nCalculation Start\n");

    vec = (long *)malloc(size);  // ホストメモリの確保

    cudaMalloc(&vecd, size);  // デバイスメモリの確保
	cudaMemcpy(vecd, vec, size, cudaMemcpyHostToDevice);
    cudaEventRecord(start, 0);


    adder<<<Dg ,Db>>>(vecd);  // カーネルの実行

    cudaMemcpy(vec, vecd, size, cudaMemcpyDeviceToHost);  // 結果のデバイスからホストへのコピー

    long long sum = 0;
    for (int i = 0; i < n*n; ++i) {
        sum += vec[i];  // 結果の計算
    }
    printf("L   = %d\n", grid*block);
    printf("sum = %lld\n", sum);

    

    cudaEventRecord(end, 0);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer);

    cudaEventDestroy(start);
    cudaEventDestroy(end);

    free(vec);
    cudaFree(vecd);

    return 0;
}
