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

float *h_IMG_input;    /*  入力画像のポインタ(Host)  */
float *h_IMG_output;   /*  出力画像のポインタ(Host)  */

float *d_IMG_input;    /*  入力画像のポインタ(Device)  */
float *d_IMG_output;   /*  出力画像のポインタ(Device)  */

cudaEvent_t start, end;  /*  測定用イベント  */
float timer;             /*  時間計測結果  */

int element = sizeof(float) * Nx * Ny;

/*
 * convert_upsideDown.cu : 上下反転するCUDAカーネル
 */

__global__ void convert_upsideDown(float *d_IMG_input, float *d_IMG_output) {
    int X, Y, ID, toID;

    X = threadIdx.x + (blockIdx.x * blockDim.x);
    Y = threadIdx.y + (blockIdx.y * blockDim.y);
    ID = X + Y * Nx;
    toID = Nx - 1 - X + Y * Nx;
    d_IMG_output[toID] = d_IMG_input[ID];
}

int main(int argc, char **argv) {
    // 使用するGPUデバイス番号
    int GPU_Num = 0;
    cudaSetDevice(GPU_Num);

    printf("convert_upsideDown.cu\n");
    printf("Nx = %d, Ny = %d\n", Nx, Ny);
    printf("Number %d GPU working\n", GPU_Num);

    // ホストとデバイスのメモリ確保
    cudaMalloc((void **)&d_IMG_input, element);
    cudaMalloc((void **)&d_IMG_output, element);
    cudaHostAlloc((void **)&h_IMG_input, element, cudaHostAllocPortable);
    cudaHostAlloc((void **)&h_IMG_output, element, cudaHostAllocPortable);

    memset(h_IMG_input, 0, element);
    memset(h_IMG_output, 0, element);

    // ファイル読み込み
    FILE *fp;
    fp = fopen("./man1024.img", "r");
    if (fp == NULL) {
        printf("ファイルを開けませんでした\n");
        return 0;
    }
    for (int j = 0; j < Ny; j++) {
        for (int i = 0; i < Nx; i++) {
            int ID = i + j * Nx;
            fscanf(fp, "%f", &(h_IMG_input[ID]));
        }
    }
    fclose(fp);

    // 計算時間測定開始
    cudaEventCreate(&start);
    cudaEventCreate(&end);
    cudaEventRecord(start, 0);

    // デバイスへデータ転送およびカーネル実行
    cudaMemcpy(d_IMG_input, h_IMG_input, element, HTD);
    convert_upsideDown<<<Dg, Db>>>(d_IMG_input, d_IMG_output);
    cudaThreadSynchronize();

    // 計算時間測定終了
    cudaEventRecord(end, 0);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.3f [msec]\n", timer);

    // 結果をホストにコピーしてファイルに書き出し
    cudaMemcpy(h_IMG_output, d_IMG_output, element, DTH);
    fp = fopen("output1024convert_gpu_5b.img", "w");
    if (fp == NULL) {
        printf("ファイルを開けませんでした\n");
        return 0;
    }
    for (int j = 0; j < Ny; j++) {
        for (int i = 0; i < Nx; i++) {
            int ID = i + j * Nx;
            fprintf(fp, "%d\n", (unsigned char)h_IMG_output[ID]);
        }
    }
    fclose(fp);

    // メモリ解放
    cudaFree(d_IMG_input);
    cudaFree(d_IMG_output);
    cudaFreeHost(h_IMG_input);
    cudaFreeHost(h_IMG_output);
    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
