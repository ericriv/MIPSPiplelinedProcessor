module InstructionMem(out, address, clk);

output reg [31:0] out;
input [31:0] address;
input clk;

reg [31:0] Regs [0:31];

//need to assign the registers instruction data

always@(posedge clk) begin
  out <= Regs[address];
end


endmodule
