# Integer Square Root — SystemVerilog

## Problem
Design a combinational circuit that computes the integer square root of a signed 16-bit input.
The output is the largest integer root satisfying:

`root² ≤ in_0`

*(For negative inputs, the output is 0.)*

## My Approach
- **Algorithm:** Implemented an 8-bit bit-by-bit integer square-root algorithm.
- **Execution:** Used an 8-iteration loop, testing candidate bits from MSB to LSB.
- **Validation:** Accepted each candidate bit only when its square remained less than or equal to the input.
- **Hardware Design:** Used `always_comb` for pure combinational logic.

## Optimization
Replaced the original 182-iteration candidate-search loop with an 8-iteration bitwise approach to drastically reduce the number of algorithmic iterations and improve hardware efficiency.

## PPA Results

| Metric | Result |
| :--- | :--- |
| **Area** | 2660.05 µm² |
| **Cells** | 848 |
| **Wires** | 394 |
| **Maximum Frequency** | 77.9 MHz |
| **Critical Path** | 12.840 ns |

### Platform Evaluation

![Platform Evaluation Results](image_d537bc.png)

## Conclusion
Implemented an 8-iteration combinational integer square-root design and evaluated its area and timing using the platform's synthesis results.