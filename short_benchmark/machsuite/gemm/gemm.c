//Standard Libraries
#include <stdio.h>
#include <stdlib.h>
#include "support.h"

//Define compute data type
#define TYPE double

//Specify row/column sizes
#define row_size 64
#define col_size 64
#define N row_size*col_size

//Define the input range to operate over
#define MIN 0.
#define MAX 1.0

//Set number of iterations to execute
#define MAX_ITERATION 1

void gemm(TYPE m1[N], TYPE m2[N], TYPE prod[N]);
////////////////////////////////////////////////////////////////////////////////
// Test harness interface code.

struct bench_args_t {
  TYPE m1[N];
  TYPE m2[N];
  TYPE prod[N];
};

void gemm( TYPE m1[N], TYPE m2[N], TYPE prod[N] ){
    int i, j, k;
    int k_col, i_col;
    TYPE mult;

    outer:for(i=0;i<row_size;i++) {
        middle:for(j=0;j<col_size;j++) {
            i_col = i * col_size;
            TYPE sum = 0;
            inner:for(k=0;k<row_size;k++) {
                k_col = k * col_size;
                mult = m1[i_col + k] * m2[k_col + j];
                sum += mult;
            }
            prod[i_col + j]  = sum;
        }
    }
}