module divide_by_evens_clock (
    input  logic clk,
    input  logic resetn,
    output logic div2,
    output logic div4,
    output logic div6
 );   
    logic[2:0] counter;
    always_ff@(posedge clk)begin
      if(!resetn)begin
        div2 <= 0;
        div4 <= 0;
        div6 <= 0;
        counter <= 0;
      end
         else begin
            if (counter == 5) begin     
         counter <= 0;
           end else begin
           counter <= counter + 1;
             end
         div2 <= ~div2;
       if (counter == 0 || counter == 3) begin
         div6 <= ~div6;
        end
      if (counter == 0 || counter == 2 || counter == 4) begin
          div4 <= ~div4;
        end
     end
    end
endmodule
