
module int_sqrt2 (
    input  logic signed [15:0] in_0,
    output logic signed [7:0] root
);
    logic [7:0] trial_root;

    always_comb begin
        root = 0;
        trial_root = 0;

        if (in_0 >= 0) begin
            for (int bit_pos = 7; bit_pos >= 0; bit_pos--) begin
                trial_root = root | (8'b1 << bit_pos);
                if (trial_root * trial_root <= in_0)
                    root = trial_root;
            end
        end
    end
