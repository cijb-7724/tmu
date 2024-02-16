/*
 * main.cu(convert_color.cu) : メイン
 * @ KLO lab. in TMU (2013/12/20[Fri])
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_runtime_api.h>

#define HTH cudaMemcpyHostToHost
#define HTD cudaMemcpyHostToDevice
#define DTH cudaMemcpyDeviceToHost
#define DTD cudaMemcpyDeviceToDevice

#define Nx 1024
#define Ny 1024

#define Db_x 256
#define Db_y 1
#define Db_z 1

#define Dg_x (Nx / Db_x)
#define Dg_y (Ny / Db_y)
#define Dg_z 1

dim3 Db(Db_x, Db_y, Db_z);
dim3 Dg(Dg_x, Dg_y, Dg_z);

float *h_IMG_input;      /* 入力画像のポインタ(Host) */
float *h_IMG_output;     /* 出力画像のポインタ(Host) */

float *d_IMG_input;      /* 入力画像のポインタ(Device) */
float *d_IMG_output;     /* 出力画像のポインタ(Device) */

cudaEvent_t start, end;     /* 測定用イベント */
float timer;     /* 測定用イベント */

int element = sizeof(float) * Nx * Ny;

float alpha = 2.f;


/*
 * convert_color.cu : カーネル
 */

__global__ void convert_rotate
(
    float *d_IMG_input,
    float *d_IMG_output
)
{
    int X, Y, ID, toID;

    X = threadIdx.x + (blockIdx.x * blockDim.x);
    Y = threadIdx.y + (blockIdx.y * blockDim.y);
    ID = X + Y * Nx;
    toID = Y + (Nx - X - 1) * Nx;
    if (toID < 0 || toID >= Nx * Nx) printf("toID %d\n", toID);
    d_IMG_output[ID] = d_IMG_input[toID];
}

/*
 * メイン関数main : メイン
 */

int main
(
    int    argc, // Argument Count
    char **argv  // Argument Vector
)
{
    // 使用するGPUの選択
    int GPU_Num = 0;

    cudaSetDevice(GPU_Num);

    printf("convert_rotate.cu\n");
    printf("Nx = %d, Ny = %d\n", Nx, Ny);
    printf("Number %d GPU working\n", GPU_Num);

    int i, j, ID;

    // デバイスメモリの確保
    cudaMalloc((void **)&d_IMG_input, element);
    cudaMalloc((void **)&d_IMG_output, element);

    cudaMemset(d_IMG_input, 0, element);
    cudaMemset(d_IMG_output, 0, element);

    // ホストメモリの確保
    cudaHostAlloc((void **)&h_IMG_input, element, cudaHostAllocPortable);
    cudaHostAlloc((void **)&h_IMG_output, element, cudaHostAllocPortable);

    memset(h_IMG_input, 0, element);
    memset(h_IMG_output, 0, element);

    // ファイル読み込み
    FILE *fp;     /* ファイルポインタ */

    fp = fopen("./man1024.img", "r");     /* 入力ファイルを読み込む */
    if (fp == NULL) {
        printf("ファイルを開けませんでした\n");
        return 0;
    }

    for (j = 0; j < Ny; j++) {
        for (i = 0; i < Nx; i++) {
            ID = i + j * Nx;
            fscanf(fp, "%f", &(h_IMG_input[ID]));     /* 1要素読み込んで h_IMG_input[ID] に格納 */
        }
    }

    fclose(fp);     /* ファイルをクローズ */

    // 作業開始のイベントを作成
    cudaEventCreate(&start);
    cudaEventCreate(&end);

    printf("\nCalculation Start\n");

    cudaMemcpy(d_IMG_input, h_IMG_input, element, HTD);

    // 処理の開始時間を記録するイベントを記録
    cudaEventRecord(start, 0);

    /* 画像処理 */
    convert_rotate <<<Dg, Db>>> (d_IMG_input, d_IMG_output);

    cudaThreadSynchronize();

    // 処理の終了時間を記録するイベントを記録
    cudaEventRecord(end, 0);

    // イベントの同期
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    printf("\nCalculation End\n");

    printf("\nProcessing Time : %.3f [msec]\n", timer);

    /* ファイル出力 */
    cudaMemcpy(h_IMG_output, d_IMG_output, element, DTH);

    // 出力ファイルを開く
    fp = fopen("output1024convert_gpu_5a.img", "w");
   
    if (fp == NULL) {
        printf("ファイルを開けませんでした");
        return 0;
    }

    for (j = 0; j < Ny; j++) {
        for (i = 0; i < Nx; i++) {
            ID = i + j * Nx;
            fprintf(fp, "%d\n", (unsigned char) h_IMG_output[ID]);     /* 1要素書き出す */
        }
    }

    fclose(fp);

    // デバイスメモリの解放
    cudaFree(d_IMG_input);
    cudaFree(d_IMG_output);

    // ホストメモリの解放
    cudaFreeHost(h_IMG_input);
    cudaFreeHost(h_IMG_output);

    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
