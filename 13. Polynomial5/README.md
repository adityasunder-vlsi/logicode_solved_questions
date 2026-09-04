Polynomial 5

📌 Problem Statement

Design a SystemVerilog module that computes:

y = (a + b)² − (a − b)²

Input

a → Signed 8-bit input

b → Signed 8-bit input

Output

y → Signed 16-bit output

💡 Design Approach

The expression is implemented using intermediate signals:

a + b
  ↓
(a + b)²

a − b
  ↓
(a − b)²

Both squared values
  ↓
Subtract
  ↓
y

🧑‍💻 My SystemVerilog Code

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

🔑 Key Learning

The main issue I learned from this problem was the difference between declaration assignment and continuous assignment.

❌ Initial Attempt

logic signed [8:0] A_plus_b = a + b;

✅ Correct Combinational Assignment

assign A_plus_b = a + b;

Using assign makes the intermediate signal continuously follow changes in a and b.

📐 Mathematical Simplification

The expression can also be simplified mathematically:

(a + b)² − (a − b)²

Expanding:

(a² + 2ab + b²) − (a² − 2ab + b²)

Therefore:

y = 4ab

I intentionally implemented the original expression using intermediate signals to practice RTL translation and signed arithmetic.

📊 Synthesis Result

My Implementation

Metric

Result

Area

0.5%

Performance

37.8%

Status

✅ PASSED

Reference Implementation

Metric

Result

Area

37.8%

Performance

18.1%

The exact meaning of the benchmark percentages depends on the synthesis platform and its scoring methodology.

🧠 What I Learned

Signed arithmetic in SystemVerilog

Signal width selection

Continuous assignments using assign

Combinational RTL design

Translating mathematical equations into hardware

Using intermediate signals

Understanding declaration assignments vs. continuous assignments

Comparing my synthesis result with a reference implementation

✅ Result

Implementation successfully passed the automated tests.

This was a useful exercise in converting a mathematical expression into synthesizable SystemVerilog while understanding how different RTL descriptions can produce different synthesis results.

Status: PASSED ✅
