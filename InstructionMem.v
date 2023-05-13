//For simulation use only//
//Not synthesizeable//

`timescale 1ns/1ps

module InstructionMem(out, address);

output [31:0] out;
input [31:0] address;

reg [31:0] Regs [0:255];

initial begin
  $readmemh("Program.txt", Regs);
end

assign out = Regs[address];


endmodule
