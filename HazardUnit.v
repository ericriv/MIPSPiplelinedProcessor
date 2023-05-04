module HazardUnit(IDEXMemRead, EXMEMMemRead, IDEXRt, EXMEMRt, IFIDRs, IFIDRt, branch, compres, IFIDWrite, PCWrite, nop, IFFlush);

input IDEXMemRead, EXMEMMemRead, branch, compres;
input [4:0] IDEXRt, EXMEMRt, IFIDRs, IFIDRt;
output reg IFIDWrite, PCWrite, nop, IFFlush;


always@(*)begin 
//loading hazard detection
  if(IDEXMemRead == 1'b1) begin
    if(IDEXRt == IFIDRs || IDEXRt == IFIDRt) begin
      nop = 1'b1;
      PCWrite = 1'b0;
      IFIDWrite = 1'b0;
    end
  end

//branch hazards
  else if(branch == 1'b1) begin
    if(IDEXMemRead == 1'b1) begin
      if(IDEXRt == IFIDRs || IDEXRt == IFIDRt) begin
        nop = 1'b1;
        PCWrite = 1'b0;
        IFIDWrite = 1'b0;
      end
    end
    else if(EXMEMMemRead == 1'b1)begin //if loading to register used in branch 2nd instr before branch
      if(EXMEMRt == IFIDRs || EXMEMRt == IFIDRt)begin 
        nop = 1'b1;
        PCWrite = 1'b0;
        IFIDWrite = 1'b0;
      end
    end
    else if(compres == 1'b1)begin //if actually branching
      nop = 1'b0;
      PCWrite = 1'b1;
      IFIDWrite = 1'b1;
      IFFlush = 1'b1;
    end//compres
  end //branch
  else begin
    nop = 1'b0;
    PCWrite = 1'b1;
    IFIDWrite = 1'b1;
    IFFlush = 1'b0;
  end //else
end //always

endmodule
