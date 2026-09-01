
module dot_prod (
    input  logic [7:0] din,
    input  logic clk,
    input  logic resetn,
    output logic [17:0] dout,
    output logic run
);

    logic [7:0] a1, a2, a3;
    logic [7:0] b1, b2, b3;
    logic [2:0] count;

    always_ff @(posedge clk) begin

        if (!resetn) begin
            dout  <= 0;
            run   <= 1;
            count <= 0;
        end

        else begin

            if (count == 0) begin
                a1 <= din;
            end

            if (count == 1) begin
                a2 <= din;
            end

            if (count == 2) begin
                a3 <= din;
            end

            if (count == 3) begin
                b1 <= din;
            end

            if (count == 4) begin
                b2 <= din;
            end

            if (count == 5) begin
                b3   <= din;
                run  <= 1;
                dout <= a1*b1 + a2*b2 + a3*din;
                count <= 0;
            end

            else begin
                run <= 0;
                count <= count + 1;
            end

        end
    end

endmodule
