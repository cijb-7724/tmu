/*
 * main.cu(convert_color.cu) : 色変換
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

float *h_IMG_input;	     /*  入力データ用(Host)  */
float *h_IMG_output;     /*  出力データ用(Host)  */

float *d_IMG_input;	     /*  入力データ用(Device)  */
float *d_IMG_output;     /*  出力データ用(Device)  */

cudaEvent_t start, end;	     /*  時間計測用  */
float timer;	     /*  時間計測用  */

int element = sizeof(float) * Nx * Ny;

float alpha = 2.f;


/*
 * convert_color.cu : 色変換
 */

__global__ void convert_color (float *d_IMG_input, float *d_IMG_output)
{
	int X, Y, ID;
	X = threadIdx.x + (blockIdx.x * blockDim.x);
	Y = threadIdx.y + (blockIdx.y * blockDim.y);
	ID = X + Y * Nx;
}

/*
 * ここからmain : 色変換
 */

int main
(
	int    argc, // Argument Count
	char **argv  // Argument Vector
)
{
	// 受講者ごとにGPUが割り振られているので，値を変更して下さい(0～3)
	int GPU_Num = 2;

	cudaSetDevice(GPU_Num);

	printf("convert_color.cu\n");
	printf("Nx = %d, Ny = %d\n", Nx, Ny);
	printf("Number %d GPU working\n", GPU_Num);

	int i, j, ID;

	// デバイス（VRAM内）に要素を確保
	cudaMalloc((void **)&d_IMG_input, element);
	cudaMalloc((void **)&d_IMG_output, element);

	cudaMemset(d_IMG_input, 0, element);
	cudaMemset(d_IMG_output, 0, element);

	// ホスト（RAM内）に要素を確保
	cudaHostAlloc((void **)&h_IMG_input, element, cudaHostAllocPortable);
	cudaHostAlloc((void **)&h_IMG_output, element, cudaHostAllocPortable);

	memset(h_IMG_input, 0, element);
	memset(h_IMG_output, 0, element);

//ファイルよりデータ入力
	FILE *fp;	     /*  入出ファイル用  */

	fp = fopen("./man1024.img", "r");     /*  読込みモードでファイルをオープンする  */
	if(fp == NULL) {
		printf("ファイルを開くことが出来ませんでした．\n");
		return 0;
	}
 
	for(j = 0; j < Ny; j++){
		for(i = 0; i < Nx; i++){
			ID = i + j * Nx;
			fscanf(fp, "%f", &(h_IMG_input[ID]) );     /*  1行読む　→ h_IMG_input[ID])に入れる */
		}
	}
	
	fclose(fp);     /*  ファイルをクローズする  */

	
	// 演算時間を計測するためのcudaEventCreateを実行
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	printf("\nCalculation Start\n");

	cudaMemcpy(d_IMG_input, h_IMG_input, element, HTD);

	// 演算時間を計測するためのcudaEventRecordを実行し計算の開始を記録
	cudaEventRecord(start, 0);


	/* image processing */
	convert_color <<< Dg, Db >>> (d_IMG_input, d_IMG_output);

	cudaThreadSynchronize();

    // 演算時間を計測するためのcudaEventRecordを実行し計算の終了を記録
    cudaEventRecord(end, 0);

    // 演算時間を算出
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    printf("\nCalculation End\n");

    printf("\nProcessing Time : %.3f [msec]\n", timer);

    /* File Output */
    cudaMemcpy(h_IMG_output, d_IMG_output, element, DTH);

//出力用データをファイルに書き込む
    fp = fopen("output1024convert_gpu.img", "w");     /*  書込みモードでファイルをオープンする  */
   
    if(fp == NULL){
        printf("ファイルを作れませんでした");
        return 0;  /*  ここでプログラム終了  */
    }

    for(j = 0; j < Ny; j++){
		for(i = 0; i < Nx; i++){
			ID = i + j * Nx;
			fprintf(fp, "%d\n", (unsigned char) h_IMG_output[ID]);     /*  1行書込み　→ h_IMG_output[ID])に入れる */
		}
	}

	fclose(fp);

    cudaFree(d_IMG_input);
    cudaFree(d_IMG_output);

    cudaFreeHost(h_IMG_input);
    cudaFreeHost(h_IMG_output);

    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
