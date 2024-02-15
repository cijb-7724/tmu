#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define Nx 1024
#define Ny 1024

// 2次元配列の動的確保
unsigned char** allocate_matrix(int rows, int cols) {
    unsigned char **matrix = (unsigned char **)malloc(rows * sizeof(unsigned char *));
    if (matrix == NULL) {
        printf("メモリの割り当てに失敗しました\n");
        exit(1);
    }
    for (int i = 0; i < rows; i++) {
        matrix[i] = (unsigned char *)malloc(cols * sizeof(unsigned char));
        if (matrix[i] == NULL) {
            printf("メモリの割り当てに失敗しました\n");
            exit(1);
        }
    }
    return matrix;
}

// 2次元配列の解放
void free_matrix(unsigned char** matrix, int rows) {
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
}


void flip_image(unsigned char **input, unsigned char **output) {
    int i, j;

    for (i = 0; i < Ny; i++) {
        for (j = 0; j < Nx; j++) {
            // output[Ny - i - 1][j] = input[i][j];
            output[i][Ny-j-1] = input[i][j];
            
        }
    }
}


int main() {
    unsigned char **h_IMG_input;  // 入力画像の配列
    unsigned char **h_IMG_output; // 出力画像の配列
    int i, j;

    h_IMG_input = allocate_matrix(Ny, Nx);
    h_IMG_output = allocate_matrix(Nx, Ny);

    printf("h\n"); // デバッグステートメントを追加

    FILE *fp = fopen("./man1024.img", "r");
    if (fp == NULL) {
        printf("file cannot open\n");
        return 1;
    }
    printf("h\n"); // デバッグステートメントを追加

    // 入力画像の読み込み
    for (i = 0; i < Ny; i++) {
        for (j = 0; j < Nx; j++) {
            fscanf(fp, "%hhu", &h_IMG_input[i][j]);
        }
    }
    fclose(fp);
    printf("h\n"); // デバッグステートメントを追加

    // 画像の回転
    flip_image(h_IMG_input, h_IMG_output);

    // 出力画像の書き出し
    fp = fopen("output1024convert_cpu.img", "w");
    if (fp == NULL) {
        printf("file cannot open 2\n");
        return 1;
    }

    for (i = 0; i < Nx; i++) {
        for (j = 0; j < Ny; j++) {
            fprintf(fp, "%d\n", h_IMG_output[i][j]);
        }
    }
    fclose(fp);

    printf("画像の回転が完了しました\n");

    // 2次元配列の解放
    free_matrix(h_IMG_input, Ny);
    free_matrix(h_IMG_output, Nx);

    return 0;
}
