module ForwardingUnit(IDEXRs, IDEXRt, EXMEMRegWrite, EXMEMRd, MEMWBRd, MEMWBRegWrite, ForwardA, ForwardB);

input [4:0] EXMEMRd, MEMWBRd, IDEXRs, IDEXRt;
input EXMEMRegWrite;    
input MEMWBRegWrite;    
output reg [1:0] ForwardA;  
output reg [1:0] ForwardB;  

always @(*) begin
  case({EXMEMRegWrite,MEMWBRegWrite})
    2'b00: begin //none active
      ForwardA <= 2'b00;
      ForwardB <= 2'b00;
    end
    2'b01: begin //MEMWBRegWrite active
      if(MEMWBRd != 0 && MEMWBRd == IDEXRs)
        ForwardA <= 2'b01;
      if(MEMWBRd != 0 && MEMWBRd == IDEXRt)
        ForwardB <= 2'b01;
    end
    2'b10: begin //EXMEMRegWrite active
      if(EXMEMRd != 0 && EXMEMRd == IDEXRs)
        ForwardA <= 2'b10;
      if(EXMEMRd != 0 && EXMEMRd == IDEXRt)
        ForwardB <= 2'b10;
    end
    2'b11: begin //both active
      if(EXMEMRd != 0 && EXMEMRd == IDEXRs) //want most recent data if double data hazard
        ForwardA <= 2'b10;
      else if(MEMWBRd != 0 && MEMWBRd == IDEXRs )
        ForwardA <= 2'b01;
      if(EXMEMRd != 0 && EXMEMRd == IDEXRt) //want most recent data if double data hazard
        ForwardB <= 2'b10;
      else if(MEMWBRd != 0 && MEMWBRd == IDEXRt)
        ForwardB <= 2'b01;
    end
    default: begin //default case
      ForwardA <= 1'b0;
      ForwardB <= 1'b0;
    end
  endcase
end // end always    
endmodule
