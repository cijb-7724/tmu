#include <stdio.h>
#include <omp.h>

int main() {
    long long sum = 0;      // 合計値の初期化
    int exp = 13;           // 指数の値
    double start, end;      // 処理時間計測用の変数
    long long L = (long long)1 << exp; // ループ回数の計算
    printf("L = 2^%d = %lld\n", exp, L); // ループ回数の出力

    // 計算開始時間の記録
    printf("\nCalculation Start\n");
    start = omp_get_wtime();

    long long i, j;
    // 並列処理のためのOpenMPディレクティブ
    #pragma omp parallel shared(sum) private(i, j) num_threads(16)
    {   
        // ループの並列化
        #pragma omp for
        for (i = 0; i < L; ++i) {
            for (j = 0; j < L; ++j) {
                // 合計値の更新（クリティカルセクション）
                #pragma omp critical
                {
                    sum += (i - j) * (i - j);
                }
            }
        }
    }

    // 計算終了時間の記録
    end = omp_get_wtime();
    printf("\nCalculation End\n");
    
    // 処理時間の出力
    printf("\nProcessing Time : %.10lf [sec]\n", (double)(end - start));
    // 合計値の出力
    printf("sum = %lld\n", sum);

    return 0;
}
