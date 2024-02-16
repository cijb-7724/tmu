#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

// 定数定義
#define GRID_SIZE 64
#define BLOCK_SIZE 32

#define MATRIX_SIZE (BLOCK_SIZE * GRID_SIZE)

// グリッドとブロックの次元設定
dim3 Db(BLOCK_SIZE, 1, 1); // ブロックの次元
dim3 Dg(GRID_SIZE, GRID_SIZE, 1); // グリッドの次元

// CUDAイベント変数の宣言
cudaEvent_t start, end;
float timer;

// カーネル関数: 2つの行列の乗算
__global__ void mult_matrix(int *a, int *b, int *c) {
    int i = blockIdx.x * blockDim.x + threadIdx.x; // 行インデックス
    int j = blockIdx.y * blockDim.y + threadIdx.y; // 列インデックス
    for (int k = 0; k < MATRIX_SIZE; ++k) {
        // 行列の各要素の計算
        c[i * MATRIX_SIZE + j] += a[i * MATRIX_SIZE + k] * b[k * MATRIX_SIZE + j];
    }
}

int main() {
    cudaSetDevice(0); // CUDAデバイスの設定

    int *a, *b, *c; // ホスト側の行列
    int *ad, *bd, *cd; // デバイス側の行列
    int size = MATRIX_SIZE * MATRIX_SIZE * sizeof(int); // 行列のサイズ

    cudaEventCreate(&start); // 開始時刻のCUDAイベントの作成
    cudaEventCreate(&end); // 終了時刻のCUDAイベントの作成

    printf("Matrix Multiplication\n");
    printf("\nCalculation Start\n");

    // ホスト側の行列メモリの割り当てと初期化
    a = (int *)malloc(size);
    b = (int *)malloc(size);
    c = (int *)malloc(size);

    for (int i = 0; i < MATRIX_SIZE * MATRIX_SIZE; ++i) {
        a[i] = b[i] = 1; // すべての要素を1に初期化
        c[i] = 0; // cの要素を0に初期化
    }

    // デバイス側の行列メモリの割り当てと初期化
    cudaMalloc(&ad, size);
    cudaMalloc(&bd, size);
    cudaMalloc(&cd, size);
    cudaMemcpy(ad, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(bd, b, size, cudaMemcpyHostToDevice);
    cudaMemcpy(cd, c, size, cudaMemcpyHostToDevice);

    cudaEventRecord(start, 0); // 演算開始時刻の記録

    mult_matrix<<<Dg, Db>>>(ad, bd, cd); // カーネル関数の呼び出し

    cudaMemcpy(c, cd, size, cudaMemcpyDeviceToHost); // 結果のデバイス側からホスト側への転送

    // 結果の表示
    printf("c[%d][%d] = %d\n", 0, 0, c[0]);
    printf("c[%d][%d] = %d\n", MATRIX_SIZE - 1, MATRIX_SIZE - 1, c[MATRIX_SIZE * MATRIX_SIZE - 1]);

    cudaEventRecord(end, 0); // 演算終了時刻の記録
    cudaEventSynchronize(end); // イベントの同期
    cudaEventElapsedTime(&timer, start, end); // 演算時間の計算
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer); // 演算時間の表示

    cudaEventDestroy(start); // 開始時刻のCUDAイベントの破棄
    cudaEventDestroy(end); // 終了時刻のCUDAイベントの破棄

    // メモリの解放
    free(a);
    free(b);
    free(c);
    cudaFree(ad);
    cudaFree(bd);
    cudaFree(cd);

    return 0;
}
