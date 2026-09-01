
3-Element Dot Product — SystemVerilog RTL

## Question Description

Design a SystemVerilog module to calculate the dot product of two 3-element vectors. Inputs arrive through `din` in the order `a1, a2, a3, b1, b2, b3`. After the sixth input, `run` is asserted and `dout` produces `a1*b1 + a2*b2 + a3*b3`.

## Logic Used

The design uses a 3-bit counter to track the six incoming values.

```text
0 → a1
1 → a2
2 → a3
3 → b1
4 → b2
5 → b3

Six 8-bit registers store the inputs. if conditions select which register receives din based on the counter.

On the sixth input:

run  = 1
dout = a1*b1 + a2*b2 + a3*din

din is used directly for b3 because b3 is registered on the same clock edge.

After the sixth input, the counter returns to 0 and the next set of six inputs can be captured.

Synthesis Comparison
Metric	My RTL	Reference
Area	9013.6 µm²	9013.64 µm²
Maximum Frequency	177 MHz	135 MHz
Critical Path	5.64 ns	7.410 ns
Wires	94	993
Cells	~2100	2349
Results

The area of my implementation is practically identical to the reference.

My implementation achieves better timing performance:

Maximum Frequency: 177 MHz vs 135 MHz
Critical Path: 5.64 ns vs 7.410 ns
Approximately 31% higher maximum frequency than the reference.
Alternative Approach

An alternative implementation can use an array instead of six individual registers:

logic [7:0] mem [0:5];

The counter can directly select the storage location:

mem[0] → a1
mem[1] → a2
mem[2] → a3
mem[3] → b1
mem[4] → b2
mem[5] → b3

This reduces RTL code length by replacing the six if conditions with indexed storage. The three products can also be calculated separately and then added together.

Conclusion

The final implementation uses a counter-based sequential input capture method with six 8-bit registers. It achieves almost the same area as the reference while providing better timing performance, reaching 177 MHz compared with 135 MHz for the reference.
