#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <cuda.h>
#include <cuda_runtime.h>

#define GRID_SIZE 128    // グリッドのサイズ
#define BLOCK_SIZE 64    // ブロックのサイズ

#define Nx (BLOCK_SIZE * GRID_SIZE)  // X方向の要素数
#define Ny (BLOCK_SIZE * GRID_SIZE)  // Y方向の要素数

#define Db_x BLOCK_SIZE  // X方向のブロックサイズ
#define Db_y 1            // Y方向のブロックサイズ
#define Db_z 1            // Z方向のブロックサイズ

#define Dg_x (Nx / Db_x)  // X方向のグリッド数
#define Dg_y (Ny / Db_y)  // Y方向のグリッド数
#define Dg_z 1            // Z方向のグリッド数

dim3 Db(Db_x, Db_y, Db_z);  // 3次元ブロック構造
dim3 Dg(Dg_x, Dg_y, Dg_z);  // 3次元グリッド構造

cudaEvent_t start, end;  // CUDAイベント変数
float timer;             // 処理時間を格納する変数

// カーネル関数：行列の要素ごとの計算を実行
__global__ void adder(long *vecd) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;  // 行番号の計算
    int j = blockIdx.y * blockDim.y + threadIdx.y;  // 列番号の計算
    vecd[i * Nx + j] = (i - j) * (i - j);           // 要素ごとの計算
}

int main(int argc, char **argv) {
    cudaSetDevice(0);  // CUDAデバイスの設定

    long *vec, *vecd;  // ホストとデバイスのメモリ領域を指すポインタ
    int n = GRID_SIZE * BLOCK_SIZE;  // 行列の1辺のサイズ
    int size = n * n * sizeof(long); // 行列の総要素数

    cudaEventCreate(&start);  // 開始時間を記録するCUDAイベントの生成
    cudaEventCreate(&end);    // 終了時間を記録するCUDAイベントの生成

    printf("\nCalculation Start\n");

    vec = (long *)malloc(size);  // ホスト側のメモリ領域の確保

    cudaMalloc(&vecd, size);  // デバイス側のメモリ領域の確保
    cudaMemcpy(vecd, vec, size, cudaMemcpyHostToDevice);  // ホストからデバイスへのデータ転送
    cudaEventRecord(start, 0);  // 計算開始時間の記録

    adder<<<Dg, Db>>>(vecd);  // カーネル関数の実行

    cudaMemcpy(vec, vecd, size, cudaMemcpyDeviceToHost);  // デバイスからホストへのデータ転送

    long long sum = 0;  // 結果の合計値
    for (int i = 0; i < n * n; ++i) {
        sum += vec[i];  // 合計の計算
    }
    printf("L   = %d\n", GRID_SIZE * BLOCK_SIZE);  // サイズの表示
    printf("sum = %lld\n", sum);                   // 合計の表示

    cudaEventRecord(end, 0);            // 計算終了時間の記録
    cudaEventSynchronize(end);          // イベントの完了を待機
    cudaEventElapsedTime(&timer, start, end);  // 計算時間の算出
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer);  // 計算時間の表示

    cudaEventDestroy(start);  // 開始イベントの破棄
    cudaEventDestroy(end);    // 終了イベントの破棄

    free(vec);         // ホスト側メモリの解放
    cudaFree(vecd);
}
