<h1 align="center">Rising-Edge Detector in SystemVerilog</h1>

<p align="center">
A two-flip-flop edge detector that pulses one cycle after each rising edge of <code>din</code>.<br>
<b>All tests passed</b>
</p>

---

## Problem Statement

> Design a module that pulses `dout` one cycle after the rising edge of `din`. A pulse is defined as writing a single-cycle `1` as shown in the examples. When `resetn` is asserted, the value of `din` should be treated as `0`.

## Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `clk` | input | Clock |
| `resetn` | input | Active-low synchronous reset |
| `din` | input | Signal to watch |
| `dout` | output | One-cycle pulse after each rising edge of `din` |

## Overview

A rising edge is a change from 0 to 1. A circuit that only looks at the current `din` cannot tell a rise from a signal that was already high, so the design remembers `din` from one clock earlier and compares the two values:

- earlier value `0` and current value `1` means a rising edge
- any other combination means no edge

## Design Decisions

- **One flip-flop remembers the earlier `din`** (`din_early`). It is 1 bit wide, because it stores a single earlier sample.
- **One gate detects the edge:** `din_early == 0` and `din == 1`.
- **`dout` is registered.** Storing the comparison in a flip-flop delays the pulse by one cycle, as required, and makes it exactly one cycle wide, because `din_early` catches up on the next edge.
- **Reset clears both `din_early` and `dout`.** Clearing `din_early` makes the earlier value 0, which treats `din` as 0 during reset. Clearing `dout` stops a pulse while reset is active.
- **Active-low synchronous reset.**

## Implementation (submitted version)

```systemverilog
module edge_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  logic din_early;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      dout      <= 0;
      din_early <= 0;
    end
    else begin
      din_early <= din;
      dout      <= (din_early == 0) && (din == 1);
    end
  end
endmodule
```

## Behavior

Values of `din` sampled at each clock edge, with `dout` shown after that edge:

| Edge | `din` | `din_early` before | `dout` after |
|------|-------|--------------------|--------------|
| 1 | 0 | 0 | 0 |
| 2 | 0 | 0 | 0 |
| 3 | 1 | 0 | **1** |
| 4 | 1 | 1 | 0 |
| 5 | 1 | 1 | 0 |
| 6 | 0 | 1 | 0 |
| 7 | 1 | 0 | **1** |
| 8 | 0 | 1 | 0 |

`din` stays high for three edges but produces a single pulse, and the second rise produces its own pulse.

## Verification

**All simulation tests passed.** A formal equivalence check (16 cycles from reset) found no difference in output behavior between this design and the reference.

## Scores vs Reference

The submission page reports scores for area and performance (the share of other submissions each one beats):

| Metric | This design | Reference |
|--------|-------------|-----------|
| Area score | 61.4% | 1.9% |
| Performance score | 33.3% | 1.9% |

Raw area and frequency figures were not available, so the table uses the scores only.

For context, a separate generic-gate synthesis (open-source yosys, not the site's flow) gives:

| Design | Cells (generic) |
|--------|-----------------|
| This design | 3 (2 flip-flops + 1 gate) |
| Reference | 14 |

## Comparison with the Reference

| Aspect | This design | Reference |
|--------|-------------|-----------|
| Method | Remember the earlier `din`, compare with the current one | 4-state FSM tracking `din` history (`S00`, `S01`, `S10`, `S11`) |
| Memory | 1 bit of history plus the output flip-flop | 2-bit state register |
| Output | Registered `dout` | `dout` decoded from the state (`state == S01`) |
| Next-state logic | One AND-NOT gate | A `case` with four states and two branches each |

Both produce the same output on every input sequence. The reference reaches it with a state machine, while this design stores only what the problem needs: the previous value of `din`.

## Conclusion

The design is correct and passes all tests. It detects a rising edge by comparing the current `din` with the stored previous value, and delays the pulse by registering the result, so it is one cycle wide and one cycle late.

It beats the reference on both reported scores: 61.4% against 1.9% for area, and 33.3% against 1.9% for performance. The gain comes from using the simplest structure, a single-bit history instead of a four-state machine.

The performance score is lower than the area score, so there may be more speed to find. One place to look is the synchronous reset, which can add gating ahead of the flip-flops. That has not been tested.
