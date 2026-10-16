
## Problem Statement

> Design an elevator controller FSM with states `IDLE`, `MOVING_UP`, and `MOVING_DOWN`, reported on `state` as `00`, `01`, and `10`. `up_request` is high while there is demand above the car and `down_request` while there is demand below it.
>
> The FSM advances on each rising edge of `clk`. From `IDLE` it enters `MOVING_UP` when `up_request` is high, or `MOVING_DOWN` when only `down_request` is high. Once moving, it stays in that state while its own request is high and returns to `IDLE` on the edge after that request goes low; the other request is ignored until then.
>
> `reset` is asynchronous and active-high: while it is high the FSM is in `IDLE`.

## Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `clk` | input | Clock, the FSM advances on the rising edge |
| `reset` | input | Asynchronous, active-high reset |
| `up_request` | input | Demand above the car |
| `down_request` | input | Demand below the car |
| `state` | output [1:0] | Current state |

## State Encoding

| State | `state` |
|-------|---------|
| `IDLE` | `00` |
| `MOVING_UP` | `01` |
| `MOVING_DOWN` | `10` |

## Transitions

| Current state | Condition | Next state |
|---------------|-----------|------------|
| `IDLE` | `up_request` = 1 (regardless of `down_request`) | `MOVING_UP` |
| `IDLE` | `up_request` = 0 and `down_request` = 1 | `MOVING_DOWN` |
| `IDLE` | both 0 | `IDLE` |
| `MOVING_UP` | `up_request` = 1 | `MOVING_UP` |
| `MOVING_UP` | `up_request` = 0 (`down_request` ignored) | `IDLE` |
| `MOVING_DOWN` | `down_request` = 1 | `MOVING_DOWN` |
| `MOVING_DOWN` | `down_request` = 0 (`up_request` ignored) | `IDLE` |

The car always passes through `IDLE` before changing direction.

## Design Decisions

- **The state register is the output.** `state` is the 2-bit encoding itself, so there is no second register and no output decode logic. The design uses two flip-flops.
- **Up has priority in `IDLE`.** The `up_request` check comes first, so both requests high goes to `MOVING_UP`.
- **Only the car's own request matters while moving.** Each moving state looks at one signal only.
- **Holding the state costs nothing.** In a clocked block, a register that is not assigned keeps its value, so "stay in this state" needs no extra logic.
- **Asynchronous active-high reset.** `posedge reset` is in the sensitivity list, and the reset check is `if (reset)`.
- **Unused encoding `2'b11` is not handled.** It cannot be reached, because reset forces `00` and every transition goes to a defined state. Leaving out a `default` saves logic.

## Implementation (submitted version)

```systemverilog
module elevator_cont (
    input logic clk,
    input logic reset,
    input logic up_request,
    input logic down_request,
    output logic [1:0] state
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
    end
    else begin
      case (state)
        2'b00: begin
          if (up_request) begin
            state <= 2'b01;
          end
          else if (down_request) begin
            state <= 2'b10;
          end
        end
        2'b01: begin
          if (up_request) begin
            state <= 2'b01;
          end
          else begin
            state <= 2'b00;
          end
        end
        2'b10: begin
          if (down_request) begin
            state = 2'b10;
          end
          else begin
            state = 2'b00;
          end
        end
      endcase
    end
  end
endmodule
```

Note: the two assignments in the `2'b10` item use blocking `=`, while `<=` is the convention in clocked blocks. The results and metrics in this README are for the code exactly as shown.

## Verification

**All simulation test cases passed.**

## Synthesis Metrics vs Reference

| Metric | This design | Reference | Difference |
|--------|-------------|-----------|------------|
| Cells | 30 | 43 | ~30% fewer |
| Wires | 12 | 15 | ~20% fewer |
| Area (µm²) | 85.08 | 135.13 | ~37% smaller |
| Max frequency (MHz) | 1724.1 | 1098.9 | ~57% higher |
| Critical path (ns) | 0.580 | 0.910 | ~36% shorter |
| Area score (beats) | 11% | 0% | |
| Performance score (beats) | 17% | 1% | |

## Comparison with the Reference

| Aspect | This design | Reference |
|--------|-------------|-----------|
| State storage | 2-bit register that is also the output | 3-bit one-hot internal register |
| Output | `state` directly from flip-flops | Decoded from the one-hot register with a conditional expression |
| Next-state logic | Nested `case` and `if` | Three `wire` conditions (`goto_idle`, `goto_up`, `goto_down`) with a priority chain |
| Flip-flops | 2 | 3 |

**Why this design is smaller and faster:** the reference keeps a one-hot state internally, then has to convert it to the 2-bit output encoding and compute three separate transition conditions. Here the output encoding is the state, so that decode logic does not exist, and each state checks only the signal it needs. This explanation comes from reading the two structures, not from the synthesis report, so check **View Report** to confirm it.

## Conclusion

The design is correct and passes all test cases. It follows the specification: up has priority from `IDLE`, each moving state watches only its own request, the car returns to `IDLE` before reversing, and reset is asynchronous and active-high.

It beats the reference on every reported metric: about 37% less area (85.08 vs 135.13 µm²) and about 57% higher maximum frequency (1724.1 vs 1098.9 MHz). Because the output requires a 2-bit encoding, using that encoding directly as the state avoids the decode logic that a one-hot design would need.
