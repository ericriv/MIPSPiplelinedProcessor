module DataMem(out, in, address, write, clk);

output reg [31:0] out;
input [31:0] in, address;
input write, clk;

reg [31:0] Regs [0:31];

always@(negedge clk) begin
  if(write == 1)  begin
      Regs[address] <= in;
  end
end

always@(posedge clk) begin
  out <= Regs[address];
end


endmodule
