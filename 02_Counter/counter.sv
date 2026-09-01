
module counter #(
    parameter MAX = 99,
    parameter DATA_WIDTH = 16
) (
    input logic clk,
    input logic reset,
    input logic start,
    input logic stop,
    output logic [DATA_WIDTH-1:0] count
);

logic running = 0;

always_ff @(posedge clk) begin

    if (reset) begin
        count <= 0;
        running <= 0;
    end

    else if (stop) begin
        running <= 0;
    end

    else if (start) begin
        running <= 1;

        if (count == MAX)
            count <= 0;
        else
            count <= count + 1;
    end

    else if (running) begin

        if (count == MAX)
            count <= 0;
        else
            count <= count + 1;

    end

end

endmodule
