# Binary to Thermometer Decoder

## Problem

Convert an 8-bit binary input into a 256-bit thermometer-coded output.

For an input value `din`, the lowest `din` bits of `dout` should be `1` and the remaining bits should be `0`.

## My Approach

I noticed the pattern:

```text
din = 0 → 0000
din = 1 → 0001
din = 2 → 0011
din = 3 → 0111
din = 4 → 1111
```

This can be represented as:

```text
dout = 2^din - 1
```

In SystemVerilog, I used a left shift to generate `2^din`:

```systemverilog
dout = (1 << din) - 1;
```

## Testing

I tested different input values including:

* `0`
* `1`
* `2`
* `3`
* `4`
* `8`
* `255`

The solution passed all functional testbenches.

## Result

This was my first SystemVerilog RTL problem. The main thing I learned was how to recognize a binary pattern and convert the mathematical idea into a simple bit-level hardware operation.
Although the site's reference code was better in performance.

