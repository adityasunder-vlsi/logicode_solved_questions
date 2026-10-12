

## Problem Statement

> Design a module with an internal counter that increments every clock cycle while `resetn` is deasserted, counting from `0` and restarting when `MAX_CYCLES` is reached. Each cycle, assert `fizz` when the count is evenly divisible by `FIZZ`, `buzz` when it is divisible by `BUZZ`, and `fizzbuzz` when it is divisible by both.

## Overview

A counter increments every clock cycle while `resetn` is deasserted, counting from `0` and wrapping back to `0` after `MAX_CYCLES - 1`. Each cycle, three outputs describe the current count:

| Output | High when |
|--------|-----------|
| `fizz` | `count % FIZZ == 0` |
| `buzz` | `count % BUZZ == 0` |
| `fizzbuzz` | divisible by both |

## Parameters and Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `FIZZ` | parameter | Divisor for `fizz` (default 3) |
| `BUZZ` | parameter | Divisor for `buzz` (default 5) |
| `MAX_CYCLES` | parameter | Counter period (default 100) |
| `clk` | input | Clock |
| `resetn` | input | Active-low synchronous reset |
| `fizz`, `buzz`, `fizzbuzz` | output | Divisibility flags |

## Design Decisions

- **Synchronous, active-low reset.** The counter is held at 0 while `resetn` is low.
- **Wrap at `MAX_CYCLES - 1`.** The count sequence is `... MAX_CYCLES-2, MAX_CYCLES-1, 0, 1 ...`, so one period is exactly `MAX_CYCLES` cycles.
- **Combinational outputs.** `fizz`, `buzz` and `fizzbuzz` are driven directly from the current count, so they always describe the count visible in the same cycle. Registering them would make them lag one cycle behind.
- **`fizzbuzz = fizz && buzz`.** No extra modulo is needed.
- **Count 0 is divisible by everything**, so all three outputs are high at count 0.

## Implementation (submitted version)

```systemverilog
module fizzbuzz #(
    parameter FIZZ = 3,
    BUZZ = 5,
    MAX_CYCLES = 100
) (
    input  logic clk,
    input  logic resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);
  int count = 0;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      count <= 0;
    end
    if (resetn) begin
      if (count == MAX_CYCLES - 1) count <= 0;
      else count <= count + 1;
    end
  end

  assign fizz     = (count % FIZZ == 0);
  assign buzz     = (count % BUZZ == 0);
  assign fizzbuzz = fizz && buzz;
endmodule
```

## Verification

**6/6 simulation tests passed**, including "reset held low for 30 cycles".

## Synthesis Metrics vs Reference

| Metric | This design | Reference | Difference |
|--------|-------------|-----------|------------|
| Cells | 1,062 | 155 | ~6.9x more |
| Wires | 481 | 65 | ~7.4x more |
| Area (µm²) | 3,404.52 | 520.50 | ~6.5x larger |
| Max frequency (MHz) | 68.4 | 552.5 | ~8x slower |
| Critical path (ns) | 14.610 | 1.810 | ~8x longer |

## Comparison with the Reference

The architecture is the same: synchronous active-low reset, wrap at `MAX_CYCLES - 1`, combinational outputs. The differences are small in code but large in hardware:

| Aspect | This design | Reference |
|--------|-------------|-----------|
| Counter type | `int` (32 bits) | `logic [$clog2(MAX_CYCLES)-1:0]` (7 bits at default) |
| Initializer | `= 0` on declaration | none, relies on reset |
| Reset structure | two separate `if`s | single `if / else` |
| Output block | `assign` | `always_comb` (equivalent) |

**Why the metrics differ:** the counter is 32 bits wide, so both `%` operations are 32-bit dividers, which are large and slow. Sizing the counter with `$clog2` shrinks those dividers to the bits actually needed, which is where nearly all of the area and timing gap comes from.

## Improvement Path

```systemverilog
logic [$clog2(MAX_CYCLES)-1:0] count;   // instead of: int count = 0;

always_ff @(posedge clk) begin
  if (!resetn)                         count <= 0;
  else if (count == MAX_CYCLES - 1)    count <= 0;
  else                                 count <= count + 1;
end
```

This one change is expected to bring area and frequency close to the reference. It has not been measured here.

## Lessons Learned

- Outputs assigned inside a clocked block are registered and lag the count by one cycle. This caused the initial 6 failing tests.
- A `for` loop in an `always` block does not step per clock; the counter does that.
- Use `<=` in clocked blocks, and `==` (not `=`) for comparisons.
- Size counters to the range they need; a default `int` is 32 bits.
