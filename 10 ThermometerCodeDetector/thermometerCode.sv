module thermo_code_detector (
    input logic [7:0] codeIn,
    output logic isThermometer
);
  logic [ 7:0] transition_count ;
  always_comb begin
    isThermometer = 0;
    transition_count = 8'b00000000;
  for(int i=0;i<7;i++)begin
    if( codeIn[i] != codeIn[i+1])begin
      transition_count++;
    end
  end
    if(transition_count == 1)begin
      isThermometer = 1;
   
  end
  end
endmodule


