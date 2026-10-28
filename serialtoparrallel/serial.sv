module serial2parallel (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       din_serial,
    input  logic       din_valid,
    output logic [7:0] dout_parallel,
    output logic       dout_valid
);
  logic [2:0] count;
  logic [7:0] shift;
  logic       full;   

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count         <= 0;
      shift         <= 0;
      full          <= 0;
      dout_parallel <= 0;
      dout_valid    <= 0;
    end
    else begin
      dout_valid <= full;
      full       <= 0;
      if (full) begin
        dout_parallel <= shift;
        count         <= 0;
      end
      else if (din_valid) begin
        shift <= {shift[6:0], din_serial};
        if (count == 7) begin
          full  <= 1;
          count <= 0;
        end
        else begin
          count <= count + 1;
        end
      end
      else begin
        count <= 0;
      end
    end
  end
endmodule
