Modular Exponentiation — SystemVerilog





Problem

Implement:

y = a^b mod m

where a, b, and m are unsigned 4-bit integers and y is an unsigned 4-bit integer.

My Logic

Repeated Modular Multiplication

I used a simple repeated-multiplication approach:

result = 1

repeat b times:
    result = (result × a) mod m

y = result

The logic directly builds the required power while applying the modulus after every multiplication.

Advantages

Simple and easy to understand.

Directly follows the mathematical definition.

Easy to debug and verify.

Disadvantages

The amount of computation increases with b.

More multiplication/modulo operations are required.

Produces larger hardware with a longer critical path.

Reference Logic

Binary Exponentiation / Repeated Squaring

The reference implementation generates powers by squaring:

a → a² → a⁴ → a⁸

It then checks the binary bits of b and multiplies only the required powers.

For example:

b = 13 = 1101₂

13 = 8 + 4 + 1

a¹³ = a⁸ × a⁴ × a

This reduces the multiplication depth compared with repeatedly multiplying by a.

Advantages

Smaller synthesized hardware.

Fewer cells and wires.

Shorter critical path.

Higher maximum frequency.

Disadvantages

More complicated logic.

More intermediate signals.

Harder to understand and debug.

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

Area

The reference uses approximately 23.5% less area:

5,179.97 μm² → 3,965.05 μm²

Performance

The reference also performs better:

Maximum frequency: 42.0 MHz vs 39.0 MHz

Critical path: 23.800 ns vs 25.630 ns

Conclusion

Both implementations correctly compute y = a^b mod m.

My implementation is simpler and easier to understand, while the reference implementation is more hardware-efficient.

The synthesis results show that the repeated-squaring approach achieves:

Lower area

Fewer cells and wires

Shorter critical path

Higher maximum frequency

Therefore, the reference approach is better for hardware PPA, while my approach is better for simplicity and learning.
