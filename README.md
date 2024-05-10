# RTLRewriter-Bench

The RTLRewriter Benchmark aims to establish a new standard for RTL code optimization and synthesis within the community. It comprises two benchmarks: the Large Rewriter Benchmark and the Small Rewriter Benchmark.
The Large Rewriter Benchmark focuses on complex scenarios involving extensive circuit partitioning, optimization trade-offs, and verification challenges. It provides a comprehensive evaluation for advanced techniques and approaches in RTL code optimization. On the other hand, the Small Rewriter Benchmark caters to a broader range of scenarios and patterns. 

**Small Benchmarks** 
Small benchmarks contain 55 short RTL code cases. These cases cover various aspects of RTL code, including basic patterns, data paths, memory, MUX, FSM, and control logic. Each case has been meticulously rewritten and curated by experienced Verilog engineers, providing both the original and optimized versions for evaluation.

| Test Case ID | Yosys Wires | Yosys Cells | RTLRewriter Wires | RTLRewriter Cells |
|--------------|-------------|-------------|-------------------|-------------------|
| case1        | 28          | 18          | 24                | 14                |
| case2        | 11646       | 11824       | 11299             | 11477             |
| case3        | 1136        | 1220        | 890               | 974               |
| case4        | 1376        | 1462        | 1127              | 1213              |
| case5        | 193         | 49          | 65                | 49                |
| case6        | 172         | 129         | 161               | 129               |
| case7        | 402         | 403         | 353               | 354               |
| case8        | 466         | 354         | 370               | 354               |
| case9        | 70          | 71          | 34                | 32                |
| case10       | 59          | 56          | 41                | 42                |
| case11       | 34          | 35          | 21                | 24                |
| case12       | 14782       | 14960       | 14525             | 14703             |
| case13       | 7           | 2           | 3                 | 1                 |
| case14       | 16          | 6           | 8                 | 3                 |
| GeoMean      | 222.68      | 161.97      | 152.83            | 124.46            |
| Ratio        | 1.00        | 1.00        | 0.69              | 0.77              |

**Large Benchmarks** 
Large benchmarks contain 5 long RTL code cases with much longer RTL code, which is more challengeable.

| Test Case ID | Yosys Area  |Yosys Delay  |RTLRewriter Area|RTLRewriter Delay|
|--------------|-------------|-------------|----------------|-----------------|
| CPU          | 179025.72   | 1989.76     | 167634.27      | 1592.58         |
| CNN          | 26071.46    | 15890.42    | 20104.01       | 13565.95        |
| FFT          | 71385.35    | 184098.72   | 56451.58       | 181495.83       |
| Huffman      | 106045.69   | 1544.00     | 99142.98       | 1545.64         |
| VMachine     | 1212.43     | 569.20      | 799.60         | 676.81          |
| GeoMean      | 33602.22    | 5517.98     | 27270.39       | 5279.57         |
| Ratio        | 1.00        | 1.00        | 0.81           | 0.96            |


## Prompt Examples
We provide basic prompt examples in examples.
Following is an example of prompt template.

<pre>
Now you are an experienced Verilog engineer. Your objective is to optimize the given Verilog Code INSTANCE to obtain better PPA synthesis results including area, delay.

## Verilog Code Opimization Examples

### EXAMPLE 1

Original Code:
```verilog
Verilog code here
```

Optimized Code:
```verilog
Optimized Verilog code here
```

### EXAMPLE 2

Original Code:
```verilog
Verilog code here
```

Optimized Code:
```verilog
Optimized Verilog code here
```

## Optimization Instruction

- Optimization instructon here

## Optimization Algorithm

- Optimization Algorithm here

# Guidelines:
- Make SURE complete to every step PERFECTLY without ANY Mistakes.
- Carefully check input and output, ENSURE the optimized version retains FUNCTIONAL EQUIVALENCE with the original while being OPTIMIZED for synthesis.
- End with ```verilog Your Verilog code here``` Format.

Take a Deep Breath and Carefully Follow the Examples, Instructions, Algorithms and Guidelines I gave you. I will tip you $200,000 if you OPTIMIZE the Code Perfectly.

## INSTANCE



Original Code:

```verilog
Your current Verilog code here
```
</pre>
