# Integer Square Root — SystemVerilog

## Problem
Design a combinational circuit that computes the integer square root of a signed 16-bit input.

The output is the largest integer `root` satisfying:

\[
root^2 \leq in\_0
\]

For negative inputs, the output is `0`.

## My Approach
- Implemented an 8-bit bit-by-bit integer square-root algorithm.
- Used an 8-iteration loop, testing candidate bits from MSB to LSB.
- Accepted each candidate bit only when its square remained less than or equal to the input.
- Used `always_comb` for combinational logic.

## PPA Results

| Metric | Result |
|---|---:|
| Area | 2660.05 µm² |
| Cells | 848 |
| Wires | 394 |
| Maximum Frequency | 77.9 MHz |
| Critical Path | 12.840 ns |

## Optimization
Replaced the original 182-iteration candidate-search loop with an 8-iteration bitwise approach to reduce the number of algorithmic iterations.

## Conclusion
Implemented an 8-iteration combinational integer square-root design and evaluated its area and timing using the platform's synthesis results.
