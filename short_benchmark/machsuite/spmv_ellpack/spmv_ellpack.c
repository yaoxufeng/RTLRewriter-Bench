#include <stdlib.h>
#include <stdio.h>
#include "support.h"

// These constants valid for the IEEE 494 bus interconnect matrix
#define NNZ 1666
#define N 494
#define L 10

#define TYPE double

void ellpack(TYPE nzval[N*L], int32_t cols[N*L], TYPE vec[N], TYPE out[N]);
////////////////////////////////////////////////////////////////////////////////
// Test harness interface code.

struct bench_args_t {
  TYPE nzval[N*L];
  int32_t cols[N*L];
  TYPE vec[N];
  TYPE out[N];
};

void ellpack(TYPE nzval[N*L], int32_t cols[N*L], TYPE vec[N], TYPE out[N])
{
    int i, j;
    TYPE Si;

    ellpack_1 : for (i=0; i<N; i++) {
        TYPE sum = out[i];
        ellpack_2 : for (j=0; j<L; j++) {
                Si = nzval[j + i*L] * vec[cols[j + i*L]];
                sum += Si;
        }
        out[i] = sum;
    }
}