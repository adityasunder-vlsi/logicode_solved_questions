# POLYNOMIAL 1

## PROBLEM

Design a module that computes:

\[
y = x^2 + 2x + 1
\]

where `x` is a signed 8-bit input and `y` is a signed 16-bit output.

## MY APPROACH

The polynomial can be simplified as:

\[
x^2 + 2x + 1 = (x+1)^2
\]

Therefore, instead of separately calculating `x²`, `2x`, and `1`, the implementation first calculates `x + 1` and then squares the result.

```systemverilog
wire signed [8:0] x_plus_1 = x + 1;
assign y = x_plus_1 * x_plus_1;
```

A 9-bit intermediate signal is used to correctly represent the signed result of `x + 1`.

## SYNTHESIS RESULTS

| Metric | My Implementation | Reference | Difference |
|---|---:|---:|---:|
| Area | 2053.22 µm² | 1861.79 µm² | +10.3% |
| Wires | 282 | 229 | +23.1% |
| Cells | 640 | 534 | +19.9% |
| Max Frequency | 280.9 MHz | 225.7 MHz | +24.5% |
| Critical Path | 3.560 ns | 4.430 ns | -19.6% |

## AREA COMPARISON

My implementation uses approximately **10.3% more area** than the reference.

- **My Area:** 2053.22 µm²
- **Reference Area:** 1861.79 µm²

The reference has the advantage in area.

## PERFORMANCE COMPARISON

My implementation performs significantly better in timing.

- **My Max Frequency:** 280.9 MHz
- **Reference Max Frequency:** 225.7 MHz
- **Improvement:** approximately **24.5%**

The critical path is also shorter:

- **My Critical Path:** 3.560 ns
- **Reference Critical Path:** 4.430 ns
- **Reduction:** approximately **19.6%**

## RESULT

The design successfully passed simulation and achieved:

- Correct polynomial computation
- Correct signed arithmetic
- Lower critical-path delay than the reference
- Higher maximum operating frequency than the reference
- Slightly higher area than the reference

## CONCLUSION

This problem demonstrates how mathematical simplification can be used to create an efficient RTL implementation.

The original expression:

\[
x^2 + 2x + 1
\]

was rewritten as:

\[
(x+1)^2
\]

The resulting implementation uses approximately **10.3% more area** than the reference but achieves approximately **24.5% higher maximum frequency** and a **19.6% shorter critical path**.

Overall, the implementation provides a strong timing-oriented solution while maintaining correct functionality.
