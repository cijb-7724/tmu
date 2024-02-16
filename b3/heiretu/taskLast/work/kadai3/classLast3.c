#include <stdio.h>
#include <time.h>

int main() {
    long long sum = 0;
    int exp = 7;
    long long L = (long long)1 << exp;
    
    // ループの回数を計算
    printf("L = 2^%d = %lld\n", exp, L);
    
    clock_t start = clock(); // 開始時間を記録
    
    // ループで計算を実行
    for (long long i = 0; i < L; ++i) {
        for (long long j = 0; j < L; ++j) {
            sum += (i - j) * (i - j);
        }
    }
    
    clock_t end = clock(); // 終了時間を記録

    // CPU時間を計算
    double cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

    // 結果を出力
    printf("sum = %lld\n", sum);
    printf("time = %.10f [sec]\n", cpu_time_used);
    
    return 0;
}
