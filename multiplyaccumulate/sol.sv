
module pipeline_multiply_accumulate #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  valid_in,
    input  logic                  accum_clr,
    input  logic [DATA_WIDTH-1:0] A,
    input  logic [DATA_WIDTH-1:0] B,
    output logic                  valid_out,
    output logic [ACC_WIDTH-1:0]  result
);

    logic [2*DATA_WIDTH-1:0] product_reg;
    logic                   valid_reg;
    logic                   accum_clr_reg;
    logic [ACC_WIDTH-1:0]   sum;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            product_reg   <= '0;
            valid_reg     <= 1'b0;
            accum_clr_reg <= 1'b0;
        end
        else begin
            product_reg   <= A * B;
            valid_reg     <= valid_in;
            accum_clr_reg <= accum_clr & valid_in;
        end
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            sum       <= '0;
            result    <= '0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_reg;

            if (valid_reg) begin
                if (accum_clr_reg) begin
                    sum    <= product_reg[ACC_WIDTH-1:0];
                    result <= product_reg[ACC_WIDTH-1:0];
                end
                else begin
                    sum    <= sum + product_reg;
                    result <= sum + product_reg;
                end
            end
        end
    end

endmodule
