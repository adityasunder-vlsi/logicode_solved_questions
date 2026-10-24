module fixed_point_adder #(
    parameter Q = 15,
    parameter N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    output logic [N-1:0] c
);
logic[N-2:0] ma, mb , mc;
logic sa, sb , sc;

assign sa = a[N-1];
assign sb = b[N-1];
assign ma = a[N-2:0];
assign mb = b[N-2:0];
assign c = {sc, mc};
   always_comb begin
    if(sa == sb)begin
      sc = sa;
      mc = ma+ mb;
    end
      else begin
        if(mb<ma)begin
          sc = sa;
          mc = ma - mb;
        end
          else if(mb>ma)begin
            sc = sb;
            mc = mb - ma;
          end
          else begin
          sc = 0;
          mc = 0;
      end
      end
   end
endmodule
