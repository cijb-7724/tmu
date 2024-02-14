/*
 * main.cu(convert_color.cu) : �F�ϊ�
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


cudaEvent_t start, end;	     /*  ���Ԍv���p  */
float timer;	     /*  ���Ԍv���p  */

int element = sizeof(float) * Nx * Ny;

float alpha = 2.f;
long long sum = 0;


/*
 * convert_color.cu : �F�ϊ�
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
	// ��u�҂��Ƃ�GPU������U���Ă���̂ŁC�l��ύX���ĉ�����(0�`3)
	int GPU_Num = 2;
	cudaSetDevice(GPU_Num);

	printf("Nx = %d, Ny = %d\n", Nx, Ny);
	printf("Number %d GPU working\n", GPU_Num);

	// int i, j, ID;
	
	// ���Z���Ԃ��v�����邽�߂�cudaEventCreate�����s
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	printf("\nCalculation Start\n");



	// ���Z���Ԃ��v�����邽�߂�cudaEventRecord�����s���v�Z�̊J�n���L�^
	cudaEventRecord(start, 0);

	//here
	adder <<< 128, 128 >>> ();
	printf("sum = %lld\n", sum);







	cudaThreadSynchronize();

    // ���Z���Ԃ��v�����邽�߂�cudaEventRecord�����s���v�Z�̏I�����L�^
    cudaEventRecord(end, 0);

    // ���Z���Ԃ��Z�o
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    printf("\nCalculation End\n");

    printf("\nProcessing Time : %.3f [msec]\n", timer);

    
    cudaEventDestroy(start);
    cudaEventDestroy(end);

    return 0;
}
