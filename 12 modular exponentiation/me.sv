module mod_exp (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic [3:0] m,
    output logic [3:0] y
);

    logic [7:0] result, base;

    always @(*) begin
        if (m == 0)
            y = 0;
        else begin
            result = 1 % m;
            base = a % m;

            for (int i = 0; i < 4; i = i + 1) begin
                if (b[i])
                    result = (result * base) % m;

                base = (base * base) % m;
            end

            y = result[3:0];
        end
    end

endmodule
