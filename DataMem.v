//For simulation use only//
//Not synthesizeable//

`timescale 1ns/1ps

module DataMem(out, in, address, write, clk);

output [31:0] out;
input [31:0] in, address;
input write, clk;

reg [31:0] Regs [0:255];

initial
  $readmemh("Memory.txt", Regs);

always@(posedge clk) begin
  if(write == 1'b1)  begin
      Regs[address] <= in;
  end
  $writememh("Memory.txt", Regs);
end


assign out = Regs[address];


endmodule
