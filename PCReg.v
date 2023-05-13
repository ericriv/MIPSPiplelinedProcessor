module PCReg(out, in, clk, reset, write);

output [31:0] out;
input [31:0] in;
input clk, reset, write;

reg [31:0] state;

always@(posedge clk) begin
  if(reset == 1'b1) begin
    state <= 32'b0;
  end
  else begin
    if(write == 1'b1)
      state <= in;
  end
end

assign out = state;

endmodule
