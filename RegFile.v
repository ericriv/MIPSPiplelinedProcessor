module RegFile(clk, in, R1addr, R2addr, WRaddr, RegWrite, R1out, R2out);

input clk;
input [31:0] in;
input [4:0] R1addr, R2addr, WRaddr;
input RegWrite;
output [31:0] R1out, R2out;

reg [31:0] Regs [0:31];

always@(negedge clk) begin
  if(RegWrite == 1)  begin
      Regs[WRaddr] <= in;
  end
end


assign  R1out = Regs[R1addr];
assign  R2out = Regs[R2addr];


endmodule
