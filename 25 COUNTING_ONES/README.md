# Counting Ones — Verilog

Implements: **popcount** — counts the number of `1` bits in an input vector.

`din` is an unsigned `DATA_WIDTH`-bit input, and `dout` is the output bit-count.

---

### 🔹 My Approach — Direct Bit Addition

```systemverilog
dout = 0;
for (i = 0; i < DATA_WIDTH; i = i + 1) begin
    dout = dout + din[i];
end
```

Since every `din[i]` is either `0` or `1`, each `1` automatically increases the count — no explicit comparison is needed.

**Advantages**

- Simple and concise
- No temporary variable required
- Fewer lines of code, easy to read

**Disadvantages**

- Relies on the reader recognizing that a bit can be added directly
- Slightly less explicit about intent than a checked comparison

---

### 🔹 Reference Approach — Explicit Bit Check

```systemverilog
if (din[i] == 1'b1)
    temp_dout = temp_dout + 1;
else
    temp_dout = temp_dout + 0;

dout = temp_dout;
```

Explicitly checks each bit with an `if / else` and accumulates into a temporary variable `temp_dout` before assigning it to `dout`.

**Advantages**

- Very explicit about intent
- Easy to follow for beginners

**Disadvantages**

- Requires an extra temporary variable (`temp_dout`)
- More lines of code
- Synthesizes to a larger, slower circuit (see results below)

---

## ⚖️ Comparison

| Feature            | My Implementation   | Reference Implementation |
|--------------------|----------------------|----------------------------|
| Counting method    | Direct addition      | `if / else` check          |
| Temporary variable | Not required         | `temp_dout` required       |
| Code length        | Shorter              | Longer                     |
| Readability        | Simple and concise   | More explicit               |
| Area               | **422.91 µm²**        | 539.27 µm²                 |
| Max Frequency      | **434.8 MHz**         | 326.8 MHz                  |
| Critical Path      | **2.300 ns**          | 3.060 ns                   |

---

## 📊 Result

My implementation performs better across every synthesis metric:

- ✅ **Lower area:** 422.91 µm² vs 539.27 µm²
- ✅ **Higher frequency:** 434.8 MHz vs 326.8 MHz
- ✅ **Shorter critical path:** 2.300 ns vs 3.060 ns

The main advantage is that the direct addition approach avoids the unnecessary explicit `if/else` logic and temporary assignment, resulting in simpler synthesized logic.

---

## 🛠️ Key Takeaway

Both implementations correctly count the number of 1s in the input. The **direct accumulation approach** is simpler and, in these results, more efficient in both **area** and **performance**.
