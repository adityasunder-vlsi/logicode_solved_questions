# Modular Exponentiation — SystemVerilog

Implements:

**y = aᵇ mod m**

where `a`, `b`, `m` are unsigned 4-bit integers and `y` is an unsigned 4-bit integer.

---

## 🔹 My Approach — Repeated Modular Multiplication

result = 1
repeat b times:
result = (result × a) mod m
y = result


The logic directly builds the required power while applying the modulus after every multiplication.

**Advantages**
- Simple and easy to understand
- Directly follows the mathematical definition
- Easy to debug and verify

**Disadvantages**
- Computation scales linearly with `b`
- More multiplication/modulo operations required
- Larger hardware with a longer critical path

---

## 🔹 Reference Approach — Binary Exponentiation (Repeated Squaring)

Generates powers by squaring:

a → a² → a⁴ → a⁸


Then checks the binary bits of `b` and multiplies only the required powers.

**Example:** `b = 13 = 1101₂ = 8 + 4 + 1`
→ `a¹³ = a⁸ × a⁴ × a`

This reduces multiplication depth compared to repeated multiplication.

**Advantages**
- Smaller synthesized hardware
- Fewer cells and wires
- Shorter critical path
- Higher maximum frequency

**Disadvantages**
- More complex logic
- More intermediate signals
- Harder to understand/debug

---

## 📊 PPA Comparison

| Metric              | My Logic         | Reference        |
|---------------------|------------------|-------------------|
| Area Score          | Beats 68.5%      | Beats 91.9%       |
| Wires               | 794              | 587               |
| Cells               | 1,620            | 1,206             |
| Area                | 5,179.97 μm²     | 3,965.05 μm²      |
| Performance Score   | Beats 56.2%      | Beats 89.2%       |
| Max Frequency       | 39.0 MHz         | 42.0 MHz          |
| Critical Path       | 25.630 ns        | 23.800 ns         |

**Area:** Reference uses ~23.5% less area (5,179.97 μm² → 3,965.05 μm²)
**Performance:** Reference achieves higher max frequency (42.0 MHz vs 39.0 MHz) and shorter critical path (23.800 ns vs 25.630 ns)

---

## ✅ Conclusion

Both implementations correctly compute `y = aᵇ mod m`.

- **My implementation** → simpler, easier to understand and debug
- **Reference implementation** → more hardware-efficient (lower area, fewer cells/wires, shorter critical path, higher max frequency)

**Takeaway:** Use repeated squaring for PPA-optimized hardware; use repeated multiplication for simplicity and learning.
