#include <stdio.h>
#include <stdlib.h>
#include <time.h>

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

// 画像の上下反転
void flip_image(unsigned char **input, unsigned char **output) {
    for (int i = 0; i < Ny; i++) {
        for (int j = 0; j < Nx; j++) {
            output[Ny - i - 1][j] = input[i][j];
        }
    }
}

int main() {
    unsigned char **h_IMG_input;  // 入力画像の配列
    unsigned char **h_IMG_output; // 出力画像の配列

    // 入力画像と出力画像のメモリ確保
    h_IMG_input = allocate_matrix(Ny, Nx);
    h_IMG_output = allocate_matrix(Nx, Ny);

    // 入力画像の読み込み
    FILE *fp = fopen("./man1024.img", "r");
    if (fp == NULL) {
        printf("ファイルを開けませんでした\n");
        return 1;
    }
    for (int i = 0; i < Ny; i++) {
        for (int j = 0; j < Nx; j++) {
            fscanf(fp, "%hhu", &h_IMG_input[i][j]);
        }
    }
    fclose(fp);
    
    // 処理時間の計測
    clock_t start = clock();
    // 画像の上下反転
    flip_image(h_IMG_input, h_IMG_output);
    clock_t end = clock();

    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("処理時間 = %f秒\n", cpu_time_used);

    // 出力画像の書き出し
    fp = fopen("output1024convert_cpu.img", "w");
    if (fp == NULL) {
        printf("ファイルを開けませんでした\n");
        return 1;
    }
    for (int i = 0; i < Nx; i++) {
        for (int j = 0; j < Ny; j++) {
            fprintf(fp, "%d\n", h_IMG_output[i][j]);
        }
    }
    fclose(fp);

    // メモリの解放
    free_matrix(h_IMG_input, Ny);
    free_matrix(h_IMG_output, Nx);

    return 0;
}
