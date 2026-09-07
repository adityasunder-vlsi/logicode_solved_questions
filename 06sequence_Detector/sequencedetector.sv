module seq_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  logic [3:0] seq = 4'b1010;
  logic arr[3]; 

  always_ff @(posedge clk) begin
    if (!resetn) begin
      arr[0] <= 0;
      arr[1] <= 0;
      arr[2] <= 0;
    end
    else begin
      arr[0] <= arr[1];
      arr[1] <= arr[2];
      arr[2] <= din;
    end
  end

  assign dout = (arr[0]==seq[3] && arr[1]==seq[2] && arr[2]==seq[1] && din==seq[0]);

endmodule
