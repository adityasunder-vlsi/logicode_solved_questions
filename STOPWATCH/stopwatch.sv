
module stopwatch (
    input  logic       clk,
    input  logic       rst,
    output logic [5:0] hours,
    output logic [5:0] mins,
    output logic [5:0] secs
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        hours <= 0;
        mins  <= 0;
        secs  <= 0;
    end
    else begin
        if (secs == 59) begin
            secs <= 0;

            if (mins == 59) begin
                mins <= 0;

                if (hours == 23)
                    hours <= 0;
                else
                    hours <= hours + 1'b1;
            end
            else
                mins <= mins + 1'b1;
        end
        else
            secs <= secs + 1'b1;
    end
end

endmodule
