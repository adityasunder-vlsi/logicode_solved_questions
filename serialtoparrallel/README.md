

## Problem Statement

> Design a serial-to-parallel converter. Each cycle `din_valid` is high, one bit is accepted from `din_serial`. After 8 valid bits, the assembled byte appears on `dout_parallel`, with the first received bit in the most significant position and the last in the least significant, and `dout_valid` pulses for exactly one cycle.
>
> If `din_valid` deasserts at any point, the bit counter clears and accumulation restarts with the next valid bit. `rst_n` is an asynchronous active-low reset that clears all outputs and internal state.

## Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `clk` | input | Clock |
| `rst_n` | input | Asynchronous, active-low reset |
| `din_serial` | input | Serial data bit |
| `din_valid` | input | The bit on `din_serial` counts only while this is high |
| `dout_parallel` | output [7:0] | The assembled byte |
| `dout_valid` | output | One-cycle pulse when `dout_parallel` holds a new byte |

## Overview

Each valid bit is shifted into an 8-bit register from the bottom, which pushes earlier bits upward. After 8 shifts, the first bit sits in the most significant position and the last in the least significant, so the required bit order needs no extra work.

```
bits in : 1 0 1 1 0 0 1 0   (first to last)
result  : 1 0 1 1 0 0 1 0 = 0xB2
```

A 3-bit counter tracks how many valid bits have been taken, and one flag marks that the byte is complete.

## Design Decisions

- **Shift register.** Each valid bit is joined at the bottom (`{shift[6:0], din_serial}`), so the first bit ends up on top.
- **3-bit counter.** It counts 0 to 7, which is enough for 8 bits, and clears whenever `din_valid` is low.
- **A `full` flag delays the output by one cycle.** It is set when the 8th bit is accepted, and on the next edge it drives `dout_valid` and copies the byte to `dout_parallel`. It clears itself every cycle, so the pulse is exactly one cycle wide.
- **The bit in the cycle after the 8th is ignored.** While `full` is set, the input is not shifted in and the counter stays at 0. The reference behaves the same way, so back-to-back bytes need one idle cycle between them.
- **`dout_parallel` holds its value** between pulses and only updates when a byte completes.
- **Asynchronous active-low reset** clears the counter, shift register, flag and both outputs.

## Implementation

```systemverilog
module serial2parallel (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       din_serial,
    input  logic       din_valid,
    output logic [7:0] dout_parallel,
    output logic       dout_valid
);
  logic [2:0] count;
  logic [7:0] shift;
  logic       full;  

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count         <= 0;
      shift         <= 0;
      full          <= 0;
      dout_parallel <= 0;
      dout_valid    <= 0;
    end
    else begin
      dout_valid <= full;
      full       <= 0;
      if (full) begin
        dout_parallel <= shift;
        count         <= 0;
      end
      else if (din_valid) begin
        shift <= {shift[6:0], din_serial};
        if (count == 7) begin
          full  <= 1;
          count <= 0;
        end
        else begin
          count <= count + 1;
        end
      end
      else begin
        count <= 0;
      end
    end
  end
endmodule
```

## Behavior

One byte with `din_valid` high for 8 consecutive bits (`1, 0, 1, 1, 0, 0, 1, 0`):

| Clock edge | What happens | `dout_valid` after | `dout_parallel` after |
|------------|--------------|--------------------|-----------------------|
| 1 to 7 | bits 1 to 7 shifted in, counter counts up | 0 | `00` |
| 8 | 8th bit shifted in, `full` set, counter cleared | 0 | `00` |
| 9 | `full` drives the outputs | **1** | **`B2`** |
| 10 | `full` is already clear | 0 | `B2` |

## Verification

**All simulation tests passed**, including all-zeros and all-ones bytes, the known byte `0xA5`, `din_valid` dropping mid-byte, reset mid-byte, and two consecutive bytes (`0xC3` then `0x3C`).

The design was also simulated against the reference for 300,000 random cycles, with `din_valid` mostly high and random asynchronous resets. The outputs matched on every cycle.

## Synthesis Metrics vs Reference

| Metric | This design | Reference | Difference |
|--------|-------------|-----------|------------|
| Wires | 34 | 35 | 1 fewer |
| Cells | 130 | 134 | ~3% fewer |
| Area (µm²) | 753.22 | 770.74 | ~2% smaller |
| Max frequency (MHz) | 813.0 | 520.8 | ~56% higher |
| Critical path (ns) | 1.230 | 1.920 | ~36% shorter |
| Area score (beats) | 57% | 32% | |
| Performance score (beats) | 65% | 8% | |

## Comparison with the Reference

| Aspect | This design | Reference |
|--------|-------------|-----------|
| Counter | 3 bits (0 to 7) plus a `full` flag | 4 bits (0 to 8), where 8 means "byte complete" |
| Output trigger | A single flag bit, `full` | A comparison of the counter against 8 |
| Output timing | One cycle after the 8th bit | One cycle after the 8th bit |
| Behavior | Identical on every cycle | Identical on every cycle |

Both designs give the same outputs cycle for cycle. They differ in how the "byte complete" moment is remembered.

**Why this design is faster:** the nine output flip-flops are enabled by `full`, which is a flip-flop output, so the enable arrives directly. The reference first compares a 4-bit counter against 8 before it can enable them, which adds logic to the path. The area gain is small, since both designs use about the same number of flip-flops. This explanation comes from reading the two structures, not from the synthesis report, so check **View Report** to confirm it.

## Conclusion

The design is correct and passes all tests. It shifts each valid bit in from the bottom, which gives the required bit order, and it pulses `dout_valid` for exactly one cycle with the finished byte one cycle after the 8th bit.

Against the reference it is smaller (753.22 vs 770.74 µm²) and much faster (813.0 vs 520.8 MHz), with scores of 57% and 65% against 32% and 8%. The speed gain comes from storing "the byte is complete" in a flag instead of decoding it from a wider counter.
