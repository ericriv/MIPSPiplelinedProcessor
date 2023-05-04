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
    6'h0: begin //Rtype
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
    6'h23: begin //lw
      RegWrite = 1'b1;
      MemToReg = 1'b1;
      Branch = 1'b0;
      MemRead = 1'b1;
      MemWrite = 1'b0;
      RegDest = 1'b0;
      ALUOp = 2'b00;
      ALUSrc = 1'b1;
      IFFlush = 1'b0;
    end
    6'h2b: begin //sw
      RegWrite = 1'b0;
      MemToReg = 1'b0;
      Branch = 1'b0;
      MemRead = 1'b0;
      MemWrite = 1'b1;
      RegDest = 1'b0;
      ALUOp = 2'b00;
      ALUSrc = 1'b1;
      IFFlush = 1'b0;
    end
    6'h04: begin //beq
      RegWrite = 1'b0;
      MemToReg = 1'b0;
      Branch = 1'b1;
      MemRead = 1'b0;
      MemWrite = 1'b0;
      RegDest = 1'b0;
      ALUOp = 2'b01;
      ALUSrc = 1'b0;
      IFFlush = 1'b0;
    end
    6'h02: begin //jump may be broken... implemented same as branch atm
      RegWrite = 1'b0;
      MemToReg = 1'b0;
      Branch = 1'b1;
      MemRead = 1'b0;
      MemWrite = 1'b0;
      RegDest = 1'b0;
      ALUOp = 2'b01;
      ALUSrc = 1'b0;
      IFFlush = 1'b1;
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
