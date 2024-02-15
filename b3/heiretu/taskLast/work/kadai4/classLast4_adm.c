#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define exp 11
#define L (long long)1<<exp // L次正方行列のサイズ

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
    // int a[L][L]; // 行列1
    // int b[L][L]; // 行列2
    // int c[L][L];  // 結果の行列
    int **a, **b, **c;
    long long i, j, k;

    a = allocate_matrix(L, L);
    b = allocate_matrix(L, L);
    c = allocate_matrix(L, L);

    printf("L = 2^%d = %lld\n", exp, L);
    

    // すべての要素が1の行列を生成
    for (i=0; i<L; ++i) {
        for (j=0; j<L; ++j) {
            a[i][j] = 1;
            b[i][j] = 1;
        }
    }
    clock_t start = clock(); // 開始時間を記録
    // 行列の掛け算
    for (i=0; i<L; ++i) {
        for (j=0; j<L; ++j) {
            c[i][j] = a[i][j] * b[i][j];
        }
    }
    clock_t end = clock(); // 終了時間を記録

    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; // CPU時間を計算
    printf("L = 2^%d = %lld\n", exp, L);

    printf("c[%d][%d] = %d\n", 0, 0, c[0][0]);
    printf("c[%d][%d] = %d\n", (L)-1, (L)-1, c[(L)-1][(L)-1]);
    printf("time = %f[sec]\n", cpu_time_used);
    

    return 0;
}
