
## Problem Statement

> Design a parameterized fixed-point adder for sign-magnitude operands.
>
> `a`, `b` and `c` are `N`-bit sign-magnitude values: bit `N-1` is the sign (1 for negative) and the low `N-1` bits are the magnitude. `Q` is the number of fractional bits; both operands share it, so it does not change the addition.
>
> When `a` and `b` have the same sign, `c` has that sign and its magnitude is the low `N-1` bits of the sum of the two magnitudes, so a sum that does not fit wraps. When the signs differ, the magnitude of `c` is the difference of the two magnitudes and its sign is that of the operand with the larger magnitude; equal magnitudes give +0.
>
> The module is combinational.

## Parameters and Ports

| Name | Direction | Description |
|------|-----------|-------------|
| `N` | parameter | Total width, 1 sign bit plus `N-1` magnitude bits (default 32) |
| `Q` | parameter | Fractional bits (default 15). Not used by the logic, because both operands share it |
| `a` | input [N-1:0] | First operand, sign-magnitude |
| `b` | input [N-1:0] | Second operand, sign-magnitude |
| `c` | output [N-1:0] | Result, sign-magnitude |

## Number Format

```
 bit N-1    bits N-2 ... 0
 [ sign ]   [   magnitude   ]
   1 = negative
```

There is no two's complement. The magnitude is stored as a plain unsigned number, and the sign bit says whether it is positive or negative.

## Overview

Sign-magnitude values cannot be added with a single adder, because the sign decides whether the magnitudes add or subtract. The design splits each operand into sign and magnitude and decides by case:

| Case | Result magnitude | Result sign |
|------|------------------|-------------|
| Same sign | `ma + mb` (wraps to `N-1` bits) | the shared sign |
| Different signs, `ma > mb` | `ma - mb` | sign of `a` |
| Different signs, `mb > ma` | `mb - ma` | sign of `b` |
| Different signs, equal | `0` | `0` (+0) |

## Design Decisions

- **Larger magnitude first.** Every subtraction takes the larger magnitude minus the smaller one, so the result is never negative and never wraps.
- **Three-way comparison.** The different-sign case compares `mb < ma`, `mb > ma` and equal. The equal case gives +0 without any extra check on the result.
- **Wrap-around for free.** `ma + mb` and `mc` are both `N-1` bits, so a sum that does not fit drops its top bit, as the problem requires.
- **Same-sign zeros stay as they are.** `-0 + -0` keeps the shared negative sign, which follows the problem text literally.
- **No latches.** Every path in the combinational block assigns both `sc` and `mc`.
- **`Q` is unused.** It exists only as a parameter, because the adder works on raw bits.

## Implementation (submitted version)

```systemverilog
module fixed_point_adder #(
    parameter Q = 15,
    parameter N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] c
);
  logic [N-2:0] ma, mb, mc;
  logic         sa, sb, sc;

  assign sa = a[N-1];
  assign sb = b[N-1];
  assign ma = a[N-2:0];
  assign mb = b[N-2:0];
  assign c  = {sc, mc};

  always_comb begin
    if (sa == sb) begin
      sc = sa;
      mc = ma + mb;
    end
    else begin
      if (mb < ma) begin
        sc = sa;
        mc = ma - mb;
      end
      else if (mb > ma) begin
        sc = sb;
        mc = mb - ma;
      end
      else begin
        sc = 0;
        mc = 0;
      end
    end
  end
endmodule
```

## Worked Example

`N = 8`:

| `a` | `b` | `c` | Reason |
|-----|-----|-----|--------|
| `0_0000101` (+5) | `0_0000011` (+3) | `0_0001000` (+8) | same sign, add |
| `0_0000101` (+5) | `1_0000011` (-3) | `0_0000010` (+2) | different signs, `a` larger |
| `0_0000011` (+3) | `1_0000101` (-5) | `1_0000010` (-2) | different signs, `b` larger |
| `1_0000101` (-5) | `1_0000011` (-3) | `1_0001000` (-8) | same sign, add |
| `0_1100100` (+100) | `1_1100100` (-100) | `0_0000000` (+0) | equal magnitudes give +0 |

## Verification

**All simulation tests passed.** The test list covers zero inputs, two positives, positive with a larger negative, two negatives, cancellation to zero, a sweep of mixed-sign pairs, and negative-zero cases. A formal equivalence check (every input, `N` = 5 and 8) found no difference in output between this design and the reference.

## Scores vs Reference

The submission page reports scores for area and performance (the share of other submissions each one beats):

| Metric | This design | Reference |
|--------|-------------|-----------|
| Area score | 3% | 4.5% |
| Performance score | 60.6% | 17.2% |

Raw area and frequency figures were not available, so the table uses the scores only.

For context, a separate generic-gate synthesis (open-source yosys, not the site's flow, default `N = 32`) gives:

| Design | Cells (generic) |
|--------|-----------------|
| This design | 596 |
| Reference | 552 |

## Comparison with the Reference

| Aspect | This design | Reference |
|--------|-------------|-----------|
| Structure | Separate sign and magnitude signals, joined at the output | One result vector assigned bit range by bit range |
| Sign selection | Compares `<`, `>` and equal | Splits by the sign of `a`, then compares `>` only |
| Equal magnitudes | Handled by its own branch | Detected by checking whether the subtraction result is zero |

Both give the same output for every input. The difference is how the answer is reached.

**Why the scores differ:** this design decides the sign from the comparison alone, so the comparison and the subtraction run side by side. The reference checks whether the subtraction result is zero, which puts that check after the subtractor, a longer path. That is a likely reason for the better performance score here. The reference is a bit smaller, probably because it needs one comparator where this design has two. This explanation comes from reading the two structures, not from the synthesis report, so check **View Report** to confirm it.

## Conclusion

The design is correct and passes all tests. It follows the specification: same signs add and wrap, different signs subtract the smaller magnitude from the larger, the larger operand decides the sign, and equal magnitudes give +0.

Against the reference, performance is clearly better (60.6% against 17.2%), while area is slightly worse (3% against 4.5%), so the trade-off favors speed. A possible improvement is to drop one of the two comparators, for example by testing `mb >= ma` and handling the tie in the sign. That would bring area closer to the reference. It has not been synthesized, so the effect is unknown.
