module polynomial_5(
    input  logic signed [7:0] a,
    input  logic signed [7:0] b,
    output logic signed [17:0] y
);

    always_comb begin
        y = (a + b) * (a + b) - (a - b) * (a - b);
    end

endmodule
