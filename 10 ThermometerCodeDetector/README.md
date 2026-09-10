# Thermometer Code Detector — SystemVerilog

## Problem

Implement a SystemVerilog thermometer code detector that asserts `isThermometer` when `codeIn` is a valid thermometer code in either orientation.

A valid thermometer code contains a continuous run of `1`s growing from either end of the word, with `0`s filling the remaining bits. A thermometer code therefore contains **exactly one 0/1 transition**.

**Examples of valid patterns:**
```
00000001
00000011
00000111
00001111
...
11111110
11111100
11111000
```

All-zero and all-one patterns are **not** valid, because they contain no transition.

**Interface**

| Signal          | Direction | Description             |
|-----------------|-----------|---------------------------|
| `codeIn`        | input     | 8-bit code to check        |
| `isThermometer` | output    | Asserted if valid thermometer code |

---

## My Logic vs Reference Logic

### My Approach — Transition counting with `!=`

```systemverilog
module thermo_code_detector (
    input logic [7:0] codeIn,
    output logic isThermometer
);

    logic [7:0] transition_count;

    always_comb begin
        isThermometer = 0;
        transition_count = 8'b00000000;

        for (int i = 0; i < 7; i++) begin
            if (codeIn[i] != codeIn[i+1]) begin
                transition_count++;
            end
        end

        if (transition_count == 1) begin
            isThermometer = 1;
        end
    end

endmodule
```

- Fixed for an 8-bit input.
- Uses an 8-bit `transition_count` to tally mismatches between adjacent bits.
- Detects a transition using `codeIn[i] != codeIn[i+1]`.
- Directly determines `isThermometer` from the transition count — no intermediate signal needed.

### Reference Approach — Parameterized with XOR

- Parameterized using `DATA_WIDTH`, so it scales to any word size.
- Uses `$clog2(DATA_WIDTH)` to size the transition counter appropriately.
- Detects transitions using XOR: `codeIn[i-1] ^ codeIn[i]`.
- Uses a separate `n_toggle` signal, then assigns `isThermometer` from `n_toggle_state`.

**Core similarity**: both designs count adjacent-bit transitions and check for exactly one. `!=` and `^` are functionally identical for single-bit comparison — the difference is style, not logic. The reference generalizes to any width via parameters; mine is a fixed, minimal 8-bit version.

**Key design insight**

A valid thermometer code has exactly one transition between adjacent bits.

```
00001111
    ↑
  0 → 1        → only one transition → valid
```

```
00110011
  ↑  ↑         → multiple transitions → invalid
```

```
01010101
 ↑ ↑ ↑ ↑ ↑ ↑ ↑  → multiple transitions → invalid
```

```
00000000        → zero transitions → invalid
11111111        → zero transitions → invalid
```

---

## Stats Comparison

| Metric               | My Implementation | Reference   | Result              |
|-----------------------|:------------------:|:-----------:|-----------------------|
| Area (µm²)            | 88.84              | 98.84       | ~10.1% smaller ✅       |
| Cells                 | 48                 | 50          | 2 fewer ✅              |
| Wires                 | 16                 | 17          | 1 fewer ✅              |
| Max Freq (MHz)        | 2083.3             | 2083.3      | Same                  |
| Critical Path (ns)    | 0.480              | 0.480       | Same                  |
| Area — beats          | 77.8%              | 21.9%       | Higher ✅               |
| Performance — beats   | 65.8%              | 65.6%       | Slightly higher ✅      |

The area reduction was achieved while maintaining the same timing performance as the reference implementation.

---

## Verification

The implementation was tested against the provided testbench.

**Result: ALL TESTBENCH CASES PASSED ✓**

Correctly handles:
- Valid thermometer codes
- Reverse-orientation thermometer codes
- All-zero input
- All-one input
- Alternating patterns
- Multi-gap patterns
- Invalid transition patterns

---

## What I Used & What I Learned

I used a **fixed 8-bit transition counter**, comparing each pair of adjacent bits with `!=` and counting mismatches — a code is a valid thermometer code exactly when that count equals 1.

**Key things I learned:**

1. **Counting transitions is a clean, general way to validate "single-run" patterns.** Instead of pattern-matching every valid shape individually, checking for exactly one 0/1 boundary captures all valid orientations and lengths at once.
2. **`!=` and `^` are equivalent for single-bit comparisons.** The reference's XOR-based transition detection and my `!=` check produce identical logic — this is purely a stylistic choice, not a functional one.
3. **Parameterization trades a little area for flexibility.** The reference's `DATA_WIDTH` parameter and `$clog2`-sized counter generalize to any width, which likely explains its slightly larger footprint versus my fixed, minimal 8-bit version.
4. **A separate intermediate signal (`n_toggle`) isn't always necessary.** Directly assigning the output from the transition count, without an extra named signal, simplified the design and trimmed a wire/cell without changing behavior.
5. **Area savings don't have to cost timing.** My implementation matched the reference's max frequency and critical path exactly, showing that a smaller design isn't automatically a slower one.

**Overall result:** Functionally correct + area-efficient + timing-equivalent.
