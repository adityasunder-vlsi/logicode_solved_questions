module elevator_cont (
    input logic clk,
    input logic reset,
    input logic up_request,
    input logic down_request,
    output logic [1:0] state
);
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00;
    end
    else begin
      case (state)
        2'b00: begin
          if (up_request) begin
            state <= 2'b01;
          end
          else if (down_request) begin
            state <= 2'b10;
          end
        end
        2'b01: begin
          if (up_request) begin
            state <= 2'b01;
          end
          else begin
            state <= 2'b00;
          end
        end
        2'b10: begin
          if (down_request) begin
            state = 2'b10;
          end
          else begin
            state = 2'b00;
          end
        end
      endcase
    end
  end
endmodule
