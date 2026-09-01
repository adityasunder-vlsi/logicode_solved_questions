module bin_to_thermo #(
    parameter DIN_WIDTH = 8
) (
    input logic [DIN_WIDTH-1:0] din,
    output logic [2**DIN_WIDTH-1:0] dout
);

    always@(*) begin
        dout = (1 << din) - 1;
        $display("dout:%0b",dout);
    end

endmodule
