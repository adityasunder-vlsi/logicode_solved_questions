# Divisibility by 3 — SystemVerilog

## Problem

Design a sequential SystemVerilog circuit that reads a binary number one bit at a time and asserts `dout` when the value represented by the input stream is divisible by 3.

## My Approach

I used a remainder-based approach. For every incoming bit, the binary value represented so far updates as:

```text
next_value = 2 * current_value + din
```

Therefore, the remainder modulo 3 can be updated directly:

```systemverilog
assign next_rem = (2 * rem + din) % 3;
```

On each rising clock edge, `rem` stores the next remainder. The output is asserted when the updated remainder is zero:

```systemverilog
dout <= (next_rem == 0);
```

This approach converts the mathematical remainder calculation into sequential RTL.

## Testing

The implementation passed the functional testbench on the site.

Tested using the site's automated functional checks.

## Result

The tool reported the following results for my implementation:

- **Area:** 73.4% (as reported by the tool)
- **Performance:** 3.9% (as reported by the tool)
- **Status:** Passed

The reference implementation reported:

- **Area:** 128.87 µm²
- **Maximum Frequency:** 2127.7 MHz
- **Critical Path:** 0.470 ns

The reported area and performance figures use different formats, so an exact percentage improvement cannot be determined from these values alone.

This problem helped me understand how to convert a mathematical remainder update into sequential SystemVerilog RTL. Although my arithmetic-based implementation is concise, the `% 3` operation may infer additional combinational logic. The reference FSM-based implementation may provide better timing, depending on the synthesis results.
