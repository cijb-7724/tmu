#include <stdio.h>
#include <time.h>

int main() {
    long long sum = 0;
    int exp = 13;
    long long L = (long long)1<<exp;
    printf("L = 2^%d = %lld\n", exp, L);
    clock_t start = clock(); // 開始時間を記録
    for (long long i=0; i<L; ++i) {
        for (long long j=0; j<L; ++j) {
            sum += (i-j)*(i-j);
        }
    }
    clock_t end = clock(); // 終了時間を記録

    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC; // CPU時間を計算

    printf("sum = %lld\n", sum);
    printf("time = %f[sec]\n", cpu_time_used);
}