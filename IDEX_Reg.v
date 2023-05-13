module IDEX_Reg(WBin,  Min,  EXin,  R1DATin, R2DATin,  SEin,  Rtin,
		Rdin, Rsin, WBout, Mout, EXout, R1DATout, R2DATout,
		SEout, Rtout, Rdout, Rsout, clk, rst);

output [31:0] R1DATout, R2DATout,  SEout;
output [4:0] Rtout, Rdout, Rsout;
output [1:0] WBout;
output [1:0] Mout;
output [3:0] EXout;
input [31:0] R1DATin, R2DATin, SEin;
input [4:0] Rtin, Rdin, Rsin;
input [1:0] WBin;
input [1:0] Min;
input [3:0] EXin;
input clk, rst;

	
reg [118:0] state;
	
always @(posedge clk) begin
  if (rst == 1'b1)begin
    state <= 119'b0;
  end
  else begin
    state <= {WBin,  Min,  EXin,  R1DATin, R2DATin,  SEin,  Rtin, Rdin, Rsin};
  end
		
end //always

assign {WBout, Mout, EXout, R1DATout, R2DATout, SEout, Rtout, Rdout, Rsout} = state;

endmodule
