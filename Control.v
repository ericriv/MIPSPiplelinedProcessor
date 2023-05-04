module Control(WB, M, EX, IFFlush, Instruction);

output [1:0] WB;
output [2:0] M;
output [7:0] EX;
output reg IFFlush;
input [5:0] Instruction;

reg RegDest, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
reg [1:0] ALUOp;

always@(*) begin
  case(Instruction)
    6'h0: begin
      RegWrite = 1'b1;
      MemToReg = 1'b0;
      Branch = 1'b0;
      MemRead = 1'b0;
      MemWrite = 1'b0;
      RegDest = 1'b1;
      ALUOp = 2'b10;
      ALUSrc = 1'b0;
      IFFlush = 1'b0;
    end
    default: begin
      {RegWrite, MemToReg, Branch, MemRead,
       MemWrite, RegDest, ALUOp, ALUSrc, IFFlush} = 14'b0;
    end
  endcase
end


assign WB = {RegWrite, MemToReg};
assign M = {Branch, MemRead, MemWrite};
assign EX = {RegDest, ALUOp, ALUSrc};

endmodule
