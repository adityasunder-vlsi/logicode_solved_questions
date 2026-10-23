module parallel_prefix_sum #(
    parameter N = 8,
    parameter W = 8
) (
    input  logic [N*W-1:0] data_in,  
    output logic [N*W-1:0] data_out ,
);
  
  logic [W-1:0] arr [N];
  logic [W-1:0] sum [N]; 

  always_comb begin
    for (int i = 0; i < N; i++) begin
      arr[i] = data_in[W*i +: W];
    end
    sum[0] = arr[0]; 
    for (int i = 1; i < N; i++) begin
      sum[i] = sum[i-1] + arr[i]; 
    end

    for (int i = 0; i < N; i++) begin
      data_out[W*i +: W] = sum[i];
    end
  end

endmodule
