module fib_gen #(
    parameter int DATA_WIDTH = 32
) (
    input  logic                  clk,
    input  logic                  resetn,
    output logic [DATA_WIDTH-1:0] fib
);
  logic[DATA_WIDTH-1:0]current ;
  logic[DATA_WIDTH-1:0]prev ;
  assign fib = prev;
  always_ff@(posedge clk )begin
    if(!resetn)begin
      current <= 1;
      prev <= 1;

    end
    else begin
     prev <= current;
     current <= current + prev;  
  end
  end
endmodule
