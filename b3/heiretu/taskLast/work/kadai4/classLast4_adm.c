#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define EXPONENT 13  // 行列の次数の指数
#define L (1 << EXPONENT) // 行列の次数

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
    int **a, **b, **c;  // 行列 a, b, c
    long long i, j;     // インデックス変数

    // 行列の動的確保
    a = allocate_matrix(L, L);
    b = allocate_matrix(L, L);
    c = allocate_matrix(L, L);

    printf("L = 2^%d = %lld\n", EXPONENT, L);

    // 行列の初期化
    for (i = 0; i < L; ++i) {
        for (j = 0; j < L; ++j) {
            a[i][j] = 1;
            b[i][j] = 1;
        }
    }

    clock_t start = clock();  // 計算開始時間を記録

    // 行列の要素ごとの掛け算
    for (i = 0; i < L; ++i) {
        for (j = 0; j < L; ++j) {
            c[i][j] = a[i][j] * b[i][j];
        }
    }

    clock_t end = clock();  // 計算終了時間を記録

    double cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;  // CPU時間を計算

    // 結果の出力
    printf("c[0][0] = %d\n", c[0][0]);
    printf("c[%lld][%lld] = %d\n", L - 1, L - 1, c[L - 1][L - 1]);
    printf("time = %.10f [sec]\n", cpu_time_used);

    // 行列の解放
    free_matrix(a, L);
    free_matrix(b, L);
    free_matrix(c, L);

    return 0;
}
