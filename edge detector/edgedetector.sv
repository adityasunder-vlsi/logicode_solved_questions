module edge_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
    logic  din_early;       

  always_ff @(posedge clk) begin
    if (!resetn) begin
      dout <= 0;
      din_early <= 0;
    
    end
    else begin
      din_early<= din;
     dout<= (din_early == 0) && (din == 1);
    end
  end
endmodule
