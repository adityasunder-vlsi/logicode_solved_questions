# Counter Module

## Description

I designed a counter module that increases by 1 every clock cycle when `running` is active. `start` starts the counter, `stop` halts it, and `reset` clears the count to 0 and stops the counter.

**Priority:** Reset > Stop > Start

I used a `running` variable to remember the counter state because `start` and `stop` are pulses.

The counter wraps back to 0 when it reaches `MAX`.

## Reference Code Comparison

The reference uses `temp`, `next_temp`, `state`, and `next_state` to separate current and next values.

My design uses a simpler `count + running` approach, which I found easier to understand.

**Start → running = 1 → count increases**

**Stop → running = 0 → count holds**

**Reset → count = 0, running = 0**

**MAX → count wraps to 0**

## Performance & Area

### My Design

- Area: **728.20 µm²**
- Cells: **229**
- Wires: **60**
- Max Frequency: **543.5 MHz**
- Critical Path: **1.840 ns**
- Performance: **73.5%**
- Area Score: **9.6%**

### Reference Design

- Area: **645.62 µm²**
- Cells: **181**
- Wires: **59**
- Max Frequency: **520.8 MHz**
- Critical Path: **1.920 ns**
- Performance: **65.2%**
- Area Score: **57.1%**

## Comparison

My design uses more area than the reference, but it achieves better timing performance.

The maximum frequency improved from **520.8 MHz to 543.5 MHz**, while the critical path decreased from **1.920 ns to 1.840 ns**.

Overall, my implementation trades some additional area for better performance and uses a simpler `running`-based approach.

