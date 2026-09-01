# INTEGER SQUARE ROOT — SYSTEMVERILOG RTL

## QUESTION DESCRIPTION

Design a combinational SystemVerilog module to calculate the integer square root of a signed 16-bit input. For negative inputs, `out` must be `0`. For non-negative inputs, `out` must be the largest integer satisfying `out² <= in_0`.

## LOGIC USED

The design first checks whether `in_0` is negative.

```text
in_0 < 0  →  out = 0
in_0 ≥ 0  →  find the largest i such that i² <= in_0

Since the maximum positive value of a signed 16-bit input is 32767:

181² = 32761 ≤ 32767
182² = 33124 > 32767

Therefore, the possible square root values range from 0 to 181.

A combinational for loop checks each candidate value. Whenever i*i <= in_0, out is updated with i. Since the loop moves from 0 to 181, the final valid value is the largest possible integer square root.

RTL CODE
module int_sqrt2 (
    input  logic signed [15:0] in_0,
    output logic signed [7:0] out
);

always_comb begin
    if (in_0 < 0) begin
        out = 0;
    end
    else begin
        for (int i = 0; i <= 181; i++) begin
            if (i*i <= in_0)
                out = i;
        end
    end
end

endmodule
SYNTHESIS RESULTS
METRIC	MY RTL	REFERENCE
AREA	5333.87 µm²	2597.49 µm²
MAX FREQUENCY	100.2 MHz	76.1 MHz
CRITICAL PATH	9.980 ns	13.140 ns
WIRES	995	375
CELLS	2050	810
PERFORMANCE COMPARISON

My implementation achieves a higher maximum frequency:

MY RTL      : 100.2 MHz
REFERENCE   : 76.1 MHz

This is approximately 31.7% higher frequency than the reference.

The critical path is also shorter:

MY RTL      : 9.980 ns
REFERENCE   : 13.140 ns

However, the reference implementation has significantly lower area.

MY RTL      : 5333.87 µm²
REFERENCE   : 2597.49 µm²

The reference therefore provides a better area result, while my implementation provides better timing performance.

ALTERNATIVE APPROACH

The reference uses a bit-by-bit trial approach instead of checking all values from 0 to 181.

It starts from the most significant bit and builds the square root one bit at a time. For every trial value, it checks whether:

trial² <= in_0

If the condition is satisfied, that bit is retained.

This requires only 8 iterations instead of checking 182 possible values, resulting in significantly lower area.

WHAT I LEARNED
How to implement combinational logic using always_comb.
How to handle signed inputs and negative values.
How to determine the maximum possible output from the input width.
How a bounded for loop can be used for combinational searching.
How to find the integer square root using the condition i² <= in_0.
How RTL implementation choices affect synthesized area and timing.
How a simpler brute-force approach can provide better timing but use more hardware.
How to compare different RTL architectures using synthesis results.
CONCLUSION

The implemented solution uses a straightforward bounded search from 0 to 181. It passed the testbench and achieved 100.2 MHz, compared with 76.1 MHz for the reference.

The main trade-off is that my implementation achieves better timing but uses approximately twice the area of the reference. The reference's bit-by-bit approach is more area-efficient, while the brute-force approach is simpler to understand and implement.
