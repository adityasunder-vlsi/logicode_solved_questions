Modular Exponentiation — SystemVerilog

Problem

Implement:

y = a^b mod m

where a, b, and m are unsigned 4-bit integers and y is an unsigned 4-bit integer.

Approach

My Logic — Repeated Modular Multiplication

I used a simple iterative combinational approach:

result = 1
repeat b times:
    result = (result × a) mod m
y = result

The main advantage is that the logic is straightforward and easy to understand.

Reference Logic — Binary Exponentiation

The reference implementation uses repeated squaring:

a → a² → a⁴ → a⁸

It checks the binary bits of b and multiplies only the powers required by the exponent.

This gives a more optimized hardware structure.

PPA Comparison

Metric

My Logic

Reference

Area Score

Beats 68.5%

Beats 91.9%

Wires

794

587

Cells

1,620

1,206

Area

5,179.97 μm²

3,965.05 μm²

Performance Score

Beats 56.2%

Beats 89.2%

Max Frequency

39.0 MHz

42.0 MHz

Critical Path

25.630 ns

23.800 ns

Pros and Cons

My Logic

Pros

Simple and easy to understand.

Easy to implement and debug.

Directly follows the repeated-multiplication definition of modular exponentiation.

Cons

Requires more multiplication/modulo operations as b increases.

Produces a larger synthesized circuit.

Has a longer critical path and lower maximum frequency.

Reference Logic

Pros

Uses fewer effective multiplication stages.

Lower cell count and wire count.

Smaller area.

Shorter critical path and higher maximum frequency.

Cons

More complicated to understand.

More intermediate signals and logic are required.

Harder to write and debug compared with the simple repeated-multiplication approach.

Conclusion

Both implementations correctly compute y = a^b mod m.

My implementation is simpler and easier to understand, but the reference implementation is more hardware-efficient.

The synthesis results show that the reference uses about 23.5% less area and achieves a higher maximum frequency (42.0 MHz vs 39.0 MHz) with a shorter critical path (23.800 ns vs 25.630 ns).

For learning and simplicity, the repeated-multiplication approach is preferable. For better hardware PPA, the repeated-squaring approach is the better choice.
