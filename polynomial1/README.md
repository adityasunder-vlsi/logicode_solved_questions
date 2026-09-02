# POLYNOMIAL 1

## PROBLEM

Design a module that computes:

\[
y = x^2 + 2x + 1
\]

where `x` is a signed 8-bit input and `y` is a signed 16-bit output.

## MY APPROACH

Instead of implementing the polynomial directly as:

\[
x^2 + 2x + 1
\]

I recognized that the expression can be simplified using:

\[
x^2 + 2x + 1 = (x+1)^2
\]

Therefore, the implementation first calculates `x + 1` and then squares the result.

```systemverilog
wire signed [8:0] x_plus_1 = x + 1;
assign y = x_plus_1 * x_plus_1;

The intermediate signal is 9 bits wide to safely handle the signed range after adding 1.

SYNTHESIS RESULTS
Metric	My Implementation	Reference	Difference
Area	2053.22 µm²	1861.79 µm²	+10.3%
Wires	282	229	+23.1%
Cells	640	534	+19.9%
Max Frequency	280.9 MHz	225.7 MHz	+24.5%
Critical Path	3.560 ns	4.430 ns	-19.6%
AREA COMPARISON

My implementation uses approximately 10.3% more area than the reference.

The reference:

Area = 1861.79 µm²

My implementation:

Area = 2053.22 µm²

So the reference has the advantage in area.

PERFORMANCE COMPARISON

My implementation performs significantly better in timing.

My Max Frequency  = 280.9 MHz
Reference         = 225.7 MHz

This gives approximately 24.5% higher maximum frequency than the reference.

The critical path also improved:

My Critical Path = 3.560 ns
Reference        = 4.430 ns

This is approximately 19.6% shorter than the reference critical path.

RESULT

The implementation successfully passed simulation and achieved:

Lower critical-path delay
Higher maximum operating frequency
Slightly higher area
Correct signed arithmetic
A simplified mathematical implementation using (x+1)^2
CONCLUSION

This problem was a good example of using mathematical simplification to reduce the complexity of RTL.

Rather than directly implementing:

x² + 2x + 1

the expression was rewritten as:

(x + 1)²

The resulting design sacrifices approximately 10.3% area compared with the reference but achieves approximately 24.5% better maximum frequency.

Overall, the implementation provides a strong timing-oriented solution while maintaining correct functionality.
