#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define GRID_SIZE 128
#define BLOCK_SIZE 64
#define MATRIX_SIZE (BLOCK_SIZE * GRID_SIZE)

dim3 Db(BLOCK_SIZE, 1, 1);
dim3 Dg(GRID_SIZE, GRID_SIZE, 1);

cudaEvent_t start, end;
float timer;

// CUDAカーネル: 2つの行列の要素ごとの掛け算
__global__ void matrix_elementwise_multiply(int *a, int *b, int *c) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;
    c[i * MATRIX_SIZE + j] = a[i * MATRIX_SIZE + j] * b[i * MATRIX_SIZE + j];
}

int main(int argc, char **argv) {
    cudaSetDevice(0);

    int *a, *b, *c;  // 行列 a, b, c
    int *ad, *bd, *cd;  // デバイス用行列ポインタ
    int size = MATRIX_SIZE * MATRIX_SIZE * sizeof(int); // 行列のサイズ

    // イベントの作成
    cudaEventCreate(&start);
    cudaEventCreate(&end);

    printf("Matrix Element-wise Multiplication\n");
    printf("\nCalculation Start\n");

    // ホストメモリ上の行列の動的確保
    a = (int *)malloc(size);
    b = (int *)malloc(size);
    c = (int *)malloc(size);

    // 初期化
    for (int i = 0; i < MATRIX_SIZE * MATRIX_SIZE; ++i) {
        a[i] = b[i] = 1;
        c[i] = 0;
    }

    // デバイスメモリ上の行列の動的確保
    cudaMalloc(&ad, size);
    cudaMalloc(&bd, size);
    cudaMalloc(&cd, size);

    // ホストからデバイスへの転送
    cudaMemcpy(ad, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(bd, b, size, cudaMemcpyHostToDevice);
    cudaMemcpy(cd, c, size, cudaMemcpyHostToDevice);

    // カーネル実行時間計測開始
    cudaEventRecord(start, 0);

    // カーネル呼び出し
    matrix_elementwise_multiply<<<Dg, Db>>>(ad, bd, cd);

    // 結果をデバイスからホストに転送
    cudaMemcpy(c, cd, size, cudaMemcpyDeviceToHost);

    // カーネル実行時間計測終了
    cudaEventRecord(end, 0);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    // 結果の表示
    printf("c[0][0] = %d\n", c[0]);
    printf("c[%d][%d] = %d\n", MATRIX_SIZE - 1, MATRIX_SIZE - 1, c[MATRIX_SIZE * MATRIX_SIZE - 1]);

    // 実行時間の表示
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer);

    // メモリの解放
    free(a);
    free(b);
    free(c);
    cudaFree(ad);
    cudaFree(bd);
    cudaFree(cd);
    
    // イベントの破棄
    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
