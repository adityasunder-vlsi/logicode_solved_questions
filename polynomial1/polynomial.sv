module polynomial_1 (
    input  logic signed [ 7:0] x,
    output logic signed [15:0] y,
);
   logic signed [ 15:0] x_ext;
   assign x_ext = x;
  assign y = x_ext*x_ext + 16'sd2*x_ext + 16'sd1;
endmodule
