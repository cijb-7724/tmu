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
    vecd[i*Nx+j] = (i-j)*(i-j);
}

int main(int argc, char **argv) {
    cudaSetDevice(0);

    long *vec, *vecd;
    int n = grid * block;  // �f�[�^�̐�
    int size = n * n * sizeof(long); // �f�[�^�̃T�C�Y

    cudaEventCreate(&start);
    cudaEventCreate(&end);

    printf("\nCalculation Start\n");

    vec = (long *)malloc(size);  // �z�X�g�������̊m��

    cudaMalloc(&vecd, size);  // �f�o�C�X�������̊m��
	cudaMemcpy(vecd, vec, size, cudaMemcpyHostToDevice);
    cudaEventRecord(start, 0);


    adder<<<Dg ,Db>>>(vecd);  // �J�[�l���̎��s

    cudaMemcpy(vec, vecd, size, cudaMemcpyDeviceToHost);  // ���ʂ̃f�o�C�X����z�X�g�ւ̃R�s�[

    long long sum = 0;
    for (int i = 0; i < n*n; ++i) {
        sum += vec[i];  // ���ʂ̌v�Z
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
