module int_sqrt2 (   
    input  logic signed [15:0] in_0,  
       output logic signed [ 7:0] out ); 
       always_comb begin   
        if ( in_0 < 0)begin   
            out = 0;  
           end  else  begin    
           for (int i=0;i<=181;i++)begin  
             if(i*i <= in_0)begin 
               out = i;     
              end    
              end
             end
       end
endmodule
