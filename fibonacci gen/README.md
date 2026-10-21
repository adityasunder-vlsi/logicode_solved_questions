# Fibonacci Generator — SystemVerilog

## Problem

Design a sequential SystemVerilog circuit that generates the Fibonacci sequence using a clock and an active-low reset.

The sequence starts with 0 and 1, with each subsequent value calculated as the sum of the previous two values.

## My Approach

I used two registers, `a` and `fib`, to store the previous Fibonacci values.

The next value is calculated using:

```text
next = a + fib
```

In SystemVerilog, this is implemented as:

```systemverilog
assign next = a + fib;
```

On every rising clock edge, the previous `fib` value is stored in `a`, while `fib` is updated with the sum:

```systemverilog
a   <= fib;
fib <= next;
```

During reset, `a` is initialized to 0 and `fib` is initialized to 1. The `DATA_WIDTH` parameter makes the design configurable for different output widths.

## Testing

The implementation passed the functional testbench on the site.

## Result

| Metric | My Implementation | Reference |
|---|---:|---:|
| Area | 19.6% | 87.7% |
| Performance | 39.9% | 12.6% |
| Status | Passed | Passed |

My approach was better than the reference implementation in both reported metrics, achieving lower area and higher performance while passing the functional testbench.
