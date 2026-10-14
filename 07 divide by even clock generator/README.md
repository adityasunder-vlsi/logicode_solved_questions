

## Problem Statement

> Design a module that, from the input clock, generates three output clocks with 2×, 4×, and 6× its period.
>
> While `resetn` is active all outputs are held at 0. When it deasserts, each output begins a fresh period. A period interrupted by reset restarts rather than resuming.

## Overview

An output with a period of 2N input cycles flips every N cycles. The module counts input clock edges and flips each output at chosen counts.

| Output | Period | Flips every |
|--------|--------|-------------|
| `div2` | 2 input cycles | 1 cycle |
| `div4` | 4 input cycles | 2 cycles |
| `div6` | 6 input cycles | 3 cycles |

## Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `clk` | input | Input clock |
| `resetn` | input | Active-low synchronous reset |
| `div2` | output | Clock with 2x the input period |
| `div4` | output | Clock with 4x the input period |
| `div6` | output | Clock with 6x the input period |

## Design Decisions

- **One shared counter** that runs `0, 1, 2, 3, 4, 5` and wraps to 0. A lap is 6 cycles, which is a multiple of every half-period (1, 2, 3), so all three toggle patterns fit evenly.
- **Toggle outputs.** Each output flips at specific counts:
  - `div2`: every cycle
  - `div4`: at counts 0, 2, 4
  - `div6`: at counts 0, 3
- **Registered outputs.** All three outputs come straight from flip-flops, so they are clean and glitch-free.
- **Fresh period on reset.** Reset clears the counter and all outputs, so every output restarts at the same moment when reset releases.
- **Active-low synchronous reset.**

## Implementation (submitted version)

```systemverilog
module divide_by_evens_clock (
    input  logic clk,
    input  logic resetn,
    output logic div2,
    output logic div4,
    output logic div6
);
  logic [2:0] counter;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      div2    <= 0;
      div4    <= 0;
      div6    <= 0;
      counter <= 0;
    end
    else begin
      if (counter == 5) begin
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end

      div2 <= ~div2;
      if (counter == 0 || counter == 3) begin
        div6 <= ~div6;
      end
      if (counter == 0 || counter == 2 || counter == 4) begin
        div4 <= ~div4;
      end
    end
  end
endmodule
```

## Expected Behavior

Values shown are the outputs after each clock edge.

| Edge | counter (before) | div2 | div4 | div6 |
|------|------------------|------|------|------|
| 0 | 0 | 1 | 1 | 1 |
| 1 | 1 | 0 | 1 | 1 |
| 2 | 2 | 1 | 0 | 1 |
| 3 | 3 | 0 | 0 | 0 |
| 4 | 4 | 1 | 1 | 0 |
| 5 | 5 | 0 | 1 | 0 |
| 6 | 0 | 1 | 0 | 1 |

`div4` is high for 2 cycles and low for 2. `div6` is high for 3 and low for 3.

## Verification

**6/6 simulation tests passed.**

## Synthesis Metrics vs Reference

| Metric | This design | Reference | Difference |
|--------|-------------|-----------|------------|
| Cells | 57 | 57 | same |
| Wires | 22 | 19 | 3 more |
| Area (µm²) | 206.45 | 201.44 | ~2.5% larger |
| Max frequency (MHz) | 1234.6 | 1492.5 | ~17% lower |
| Critical path (ns) | 0.810 | 0.670 | ~21% longer |

## Comparison with the Reference

| Aspect | This design | Reference |
|--------|-------------|-----------|
| Counters | One shared 3-bit counter | Three small independent counters (1, 2 and 4 bits) |
| Output style | Toggle flip-flops (registered) | Decoded from counter values (combinational) |
| Wrap logic | Explicit compare at 5 | Free-running for `cnt2` and `cnt4`; `% 6` only for `cnt6` |
| Reset | Clears counter and outputs | Clears counters only |

**Why the timing differs:** in this design the toggle decision for each output passes through a counter compare and then an enable, so the longest path is a bit deeper. In the reference, `cnt2` and `cnt4` need no compare or wrap logic at all, since they wrap naturally, and the outputs are a short decode of counter bits. This explanation comes from reading the two structures, not from the synthesis report, so check **View Report** to confirm it.

**What this design does better:** the outputs are driven directly by flip-flops. In the reference, the outputs are combinational decodes of counter bits, which can glitch when several counter bits change at once. For signals that are meant to act as clocks, flip-flop outputs are the safer practice.

## Possible Improvements

- `div4` toggles on the even counts, so `if (counter[0] == 0)` replaces the three-value compare.
- Free-running 1-bit and 2-bit counters for the shorter periods would remove the wrap compare from their paths.

Neither has been synthesized, so the effect on area and frequency is untested.

## Conclusion

The design is correct and passes all 6 tests. It uses the same architecture idea as the reference: counter-driven outputs with an active-low synchronous reset that restarts every period.

Against the reference, area is essentially a tie (57 cells each, about 2.5% larger) and timing is about 17% slower (1234.6 vs 1492.5 MHz). The gap comes from the extra compare-and-enable logic in front of each toggle flip-flop.

In exchange, all three outputs come straight from flip-flops, so they are glitch-free, which is the safer choice for clock-like signals. The reference is slightly faster, while this design has cleaner outputs.
