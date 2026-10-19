module div_by_three (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  logic [1:0] rem;       
  logic [1:0] next_rem;  
  assign next_rem = (2 * rem + din) % 3;

  always_ff @(posedge clk) begin
    if (!resetn) begin
      rem  <= 0;
      dout <= 0;
    end
    else begin
      rem  <= next_rem;
      dout <= (next_rem == 0);
    end
  end
endmodule
