module MEMWB_Reg(WBout, ADDout, DMout, Rdout, WBin, ADDin, DMin, Rdin, clk, rst);

output [31:0] ADDout, DMout;
output [4:0] Rdout;
output [1:0] WBout;
input [31:0] ADDin, DMin;
input [4:0] Rdin;
input [1:0] WBin;
input clk, rst;
	
reg [70:0] state;
	
always @(posedge clk) begin
  if (rst == 1'b1)begin
    state <= 0;
  end
  else begin
    state <= {WBin, DMin, ADDin, Rdin};
  end
		
end //always

assign {WBout, DMout, ADDout, Rdout} = state;

endmodule
