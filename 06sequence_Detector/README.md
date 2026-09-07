# Sequence Detector (1010) — SystemVerilog

## Problem

Design a module that, given a stream of input bits, pulses a `1` on the output `dout` whenever a `1010` sequence is detected on the input `din`.

- If two sequences overlap, `dout` should pulse for both.
- When the reset-low signal `resetn` goes active, the module should ignore all previously seen bits.

**Interface**

| Signal    | Direction | Description          |
|-----------|-----------|-----------------------|
| `clk`     | input     | Clock                 |
| `resetn`  | input     | Active-low sync reset |
| `din`     | input     | Serial bit stream     |
| `dout`    | output    | Pulses on match       |

---

## My Logic vs Reference Logic

### My Approach — Array-based shift register + combinational compare

```systemverilog
module seq_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  logic [3:0] seq = 4'b1010;
  logic arr[3];   // history of last 3 bits (not including current din)

  always_ff @(posedge clk) begin
    if (!resetn) begin
      arr[0] <= 0;
      arr[1] <= 0;
      arr[2] <= 0;
    end
    else begin
      arr[0] <= arr[1];
      arr[1] <= arr[2];
      arr[2] <= din;
    end
  end

  assign dout = (arr[0]==seq[3] && arr[1]==seq[2] && arr[2]==seq[1] && din==seq[0]);

endmodule
```

- **Memory**: a 3-element array (`arr`) acting as a shift register, holding the last 3 bits seen. Updated only on the clock edge (`always_ff`).
- **Detection**: a purely combinational `assign` statement that checks the stored history plus the live `din` against the pattern, every cycle.
- Splitting "remembering the past" from "checking the present" is what lets `dout` react in the *same* cycle the 4th bit of the pattern arrives, with no extra clock delay.

### Reference Approach — Finite State Machine (FSM)

```systemverilog
module seq_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  parameter S0 = 0, S1 = 1, S10 = 2, S101 = 3;
  logic [1:0] state, next_state;

  always_ff @(posedge clk) begin
    if (!resetn) state <= S0;
    else state <= next_state;
  end

  always_comb begin
    case (state)
      S0:    next_state = din ? S1 : S0;
      S1:    next_state = din ? S1 : S10;
      S10:   next_state = din ? S101 : S0;
      S101:  next_state = din ? S1 : S10;
      default: next_state = S0;
    endcase
  end

  assign dout = (state == S101 && din == 0);

endmodule
```

- **Memory**: a 2-bit `state` register encoding "how much of the pattern has been seen so far" (`S0`, `S1`, `S10`, `S101`).
- **Detection**: same idea — a combinational `assign` checks the current state plus live `din`.
- Uses named states instead of an array of raw history bits — a more classic Moore/Mealy-style encoding.

**Core similarity**: both designs separate a registered "memory of progress" from a combinational "did it just complete" check. That combinational output is what makes `dout` pulse exactly on the cycle the pattern finishes, and lets overlapping matches (`101010...`) fire correctly with zero extra bookkeeping.

---

## Stats Comparison

| Metric                | My Solution | Reference | Result             |
|------------------------|:-----------:|:---------:|---------------------|
| Wires                  | 8           | 11        | Fewer wires ✅        |
| Cells                  | 26          | 34        | Fewer cells ✅        |
| Area (µm²)             | 88.84       | 123.87    | Smaller area ✅       |
| Area — beats           | 87.9%       | 52%       | Higher ✅             |
| Max Freq (MHz)         | 2564.1      | 1639.3    | Higher ✅             |
| Critical Path (ns)     | 0.390       | 0.610     | Shorter ✅            |
| Performance — beats    | 100%        | 45.6%     | Higher ✅             |

My array-based shift-register solution came out smaller *and* faster than the FSM reference — fewer cells/wires for area, and a shorter critical path for a higher max clock frequency.

---

## What I Used & What I Learned

I used a **3-element array as a shift register** to hold the recent bit history, combined with a **combinational `assign` statement** to detect the pattern the instant the final bit arrives — rather than registering the output itself.

**Key things I learned:**

1. **Not everything needs to be registered.** My early attempts drove `dout` with `<=` inside `always_ff`, which delayed the output by one extra clock cycle. Splitting "memory" (registered) from "detection" (combinational) fixed the timing without changing the underlying logic.
2. **An array of bits can replace named FSM states.** The reference's `state` register and my `arr` array both encode "progress toward the pattern" — just represented differently. Arrays generalize more easily to longer or different patterns without hand-naming every state.
3. **Overlap handling is free** when detection is combinational and re-evaluated every cycle — no special-case logic is needed to let `101010` pulse twice.
4. **Reset must clear all memory**, not just the output — otherwise stale history can cause false matches right after reset.
5. Small, simple combinational logic on top of a short shift register tends to produce a **short critical path**, which directly translates to a much higher achievable clock frequency — as shown by the synthesis results above.
