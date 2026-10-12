module fizzbuzz #(
    parameter FIZZ = 3,
    BUZZ = 5,
    MAX_CYCLES = 100
) (
    input  logic clk,
    input  logic resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);
  logic[31:0] count ;
  always_ff @(posedge clk) begin
    if (!resetn) begin
      count    <= 0;
    end
    if (resetn) begin
      if (count == MAX_CYCLES - 1) begin
        count <= 0;
      end else begin
        count <= count + 1;
      end

      end
    end
    assign fizz  = (count % FIZZ == 0);
    assign buzz  = (count % BUZZ == 0);
    assign fizzbuzz = fizz&&buzz;  
endmodule
