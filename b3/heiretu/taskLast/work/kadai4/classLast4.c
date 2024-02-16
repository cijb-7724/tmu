#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define EXPONENT 11
#define MATRIX_SIZE (1 << EXPONENT) // L次正方行列のサイズ

// 2次元配列の動的確保
int** allocate_matrix(int rows, int cols) {
    int **matrix = (int **)malloc(rows * sizeof(int *));
    if (matrix == NULL) {
        printf("メモリの割り当てに失敗しました\n");
        exit(1);
    }
    for (int i = 0; i < rows; i++) {
        matrix[i] = (int *)malloc(cols * sizeof(int));
        if (matrix[i] == NULL) {
            printf("メモリの割り当てに失敗しました\n");
            exit(1);
        }
    }
    return matrix;
}

// 2次元配列の解放
void free_matrix(int** matrix, int rows) {
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

int main() {
    int **a, **b, **c;
    long long i, j, k;

    a = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);
    b = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);
    c = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);

    printf("L = 2^%d = %lld\n", EXPONENT, MATRIX_SIZE);
    

    // すべての要素が1の行列を生成
    for (i = 0; i < MATRIX_SIZE; ++i) {
        for (j = 0; j < MATRIX_SIZE; ++j) {
            a[i][j] = 1;
            b[i][j] = 1;
        }
    }
    clock_t start = clock(); // 開始時間を記録
    // 行列の掛け算
    for (i = 0; i < MATRIX_SIZE; ++i) {
        for (j = 0; j < MATRIX_SIZE; ++j) {
            c[i][j] = 0;
            for (k = 0; k < MATRIX_SIZE; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    clock_t end = clock(); // 終了時間を記録

    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; // CPU時間を計算

    printf("c[%d][%d] = %d\n", 0, 0, c[0][0]);
    printf("c[%d][%d] = %d\n", MATRIX_SIZE - 1, MATRIX_SIZE - 1, c[MATRIX_SIZE - 1][MATRIX_SIZE - 1]);
    printf("time = %f[sec]\n", cpu_time_used);
    
    // 2次元配列の解放
    free_matrix(a, MATRIX_SIZE);
    free_matrix(b, MATRIX_SIZE);
    free_matrix(c, MATRIX_SIZE);

    return 0;
}
