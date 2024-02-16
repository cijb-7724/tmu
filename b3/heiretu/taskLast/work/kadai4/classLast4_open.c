#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

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
    int i, j, k;
    double start, end;

    a = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);
    b = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);
    c = allocate_matrix(MATRIX_SIZE, MATRIX_SIZE);

    printf("L = 2^%d = %lld\n", EXPONENT, MATRIX_SIZE);

    // すべての要素が1の行列を生成
    for (i = 0; i < MATRIX_SIZE; ++i) {
        for (j = 0; j < MATRIX_SIZE; ++j) {
            a[i][j] = 1;
            b[i][j] = 1;
            c[i][j] = 0;
        }
    }

    // 開始時間を記録
    printf("\nCalculation Start\n");
    start = omp_get_wtime();

    #pragma omp parallel for shared(a, b, c) private(i, j, k) num_threads(8)
    for (i = 0; i < MATRIX_SIZE; ++i) {
        for (j = 0; j < MATRIX_SIZE; ++j) {
            for (k = 0; k < MATRIX_SIZE; ++k) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }

    // 終了時間を記録
    end = omp_get_wtime();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.10lf [sec]\n", (double)(end - start));
    printf("c[%d][%d] = %d\n", 0, 0, c[0][0]);
    printf("c[%d][%d] = %d\n", MATRIX_SIZE - 1, MATRIX_SIZE - 1, c[MATRIX_SIZE - 1][MATRIX_SIZE - 1]);

    // 行列の解放
    free_matrix(a, MATRIX_SIZE);
    free_matrix(b, MATRIX_SIZE);
    free_matrix(c, MATRIX_SIZE);

    return 0;
}
