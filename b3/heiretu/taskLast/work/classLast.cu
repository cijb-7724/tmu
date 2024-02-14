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

long long L = pow(2, 7);
#define grid 1024
#define block grid/L

#define grid 3
#define block 5

#define Nx 16
#define Ny 8

#define Db_x 8
#define Db_y 1
#define Db_z 1

#define Dg_x (Nx / Db_x)
#define Dg_y (Ny / Db_y)
#define Dg_z 1

dim3 Db(Db_x, Db_y, Db_z);
dim3 Dg(Dg_x, Dg_y, Dg_z);


cudaEvent_t start, end;	     /*  時間計測用  */
float timer;	     /*  時間計測用  */

int element = sizeof(float) * Nx * Ny;

float alpha = 2.f;
long long sum = 0;


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

__global__ void adder() {
	// sum += (i-j)*(i-j);
	sum += (blockIdx.x - threadIdx.x)*(blockIdx.x - threadIdx.x);
}
__global__ void vecAdd(double *Ad, double *Bd, double *Cd) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    Cd[i] = Ad[i] + Bd[i];
}



int main
(
	int    argc, // Argument Count
	char **argv  // Argument Vector
)
{
	// 受講者ごとにGPUが割り振られているので，値を変更して下さい(0～3)
	int GPU_Num = 2;
	cudaSetDevice(GPU_Num);

	printf("Nx = %d, Ny = %d\n", Nx, Ny);
	printf("Number %d GPU working\n", GPU_Num);

	// int i, j, ID;
	
	// 演算時間を計測するためのcudaEventCreateを実行
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	printf("\nCalculation Start\n");



	// 演算時間を計測するためのcudaEventRecordを実行し計算の開始を記録
	cudaEventRecord(start, 0);

	//here
	adder <<< 128, 128 >>> ();
	printf("sum = %lld\n", sum);







	cudaThreadSynchronize();

    // 演算時間を計測するためのcudaEventRecordを実行し計算の終了を記録
    cudaEventRecord(end, 0);

    // 演算時間を算出
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    printf("\nCalculation End\n");

    printf("\nProcessing Time : %.3f [msec]\n", timer);

    
    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
