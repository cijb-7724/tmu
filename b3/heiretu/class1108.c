#include <stdio.h>
#include <stdlib.h>
#include <time.h>

clock_t start, end;
#define Num 100
float a[Num][Num], b[Num][Num], c[Num][Num];

float a1[Num][Num][Num], b1[Num][Num][Num], c1[Num][Num][Num];
void kadai1(void) {
    printf("\n[i][j][k]\n");
    int i, j, k;
    for (i=0; i<Num; ++i) for (j=0; j<Num; ++j) for (k=0; k<Num; ++k) {
        a1[i][j][k] = (float)(i+j+k);
        b1[i][j][k] = (float)(i+j+k);
    }
    start = clock();//ijk
    for (i=0; i<Num; ++i) for (j=0; j<Num; ++j) for (k=0; k<Num; ++k) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

    start = clock();//ikj
    for (i=0; i<Num; ++i) for (k=0; k<Num; ++k) for (j=0; j<Num; ++j) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

    start = clock();//jik
    for (j=0; j<Num; ++j) for (i=0; i<Num; ++i) for (k=0; k<Num; ++k) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

    start = clock();//jki
    for (j=0; j<Num; ++j) for (k=0; k<Num; ++k) for (i=0; i<Num; ++i) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

    start = clock();//kij
    for (k=0; k<Num; ++k) for (i=0; i<Num; ++i) for (j=0; j<Num; ++j) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

    start = clock();//kji
    for (k=0; k<Num; ++k) for (j=0; j<Num; ++j) for (i=0; i<Num; ++i) {
        c1[i][j][k] = a1[i][j][k] + b1[i][j][k];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("Processing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);

}


int main() {
    
    int i, j;
    

    srand ( (unsigned int) time (NULL));
    for (i=0; i<Num; ++i) for (j=0; j<Num; ++j) {
        a[i][j] = (float)(i+j);
        b[i][j] = (float)(i+j);
    }
    start = clock();

    for (i=0; i<Num; ++i) for (j=0; j<Num; ++j) {
        c[i][j] = a[i][j] + b[i][j];
    }
    end = clock();
    printf("\nCalculation End\n");
    printf("\nProcessing Time : %.5lf [s]\n", (double)(end-start) / CLOCKS_PER_SEC);
    kadai1();
    return 0;
}

