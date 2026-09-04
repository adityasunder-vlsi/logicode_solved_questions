Polynomial 5 — SystemVerilog

Problem

Design a SystemVerilog module that computes:

y = (a + b)² − (a − b)²

where a and b are signed 8-bit inputs and y is a signed 16-bit output.

My Implementation

The design uses intermediate signals for:

a + b

a - b

(a + b)²

(a - b)²

and then subtracts the two squared values.

module polynomial_5 ( 
    input  logic signed [7:0] a, 
    input  logic signed [7:0] b, 
    output logic signed [15:0] y 
);

    logic signed [8:0] A_plus_b;
    logic signed [8:0] A_minus_b;

    logic signed [15:0] A_plus_b_2;
    logic signed [15:0] A_minus_b_2;

    assign A_plus_b = a + b;
    assign A_minus_b = a - b;

    assign A_plus_b_2 = A_plus_b * A_plus_b;
    assign A_minus_b_2 = A_minus_b * A_minus_b;

    assign y = A_plus_b_2 - A_minus_b_2;

endmodule

Key Learning

The important lesson was understanding the difference between a declaration assignment and a continuous assignment.

For combinational signals that must continuously respond to changing inputs, I used:

assign A_plus_b = a + b;

instead of:

logic signed [8:0] A_plus_b = a + b;

Verification / Result

The implementation passed the automated tests.

Reported results for my implementation:

Area: 0.5%

Performance: 37.8%

Reference implementation:

Area: 37.8%

Performance: 18.1%

The exact meaning of these benchmark percentages depends on the platform's scoring methodology, but the important point is that the submitted implementation passed and produced a substantially different synthesis/optimization result from the reference.

What I Learned

Signed arithmetic in SystemVerilog

Intermediate signal sizing

Continuous assignments using assign

Combinational datapath construction

Translating a mathematical expression into synthesizable RTL

Comparing synthesis results with a reference implementation

Status

✅ Passed
