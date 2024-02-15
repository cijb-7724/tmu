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

float *h_IMG_input;	     /*  ���̓f�[�^�p(Host)  */
float *h_IMG_output;     /*  �o�̓f�[�^�p(Host)  */

float *d_IMG_input;	     /*  ���̓f�[�^�p(Device)  */
float *d_IMG_output;     /*  �o�̓f�[�^�p(Device)  */

cudaEvent_t start, end;	     /*  ���Ԍv���p  */
float timer;	     /*  ���Ԍv���p  */

int element = sizeof(float) * Nx * Ny;

float alpha = 2.f;


/*
 * convert_color.cu : �F�ϊ�
 */

__global__ void convert_upsideDown
(
	float *d_IMG_input,
	float *d_IMG_output
)
{
	int X, Y, ID, toID;

	X = threadIdx.x + (blockIdx.x * blockDim.x);
	Y = threadIdx.y + (blockIdx.y * blockDim.y);
	ID = X + Y * Nx;
	toID = Nx-1-X + Y * Nx;
	if (toID <0 || toID >= Nx*Nx) printf("toID %d\n", toID);
	d_IMG_output[toID] = d_IMG_input[ID];
	// toID = Y+ (Nx-X-1)*Nx;
	
	// d_IMG_output[ID] = d_IMG_input[toID];
}

/*
 * ��������main : �F�ϊ�
 */

int main
(
	int    argc, // Argument Count
	char **argv  // Argument Vector
)
{
	// ��u�҂��Ƃ�GPU������U���Ă���̂ŁC�l��ύX���ĉ�����(0�`3)
	int GPU_Num = 0;

	cudaSetDevice(GPU_Num);

	printf("convert_upsideDwon.cu\n");
	printf("Nx = %d, Ny = %d\n", Nx, Ny);
	printf("Number %d GPU working\n", GPU_Num);

	int i, j, ID;

	// �f�o�C�X�iVRAM���j�ɗv�f���m��
	cudaMalloc((void **)&d_IMG_input, element);
	cudaMalloc((void **)&d_IMG_output, element);

	cudaMemset(d_IMG_input, 0, element);
	cudaMemset(d_IMG_output, 0, element);

	// �z�X�g�iRAM���j�ɗv�f���m��
	cudaHostAlloc((void **)&h_IMG_input, element, cudaHostAllocPortable);
	cudaHostAlloc((void **)&h_IMG_output, element, cudaHostAllocPortable);

	memset(h_IMG_input, 0, element);
	memset(h_IMG_output, 0, element);

//�t�@�C�����f�[�^����
	FILE *fp;	     /*  ���o�t�@�C���p  */

	fp = fopen("./man1024.img", "r");     /*  �Ǎ��݃��[�h�Ńt�@�C�����I�[�v������  */
	if(fp == NULL) {
		printf("�t�@�C�����J�����Ƃ��o���܂���ł����D\n");
		return 0;
	}
 
	for(j = 0; j < Ny; j++){
		for(i = 0; i < Nx; i++){
			ID = i + j * Nx;
			fscanf(fp, "%f", &(h_IMG_input[ID]) );     /*  1�s�ǂށ@�� h_IMG_input[ID])�ɓ���� */
		}
	}
	
	fclose(fp);     /*  �t�@�C�����N���[�Y����  */

	
	// ���Z���Ԃ��v�����邽�߂�cudaEventCreate�����s
	cudaEventCreate(&start);
	cudaEventCreate(&end);

	printf("\nCalculation Start\n");

	cudaMemcpy(d_IMG_input, h_IMG_input, element, HTD);

	// ���Z���Ԃ��v�����邽�߂�cudaEventRecord�����s���v�Z�̊J�n���L�^
	cudaEventRecord(start, 0);


	/* image processing */
	convert_upsideDown <<< Dg, Db >>> (d_IMG_input, d_IMG_output);

	cudaThreadSynchronize();

    // ���Z���Ԃ��v�����邽�߂�cudaEventRecord�����s���v�Z�̏I�����L�^
    cudaEventRecord(end, 0);

    // ���Z���Ԃ��Z�o
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&timer, start, end);

    printf("\nCalculation End\n");

    printf("\nProcessing Time : %.3f [msec]\n", timer);

    /* File Output */
    cudaMemcpy(h_IMG_output, d_IMG_output, element, DTH);

//�o�͗p�f�[�^���t�@�C���ɏ�������
    fp = fopen("output1024convert_gpu_5b.img", "w");     /*  �����݃��[�h�Ńt�@�C�����I�[�v������  */
   
    if(fp == NULL){
        printf("�t�@�C�������܂���ł���");
        return 0;  /*  �����Ńv���O�����I��  */
    }

    for(j = 0; j < Ny; j++){
		for(i = 0; i < Nx; i++){
			ID = i + j * Nx;
			fprintf(fp, "%d\n", (unsigned char) h_IMG_output[ID]);     /*  1�s�����݁@�� h_IMG_output[ID])�ɓ���� */
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
